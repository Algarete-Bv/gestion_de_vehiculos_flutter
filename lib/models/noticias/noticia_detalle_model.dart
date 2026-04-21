/// Modelo que representa el detalle
/// completo de una noticia.
///
/// Este modelo se utiliza cuando el usuario
/// entra a leer una noticia especifica.
///
/// Guarda informacion mas amplia que el listado.
///
/// Incluye:
/// - id
/// - titulo
/// - fecha
/// - imagen principal
/// - contenido en formato HTML
///
/// El contenido HTML luego se muestra
/// en la pantalla de detalle.
class NoticiaDetalleModel {
  /// Identificador unico de la noticia.
  final int id;

  /// Titulo principal.
  final String titulo;

  /// Fecha de publicacion.
  final String fecha;

  /// URL de la imagen principal.
  final String imagenUrl;

  /// Contenido completo en HTML.
  ///
  /// Puede incluir:
  /// - texto
  /// - imagenes
  /// - enlaces
  /// - formato visual
  final String contenidoHtml;

  /// Constructor principal.
  const NoticiaDetalleModel({
    required this.id,
    required this.titulo,
    required this.fecha,
    required this.imagenUrl,
    required this.contenidoHtml,
  });

  /// Crea una instancia desde JSON.
  ///
  /// Soporta distintos nombres posibles
  /// enviados por la API.
  ///
  /// Ejemplo:
  /// titulo o title
  /// contenidoHtml o contenido
  /// imagen o image
  factory NoticiaDetalleModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return NoticiaDetalleModel(
      id: _parseInt(json['id']),

      titulo: _parseString(
        json['titulo'] ??
            json['title'],
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

      contenidoHtml: _parseString(
        json['contenidoHtml'] ??
            json['contenido'] ??
            json['html'] ??
            json['body'],
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