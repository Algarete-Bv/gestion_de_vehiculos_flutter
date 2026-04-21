import 'package:flutter/material.dart';

import '../models/videos/video_model.dart';
import '../repositories/videos_repository.dart';

/// Provider para manejar el estado del módulo de videos.
class VideosProvider extends ChangeNotifier {
  final VideosRepository _repository;

  VideosProvider(this._repository);

  bool isLoading = false;
  String? errorMessage;
  List<VideoModel> videos = [];

  Future<void> fetchVideos() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      videos = await _repository.getVideos();
    } catch (e) {
      errorMessage = 'No se pudieron cargar los videos. Error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}