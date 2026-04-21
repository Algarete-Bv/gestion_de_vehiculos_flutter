/// Modelo para representar el detalle de un vehículo.
///
/// Incluye también el resumen financiero si el backend lo devuelve.
class VehiculoDetalleModel {
  final int id;
  final String marca;
  final String modelo;
  final String anio;
  final String placa;
  final String chasis;
  final String cantidadRuedas;
  final String fotoUrl;
  final Map<String, dynamic> resumenFinanciero;

  const VehiculoDetalleModel({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.placa,
    required this.chasis,
    required this.cantidadRuedas,
    required this.fotoUrl,
    required this.resumenFinanciero,
  });

  factory VehiculoDetalleModel.fromJson(Map<String, dynamic> json) {
    return VehiculoDetalleModel(
      id: _parseInt(json['id']),
      marca: _parseString(json['marca']),
      modelo: _parseString(json['modelo']),
      anio: _parseString(json['anio'] ?? json['ano']),
      placa: _parseString(json['placa']),
      chasis: _parseString(json['chasis']),
      cantidadRuedas: _parseString(
        json['cantidadRuedas'] ?? json['cantidad_ruedas'],
      ),
      fotoUrl: _parseString(
        json['foto'] ??
            json['fotoUrl'] ??
            json['imagen'] ??
            json['imagenUrl'] ??
            json['image'],
      ),
      resumenFinanciero: _parseMap(
        json['resumenFinanciero'] ??
            json['resumen_financiero'] ??
            json['resumen'],
      ),
    );
  }

  String get nombreCompleto => '$marca $modelo'.trim();

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _parseString(dynamic value) {
    return value?.toString() ?? '';
  }

  static Map<String, dynamic> _parseMap(dynamic value) {
    if (value is Map<String, dynamic>) return value;
    return {};
  }
}