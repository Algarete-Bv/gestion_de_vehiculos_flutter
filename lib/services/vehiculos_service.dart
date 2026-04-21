import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../core/network/dio_client.dart';
import '../models/vehiculos/vehiculo_detalle_model.dart';
import '../models/vehiculos/vehiculo_item_model.dart';

/// Servicio para consumir los endpoints del módulo de vehículos.
///
/// Endpoints esperados:
/// - GET /vehiculos?marca=&modelo=&page=&limit=
/// - POST /vehiculos
/// - GET /vehiculos/detalle?id=
/// - POST /vehiculos/editar
/// - POST /vehiculos/foto
class VehiculosService {
  final Dio _dio = DioClient().dio;

  Future<List<VehiculoItemModel>> getVehiculos({
    String? marca,
    String? modelo,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dio.get(
      'vehiculos',
      queryParameters: {
        'marca': marca?.trim().isNotEmpty == true ? marca!.trim() : null,
        'modelo': modelo?.trim().isNotEmpty == true ? modelo!.trim() : null,
        'page': page,
        'limit': limit,
      },
    );

    final lista = _extractList(response.data);

    return lista
        .whereType<Map<String, dynamic>>()
        .map(VehiculoItemModel.fromJson)
        .toList();
  }

  Future<VehiculoDetalleModel> getVehiculoDetalle(int id) async {
    final response = await _dio.get(
      'vehiculos/detalle',
      queryParameters: {'id': id},
    );

    return VehiculoDetalleModel.fromJson(_extractMap(response.data));
  }

  /// Crea un vehículo nuevo.
  ///
  /// Si [foto] existe, se manda en multipart/form-data junto con `datax`.
  Future<void> crearVehiculo({
    required String placa,
    required String chasis,
    required String marca,
    required String modelo,
    required String anio,
    required String cantidadRuedas,
    File? foto,
  }) async {
    final payload = {
      'placa': placa.trim(),
      'chasis': chasis.trim(),
      'marca': marca.trim(),
      'modelo': modelo.trim(),
      'anio': anio.trim(),
      'cantidadRuedas': cantidadRuedas.trim(),
    };

    if (foto == null) {
      await _dio.post(
        'vehiculos',
        data: {
          'datax': jsonEncode(payload),
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      return;
    }

    final fileName = foto.path.split(Platform.pathSeparator).last;

    final formData = FormData.fromMap({
      'datax': jsonEncode(payload),
      'foto': await MultipartFile.fromFile(
        foto.path,
        filename: fileName,
      ),
    });

    await _dio.post(
      'vehiculos',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );
  }

  /// Edita los datos de un vehículo existente.
  Future<void> editarVehiculo({
    required int id,
    required String placa,
    required String chasis,
    required String marca,
    required String modelo,
    required String anio,
    required String cantidadRuedas,
  }) async {
    final payload = {
      'id': id,
      'placa': placa.trim(),
      'chasis': chasis.trim(),
      'marca': marca.trim(),
      'modelo': modelo.trim(),
      'anio': anio.trim(),
      'cantidadRuedas': cantidadRuedas.trim(),
    };

    await _dio.post(
      'vehiculos/editar',
      data: {
        'datax': jsonEncode(payload),
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
  }

  /// Sube o cambia la foto de un vehículo existente.
  ///
  /// El backend está pidiendo `id` dentro de `datax`, no `vehiculo_id`.
  Future<void> subirFotoVehiculo({
    required int vehiculoId,
    required File foto,
  }) async {
    final fileName = foto.path.split(Platform.pathSeparator).last;

    final formData = FormData.fromMap({
      'datax': jsonEncode({
        'id': vehiculoId,
      }),
      'foto': await MultipartFile.fromFile(
        foto.path,
        filename: fileName,
      ),
    });

    await _dio.post(
      'vehiculos/foto',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;

    if (data is Map<String, dynamic>) {
      final nested = data['data'] ?? data['items'] ?? data['vehiculos'];
      if (nested is List) return nested;
    }

    return [];
  }

  Map<String, dynamic> _extractMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      final nested = data['data'];
      if (nested is Map<String, dynamic>) return nested;
      return data;
    }

    return {};
  }
}