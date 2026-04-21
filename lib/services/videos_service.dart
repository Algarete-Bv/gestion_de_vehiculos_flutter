import 'package:dio/dio.dart';

import '../core/network/dio_client.dart';
import '../models/videos/video_model.dart';

/// Servicio para consumir los endpoints del módulo de videos.
///
/// Endpoint esperado:
/// - GET /videos
class VideosService {
  final Dio _dio = DioClient().dio;

  Future<List<VideoModel>> getVideos() async {
    final response = await _dio.get('videos');

    final dynamic responseData = response.data;
    final List<dynamic> lista = _extractList(responseData);

    return lista
        .whereType<Map<String, dynamic>>()
        .map(VideoModel.fromJson)
        .toList();
  }

  /// Extrae una lista desde posibles respuestas del backend:
  /// - [ ... ]
  /// - { data: [ ... ] }
  /// - { videos: [ ... ] }
  /// - { items: [ ... ] }
  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;

    if (data is Map<String, dynamic>) {
      final dynamic nestedData = data['data'] ?? data['videos'] ?? data['items'];
      if (nestedData is List) return nestedData;
    }

    return [];
  }
}