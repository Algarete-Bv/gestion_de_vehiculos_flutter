import 'dart:io';

import '../models/vehiculos/vehiculo_detalle_model.dart';
import '../models/vehiculos/vehiculo_item_model.dart';
import '../services/vehiculos_service.dart';

/// Repositorio encargado del módulo de vehículos.
///
/// Este repositorio funciona como capa intermedia entre:
/// - Providers (lógica de estado/UI)
/// - Services (consumo directo de API)
///
/// Su propósito es:
/// - centralizar acceso a datos del módulo
/// - mantener el código organizado
/// - desacoplar la interfaz del servicio HTTP
/// - facilitar mantenimiento futuro
///
/// Operaciones soportadas:
/// - listar vehículos del usuario
/// - ver detalle de vehículo
/// - crear vehículo
/// - editar vehículo
/// - subir foto del vehículo
class VehiculosRepository {
  /// Servicio que consume la API real.
  final VehiculosService _service;

  /// Constructor del repositorio.
  VehiculosRepository(this._service);

  /// Obtiene listado de vehículos del usuario.
  ///
  /// Parámetros opcionales:
  /// - [marca]: filtra por marca
  /// - [modelo]: filtra por modelo
  /// - [page]: página actual
  /// - [limit]: cantidad por página
  ///
  /// Retorna una lista de [VehiculoItemModel].
  Future<List<VehiculoItemModel>> getVehiculos({
    String? marca,
    String? modelo,
    int page = 1,
    int limit = 20,
  }) {
    return _service.getVehiculos(
      marca: marca,
      modelo: modelo,
      page: page,
      limit: limit,
    );
  }

  /// Obtiene el detalle completo de un vehículo según su ID.
  ///
  /// Retorna un [VehiculoDetalleModel].
  Future<VehiculoDetalleModel> getVehiculoDetalle(int id) {
    return _service.getVehiculoDetalle(id);
  }

  /// Crea un nuevo vehículo.
  ///
  /// Campos requeridos:
  /// - placa
  /// - chasis
  /// - marca
  /// - modelo
  /// - año
  /// - cantidad de ruedas
  ///
  /// [foto] es opcional al momento de crear,
  /// dependiendo reglas del backend.
  Future<void> crearVehiculo({
    required String placa,
    required String chasis,
    required String marca,
    required String modelo,
    required String anio,
    required String cantidadRuedas,
    File? foto,
  }) {
    return _service.crearVehiculo(
      placa: placa,
      chasis: chasis,
      marca: marca,
      modelo: modelo,
      anio: anio,
      cantidadRuedas: cantidadRuedas,
      foto: foto,
    );
  }

  /// Edita un vehículo existente.
  ///
  /// Requiere el [id] del vehículo.
  ///
  /// Permite modificar:
  /// - placa
  /// - chasis
  /// - marca
  /// - modelo
  /// - año
  /// - cantidad de ruedas
  Future<void> editarVehiculo({
    required int id,
    required String placa,
    required String chasis,
    required String marca,
    required String modelo,
    required String anio,
    required String cantidadRuedas,
  }) {
    return _service.editarVehiculo(
      id: id,
      placa: placa,
      chasis: chasis,
      marca: marca,
      modelo: modelo,
      anio: anio,
      cantidadRuedas: cantidadRuedas,
    );
  }

  /// Sube o reemplaza la foto de un vehículo.
  ///
  /// Requiere:
  /// - [vehiculoId]: ID del vehículo
  /// - [foto]: archivo de imagen local
  Future<void> subirFotoVehiculo({
    required int vehiculoId,
    required File foto,
  }) {
    return _service.subirFotoVehiculo(
      vehiculoId: vehiculoId,
      foto: foto,
    );
  }
}