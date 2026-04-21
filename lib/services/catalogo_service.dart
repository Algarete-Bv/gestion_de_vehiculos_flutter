import 'package:dio/dio.dart';

import '../core/network/dio_client.dart';
import '../models/catalogo/catalogo_detalle_model.dart';
import '../models/catalogo/catalogo_item_model.dart';

/// Servicio encargado de consumir los endpoints del catálogo.
///
/// Endpoints esperados:
/// - GET /catalogo
/// - GET /catalogo/detalle?id=
class CatalogoService {
  final Dio _dio = DioClient().dio;

  Future<List<CatalogoItemModel>> getCatalogo({
    String? marca,
    String? modelo,
    String? anio,
    String? precioMin,
    String? precioMax,
  }) async {
    final response = await _dio.get(
      'catalogo',
      queryParameters: {
        'marca': marca?.trim().isNotEmpty == true ? marca!.trim() : null,
        'modelo': modelo?.trim().isNotEmpty == true ? modelo!.trim() : null,
        'anio': anio?.trim().isNotEmpty == true ? anio!.trim() : null,
        'precioMin':
        precioMin?.trim().isNotEmpty == true ? precioMin!.trim() : null,
        'precioMax':
        precioMax?.trim().isNotEmpty == true ? precioMax!.trim() : null,
      },
    );

    final data = response.data;
    final lista = _extractList(data);

    return lista
        .whereType<Map<String, dynamic>>()
        .map(CatalogoItemModel.fromJson)
        .toList();
  }

  Future<CatalogoDetalleModel> getCatalogoDetalle(int id) async {
    final response = await _dio.get(
      'catalogo/detalle',
      queryParameters: {'id': id},
    );

    final data = _extractMap(response.data);
    return CatalogoDetalleModel.fromJson(data);
  }

  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;

    if (data is Map<String, dynamic>) {
      final nested = data['data'] ?? data['items'] ?? data['catalogo'];
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