import '../models/catalogo/catalogo_detalle_model.dart';
import '../models/catalogo/catalogo_item_model.dart';
import '../services/catalogo_service.dart';

/// Repositorio encargado del módulo de catálogo.
///
/// Este archivo organiza todo lo relacionado con
/// la consulta de vehículos disponibles en el catálogo.
///
/// Su función es servir de puente entre la app
/// y el servicio que conecta con la API.
///
/// Desde aquí se manejan acciones como:
/// - ver listado de vehículos
/// - filtrar resultados
/// - ver detalle de un vehículo
class CatalogoRepository {
  /// Servicio encargado de consultar la información.
  final CatalogoService _service;

  /// Constructor principal.
  CatalogoRepository(this._service);

  /// Obtiene la lista de vehículos del catálogo.
  ///
  /// También permite filtrar por:
  /// - marca
  /// - modelo
  /// - año
  /// - precio mínimo
  /// - precio máximo
  ///
  /// Retorna una lista de vehículos
  /// para mostrarlos en pantalla.
  Future<List<CatalogoItemModel>> getCatalogo({
    String? marca,
    String? modelo,
    String? anio,
    String? precioMin,
    String? precioMax,
  }) {
    return _service.getCatalogo(
      marca: marca,
      modelo: modelo,
      anio: anio,
      precioMin: precioMin,
      precioMax: precioMax,
    );
  }

  /// Obtiene el detalle de un vehículo específico.
  ///
  /// Recibe el ID del vehículo y devuelve
  /// información más completa como:
  /// - marca
  /// - modelo
  /// - año
  /// - precio
  /// - descripción
  /// - imagen
  Future<CatalogoDetalleModel> getCatalogoDetalle(int id) {
    return _service.getCatalogoDetalle(id);
  }
}