/// Modelo que representa un vehiculo
/// dentro del listado del catalogo.
///
/// Se utiliza para mostrar cada vehiculo
/// en la pantalla principal del catalogo.
///
/// Guarda informacion basica como:
/// - id
/// - marca
/// - modelo
/// - año
/// - precio
/// - descripcion corta
/// - imagen principal
class CatalogoItemModel {
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

  /// Descripcion breve.
  final String descripcion;

  /// URL de la imagen principal.
  final String imagenUrl;

  /// Constructor principal.
  const CatalogoItemModel({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.precio,
    required this.descripcion,
    required this.imagenUrl,
  });

  /// Crea una instancia desde JSON.
  ///
  /// Soporta distintos nombres posibles
  /// enviados por la API.
  ///
  /// Ejemplo:
  /// anio o ano
  /// imagen o image
  /// descripcion o resumen
  factory CatalogoItemModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return CatalogoItemModel(
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
            json['descripcion_corta'] ??
            json['resumen'],
      ),

      imagenUrl: _parseString(
        json['imagen'] ??
            json['imagenUrl'] ??
            json['foto'] ??
            json['image'],
      ),
    );
  }

  /// Retorna marca y modelo unidos.
  ///
  /// Ejemplo:
  /// Toyota Corolla
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
}