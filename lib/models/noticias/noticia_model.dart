/// Modelo que representa una noticia
/// mostrada en el listado principal.
///
/// Este modelo guarda la informacion basica
/// de cada noticia recibida desde la API.
///
/// Incluye:
/// - id
/// - titulo
/// - resumen
/// - fecha
/// - imagen principal
///
/// Tambien intenta adaptarse a distintos
/// nombres de campos del backend.
class NoticiaModel {
  /// Identificador unico de la noticia.
  final int id;

  /// Titulo principal.
  final String titulo;

  /// Texto corto o resumen.
  final String resumen;

  /// Fecha de publicacion.
  final String fecha;

  /// URL de imagen principal.
  final String imagenUrl;

  /// Constructor principal.
  const NoticiaModel({
    required this.id,
    required this.titulo,
    required this.resumen,
    required this.fecha,
    required this.imagenUrl,
  });

  /// Crea una instancia desde JSON.
  ///
  /// Soporta distintos nombres comunes
  /// que pueden venir desde la API.
  ///
  /// Ejemplo:
  /// titulo o title
  /// resumen o descripcion
  /// imagen o image
  factory NoticiaModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return NoticiaModel(
      id: _parseInt(json['id']),

      titulo: _parseString(
        json['titulo'] ??
            json['title'],
      ),

      resumen: _parseString(
        json['resumen'] ??
            json['descripcion'] ??
            json['extracto'],
      ),

      fecha: _parseString(
        json['fecha'] ??
            json['created_at'],
      ),

      imagenUrl: _parseString(
        json['imagen'] ??
            json['imagenUrl'] ??
            json['foto'] ??
            json['image'],
      ),
    );
  }

  /// Convierte cualquier valor a entero.
  ///
  /// Si falla, retorna 0.
  static int _parseInt(dynamic value) {
    if (value is int) return value;

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  /// Convierte cualquier valor a texto.
  ///
  /// Si viene null, retorna vacio.
  static String _parseString(
      dynamic value,
      ) {
    return value?.toString() ?? '';
  }
}