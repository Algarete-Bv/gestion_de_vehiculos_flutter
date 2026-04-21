import 'dart:convert';

import 'package:dio/dio.dart';

import '../core/network/dio_client.dart';
import '../models/foro/crear_tema_response.dart';
import '../models/foro/foro_detalle_model.dart';
import '../models/foro/foro_tema_model.dart';
import '../models/foro/responder_tema_response.dart';

/// Servicio encargado de consumir los endpoints del foro.
///
/// Públicos:
/// - GET /publico/foro
/// - GET /publico/foro/detalle?id=
///
/// Privados:
/// - POST /foro/crear
/// - POST /foro/responder
class ForoService {
  final Dio _dio = DioClient().dio;

  Future<List<ForoTemaModel>> getTemas() async {
    final response = await _dio.get('publico/foro');

    final data = response.data;
    final lista = _extractList(data);

    return lista
        .whereType<Map<String, dynamic>>()
        .map(ForoTemaModel.fromJson)
        .toList();
  }

  Future<ForoDetalleModel> getDetalle(int id) async {
    final response = await _dio.get(
      'publico/foro/detalle',
      queryParameters: {'id': id},
    );

    final data = _extractMap(response.data);
    return ForoDetalleModel.fromJson(data);
  }

  Future<CrearTemaResponse> crearTema({
    required int vehiculoId,
    required String titulo,
    required String descripcion,
  }) async {
    final payload = {
      'vehiculo_id': vehiculoId,
      'titulo': titulo.trim(),
      'descripcion': descripcion.trim(),
    };

    final response = await _dio.post(
      'foro/crear',
      data: {
        'datax': jsonEncode(payload),
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    return CrearTemaResponse.fromJson(response.data);
  }

  Future<ResponderTemaResponse> responderTema({
    required int temaId,
    required String contenido,
  }) async {
    final payload = {
      'tema_id': temaId,
      'contenido': contenido.trim(),
    };

    final response = await _dio.post(
      'foro/responder',
      data: {
        'datax': jsonEncode(payload),
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );

    return ResponderTemaResponse.fromJson(response.data);
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;

    if (data is Map<String, dynamic>) {
      final nested = data['data'] ?? data['temas'] ?? data['items'];
      if (nested is List) return nested;
    }

    return [];
  }

  Map<String, dynamic> _extractMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      if (data['data'] is Map<String, dynamic>) {
        return data['data'];
      }

      if (data['tema'] is Map<String, dynamic>) {
        return data['tema'];
      }

      if (data['detalle'] is Map<String, dynamic>) {
        return data['detalle'];
      }

      return data;
    }

    return {};
  }
}