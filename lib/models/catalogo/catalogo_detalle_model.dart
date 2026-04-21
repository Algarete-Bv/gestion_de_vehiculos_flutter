/// Modelo que representa el detalle
/// completo de un vehiculo del catalogo.
///
/// Se utiliza cuando el usuario entra
/// a ver un vehiculo especifico.
///
/// Guarda informacion mas amplia que
/// el listado principal.
///
/// Incluye:
/// - id
/// - marca
/// - modelo
/// - año
/// - precio
/// - descripcion completa
/// - varias imagenes
/// - especificaciones tecnicas
class CatalogoDetalleModel {
  /// Identificador unico del vehiculo.
  final int id;

  /// Marca del vehiculo.
  final String marca;

  /// Modelo del vehiculo.
  final String modelo;

  /// Año del vehiculo.
  final String anio;

  /// Precio mostrado.
  final String precio;

  /// Descripcion completa.
  final String descripcion;

  /// Lista de imagenes del vehiculo.
  final List<String> imagenes;

  /// Informacion tecnica adicional.
  ///
  /// Puede incluir datos como:
  /// - motor
  /// - transmision
  /// - combustible
  /// - puertas
  /// - color
  final Map<String, dynamic>
  especificaciones;

  /// Constructor principal.
  const CatalogoDetalleModel({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.precio,
    required this.descripcion,
    required this.imagenes,
    required this.especificaciones,
  });

  /// Crea una instancia desde JSON.
  ///
  /// Soporta distintos nombres posibles
  /// enviados por la API.
  ///
  /// Ejemplo:
  /// anio o ano
  /// imagenes o galeria
  /// especificaciones o specs
  factory CatalogoDetalleModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CatalogoDetalleModel(
      id: _parseInt(json['id']),

      marca: _parseString(
        json['marca'],
      ),

      modelo: _parseString(
        json['modelo'],
      ),

      anio: _parseString(
        json['anio'] ??
            json['ano'],
      ),

      precio: _parseString(
        json['precio'],
      ),

      descripcion: _parseString(
        json['descripcion'] ??
            json['detalle'] ??
            json['contenido'],
      ),

      imagenes: _parseImages(
        json['imagenes'] ??
            json['galeria'] ??
            json['fotos'],
      ),

      especificaciones: _parseSpecs(
        json['especificaciones'] ??
            json['specs'] ??
            {},
      ),
    );
  }

  /// Retorna marca y modelo unidos.
  ///
  /// Ejemplo:
  /// Honda Civic
  String get nombreCompleto =>
      '$marca $modelo'.trim();

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

  /// Convierte datos dinamicos
  /// en lista de imagenes.
  ///
  /// Si llega una sola imagen,
  /// tambien la convierte en lista.
  static List<String> _parseImages(
      dynamic value,
      ) {
    if (value is List) {
      return value
          .map((e) => e.toString())
          .where(
            (e) => e.isNotEmpty,
      )
          .toList();
    }

    if (value is String &&
        value.isNotEmpty) {
      return [value];
    }

    return [];
  }

  /// Convierte datos dinamicos
  /// en mapa de especificaciones.
  static Map<String, dynamic>
  _parseSpecs(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    return {};
  }
}