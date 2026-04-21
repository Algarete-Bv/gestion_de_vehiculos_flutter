/// Modelo para representar un vehículo en el listado de "Mis Vehículos".
class VehiculoItemModel {
  final int id;
  final String marca;
  final String modelo;
  final String anio;
  final String placa;
  final String chasis;
  final String fotoUrl;

  const VehiculoItemModel({
    required this.id,
    required this.marca,
    required this.modelo,
    required this.anio,
    required this.placa,
    required this.chasis,
    required this.fotoUrl,
  });

  factory VehiculoItemModel.fromJson(Map<String, dynamic> json) {
    return VehiculoItemModel(
      id: _parseInt(json['id']),
      marca: _parseString(json['marca']),
      modelo: _parseString(json['modelo']),
      anio: _parseString(json['anio'] ?? json['ano']),
      placa: _parseString(json['placa']),
      chasis: _parseString(json['chasis']),
      fotoUrl: _parseString(
        json['foto'] ??
            json['fotoUrl'] ??
            json['imagen'] ??
            json['imagenUrl'] ??
            json['image'],
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
}