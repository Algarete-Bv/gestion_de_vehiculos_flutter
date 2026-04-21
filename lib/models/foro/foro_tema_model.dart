/// Modelo que representa un tema del foro
/// mostrado en el listado principal.
///
/// Se utiliza para cargar cada tarjeta
/// del foro dentro de la pantalla general.
///
/// Guarda informacion basica como:
/// - id del tema
/// - titulo
/// - descripcion corta
/// - autor
/// - vehiculo relacionado
/// - imagen
/// - cantidad de respuestas
/// - fecha de publicacion
class ForoTemaModel {
  /// Identificador unico del tema.
  final int id;

  /// Titulo principal del tema.
  final String titulo;

  /// Descripcion o contenido breve.
  final String descripcion;

  /// Nombre del autor que publico el tema.
  final String autor;

  /// Vehiculo relacionado con el tema.
  final String vehiculo;

  /// Imagen del tema o del vehiculo.
  final String fotoUrl;

  /// Cantidad total de respuestas.
  final int cantidadRespuestas;

  /// Fecha de publicacion.
  final String fecha;

  /// Constructor principal.
  const ForoTemaModel({
    required this.id,
    required this.titulo,
    required this.descripcion,
    required this.autor,
    required this.vehiculo,
    required this.fotoUrl,
    required this.cantidadRespuestas,
    required this.fecha,
  });

  /// Crea una instancia desde JSON.
  ///
  /// Este modelo acepta distintos nombres
  /// de campos enviados por la API.
  ///
  /// Ejemplo:
  /// titulo o title
  /// autor o usuario
  /// foto o image
  factory ForoTemaModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return ForoTemaModel(
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

      cantidadRespuestas: _parseInt(
        json['cantidadRespuestas'] ??
            json['respuestas_count'] ??
            json['totalRespuestas'],
      ),

      fecha: _parseString(
        json['fecha'] ??
            json['created_at'],
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