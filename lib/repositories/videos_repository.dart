import '../models/videos/video_model.dart';
import '../services/videos_service.dart';

/// Repositorio del módulo de videos.
///
/// Intermedia entre provider y service para mantener la arquitectura limpia.
class VideosRepository {
  final VideosService _service;

  VideosRepository(this._service);

  Future<List<VideoModel>> getVideos() {
    return _service.getVideos();
  }
}