/// Modelo que representa una respuesta
/// dentro del detalle de un tema del foro.
///
/// Cada respuesta pertenece a un tema.
///
/// Guarda datos como:
/// - id
/// - autor
/// - contenido
/// - fecha
class ForoRespuestaModel {
  /// Identificador unico de la respuesta.
  final int id;

  /// Nombre del autor.
  final String autor;

  /// Texto de la respuesta.
  final String contenido;

  /// Fecha en que fue publicada.
  final String fecha;

  /// Constructor principal.
  const ForoRespuestaModel({
    required this.id,
    required this.autor,
    required this.contenido,
    required this.fecha,
  });

  /// Crea una instancia desde JSON.
  ///
  /// Soporta distintos nombres de campos
  /// enviados por la API.
  factory ForoRespuestaModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ForoRespuestaModel(
      id: _parseInt(json['id']),

      autor: _parseString(
        json['autor'] ??
            json['usuario'] ??
            json['nombre'],
      ),

      contenido: _parseString(
        json['contenido'] ??
            json['descripcion'] ??
            json['respuesta'],
      ),

      fecha: _parseString(
        json['fecha'] ??
            json['created_at'],
      ),
    );
  }

  /// Convierte cualquier valor a entero.
  ///
  /// Si falla retorna 0.
  static int _parseInt(dynamic value) {
    if (value is int) return value;

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  /// Convierte cualquier valor a texto.
  ///
  /// Si viene null retorna vacio.
  static String _parseString(
      dynamic value,
      ) {
    return value?.toString() ?? '';
  }
}

/// Modelo que representa el detalle
/// completo de un tema del foro.
///
/// Se usa cuando el usuario entra
/// a ver una publicacion especifica.
///
/// Incluye:
/// - titulo
/// - descripcion
/// - autor
/// - vehiculo relacionado
/// - imagen
/// - fecha
/// - respuestas publicadas
class ForoDetalleModel {
  /// Identificador unico del tema.
  final int id;

  /// Titulo del tema.
  final String titulo;

  /// Contenido principal del tema.
  final String descripcion;

  /// Autor del tema.
  final String autor;

  /// Vehiculo relacionado.
  final String vehiculo;

  /// Imagen del tema o vehiculo.
  final String fotoUrl;

  /// Fecha de publicacion.
  final String fecha;

  /// Lista de respuestas del tema.
  final List<ForoRespuestaModel> respuestas;

  /// Constructor principal.
  const ForoDetalleModel({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.autor,
    required this.vehiculo,
    required this.fotoUrl,
    required this.fecha,
    required this.respuestas,
  });

  /// Crea una instancia desde JSON.
  ///
  /// Acepta distintos nombres posibles
  /// enviados por la API.
  factory ForoDetalleModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ForoDetalleModel(
      id: _parseInt(json['id']),

      titulo: _parseString(
        json['titulo'] ??
            json['title'],
      ),

      descripcion: _parseString(
        json['descripcion'] ??
            json['contenido'] ??
            json['detalle'],
      ),

      autor: _parseString(
        json['autor'] ??
            json['usuario'] ??
            json['nombre'],
      ),

      vehiculo: _parseString(
        json['vehiculo'] ??
            json['vehiculo_nombre'] ??
            json['auto'],
      ),

      fotoUrl: _parseString(
        json['foto'] ??
            json['fotoUrl'] ??
            json['imagen'] ??
            json['image'],
      ),

      fecha: _parseString(
        json['fecha'] ??
            json['created_at'],
      ),

      respuestas: _parseRespuestas(
        json['respuestas'] ??
            json['comentarios'] ??
            json['items'],
      ),
    );
  }

  /// Convierte una lista dinamica
  /// en lista de respuestas.
  static List<ForoRespuestaModel>
  _parseRespuestas(dynamic value) {
    if (value is List) {
      return value
          .whereType<Map<String, dynamic>>()
          .map(
        ForoRespuestaModel.fromJson,
      )
          .toList();
    }

    return [];
  }

  /// Convierte cualquier valor a entero.
  static int _parseInt(dynamic value) {
    if (value is int) return value;

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
  }

  /// Convierte cualquier valor a texto.
  static String _parseString(
      dynamic value,
      ) {
    return value?.toString() ?? '';
  }
}