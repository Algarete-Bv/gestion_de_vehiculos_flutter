/// Modelo para guardar los filtros usados
/// en la pantalla del catalogo.
///
/// Este modelo permite organizar mejor
/// los campos de busqueda del catalogo,
/// como por ejemplo:
/// - marca
/// - modelo
/// - año
/// - precio minimo
/// - precio maximo
class CatalogoFiltrosModel {
  final String marca;
  final String modelo;
  final String anio;
  final String precioMin;
  final String precioMax;

  const CatalogoFiltrosModel({
    this.marca = '',
    this.modelo = '',
    this.anio = '',
    this.precioMin = '',
    this.precioMax = '',
  });

  /// Crea una copia del modelo cambiando
  /// solo los valores necesarios.
  CatalogoFiltrosModel copyWith({
    String? marca,
    String? modelo,
    String? anio,
    String? precioMin,
    String? precioMax,
  }) {
    return CatalogoFiltrosModel(
      marca: marca ?? this.marca,
      modelo: modelo ?? this.modelo,
      anio: anio ?? this.anio,
      precioMin: precioMin ?? this.precioMin,
      precioMax: precioMax ?? this.precioMax,
    );
  }

  /// Indica si todos los filtros estan vacios.
  bool get isEmpty =>
      marca.trim().isEmpty &&
          modelo.trim().isEmpty &&
          anio.trim().isEmpty &&
          precioMin.trim().isEmpty &&
          precioMax.trim().isEmpty;

  /// Convierte los filtros a mapa.
  Map<String, dynamic> toMap() {
    return {
      'marca': marca,
      'modelo': modelo,
      'anio': anio,
      'precioMin': precioMin,
      'precioMax': precioMax,
    };
  }
}