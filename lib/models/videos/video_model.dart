/// Modelo que representa un video educativo del API.
///
/// Se hace tolerante a pequeñas variaciones en nombres de campos
/// para evitar errores si el backend cambia algún nombre.
class VideoModel {
  final int id;
  final String youtubeId;
  final String titulo;
  final String descripcion;
  final String categoria;
  final String url;
  final String thumbnail;

  const VideoModel({
    required this.id,
    required this.youtubeId,
    required this.titulo,
    required this.descripcion,
    required this.categoria,
    required this.url,
    required this.thumbnail,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: _parseInt(json['id']),
      youtubeId: _parseString(json['youtubeId'] ?? json['youtube_id']),
      titulo: _parseString(json['titulo'] ?? json['title']),
      descripcion: _parseString(json['descripcion'] ?? json['description']),
      categoria: _parseString(json['categoria'] ?? json['category']),
      url: _parseString(json['url'] ?? json['link']),
      thumbnail: _parseString(
        json['thumbnail'] ?? json['thumb'] ?? json['imagen'],
      ),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _parseString(dynamic value) {
    return value?.toString() ?? '';
  }

  /// Retorna una URL válida para abrir en YouTube si el API no la manda completa.
  String get resolvedUrl {
    if (url.isNotEmpty) return url;
    if (youtubeId.isNotEmpty) {
      return 'https://www.youtube.com/watch?v=$youtubeId';
    }
    return '';
  }

  /// Retorna un thumbnail válido si el API no lo manda completo.
  String get resolvedThumbnail {
    if (thumbnail.isNotEmpty) return thumbnail;
    if (youtubeId.isNotEmpty) {
      return 'https://img.youtube.com/vi/$youtubeId/hqdefault.jpg';
    }
    return '';
  }
}