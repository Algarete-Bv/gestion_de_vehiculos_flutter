import 'package:dio/dio.dart';

import '../core/network/dio_client.dart';
import '../models/noticias/noticia_detalle_model.dart';
import '../models/noticias/noticia_model.dart';

/// Servicio encargado de consumir los endpoints del módulo de noticias.
///
/// Endpoints esperados:
/// - GET /noticias
/// - GET /noticias/detalle?id=
class NoticiasService {
  final Dio _dio = DioClient().dio;

  /// Obtiene el listado de noticias.
  Future<List<NoticiaModel>> getNoticias() async {
    final response = await _dio.get('noticias');

    final dynamic responseData = response.data;
    final List<dynamic> lista = _extractList(responseData);

    return lista
        .whereType<Map<String, dynamic>>()
        .map(NoticiaModel.fromJson)
        .toList();
  }

  /// Obtiene el detalle de una noticia por su ID.
  Future<NoticiaDetalleModel> getNoticiaDetalle(int id) async {
    final response = await _dio.get(
      'noticias/detalle',
      queryParameters: {'id': id},
    );

    final dynamic responseData = response.data;
    final Map<String, dynamic> mapa = _extractMap(responseData);

    return NoticiaDetalleModel.fromJson(mapa);
  }

  /// Extrae una lista desde respuestas como:
  /// - [ ... ]
  /// - { data: [ ... ] }
  /// - { noticias: [ ... ] }
  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;

    if (data is Map<String, dynamic>) {
      final dynamic nestedData = data['data'] ?? data['noticias'] ?? data['items'];
      if (nestedData is List) return nestedData;
    }

    return [];
  }

  /// Extrae un mapa desde respuestas como:
  /// - { ... }
  /// - { data: { ... } }
  Map<String, dynamic> _extractMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      final dynamic nestedData = data['data'];
      if (nestedData is Map<String, dynamic>) return nestedData;
      return data;
    }

    return {};
  }
}