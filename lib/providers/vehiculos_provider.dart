import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/vehiculos/vehiculo_detalle_model.dart';
import '../models/vehiculos/vehiculo_item_model.dart';
import '../repositories/vehiculos_repository.dart';

/// Provider del módulo "Mis Vehículos".
class VehiculosProvider extends ChangeNotifier {
  final VehiculosRepository _repository;

  VehiculosProvider(this._repository);

  bool isLoading = false;
  bool isDetalleLoading = false;
  bool isSubmitting = false;

  String? errorMessage;
  String? detalleErrorMessage;
  String? submitErrorMessage;

  List<VehiculoItemModel> vehiculos = [];
  VehiculoDetalleModel? detalle;

  String marcaFiltro = '';
  String modeloFiltro = '';

  Future<void> fetchVehiculos() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      vehiculos = await _repository.getVehiculos(
        marca: marcaFiltro,
        modelo: modeloFiltro,
      );
    } on DioException catch (e) {
      errorMessage = _extractApiErrorMessage(
        e,
        fallback: 'No se pudieron cargar los vehículos.',
      );
    } catch (e) {
      errorMessage = 'No se pudieron cargar los vehículos. Error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDetalle(int id) async {
    isDetalleLoading = true;
    detalleErrorMessage = null;
    detalle = null;
    notifyListeners();

    try {
      detalle = await _repository.getVehiculoDetalle(id);
    } on DioException catch (e) {
      detalleErrorMessage = _extractApiErrorMessage(
        e,
        fallback: 'No se pudo cargar el detalle del vehículo.',
      );
    } catch (e) {
      detalleErrorMessage =
      'No se pudo cargar el detalle del vehículo. Error: $e';
    } finally {
      isDetalleLoading = false;
      notifyListeners();
    }
  }

  Future<bool> crearVehiculo({
    required String placa,
    required String chasis,
    required String marca,
    required String modelo,
    required String anio,
    required String cantidadRuedas,
    File? foto,
  }) async {
    isSubmitting = true;
    submitErrorMessage = null;
    notifyListeners();

    try {
      await _repository.crearVehiculo(
        placa: placa,
        chasis: chasis,
        marca: marca,
        modelo: modelo,
        anio: anio,
        cantidadRuedas: cantidadRuedas,
        foto: foto,
      );

      await fetchVehiculos();
      return true;
    } on DioException catch (e) {
      submitErrorMessage = _extractApiErrorMessage(
        e,
        fallback: 'No se pudo crear el vehículo.',
      );
      return false;
    } catch (e) {
      submitErrorMessage = 'No se pudo crear el vehículo. Error: $e';
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  Future<bool> editarVehiculo({
    required int id,
    required String placa,
    required String chasis,
    required String marca,
    required String modelo,
    required String anio,
    required String cantidadRuedas,
    File? foto,
  }) async {
    isSubmitting = true;
    submitErrorMessage = null;
    notifyListeners();

    try {
      await _repository.editarVehiculo(
        id: id,
        placa: placa,
        chasis: chasis,
        marca: marca,
        modelo: modelo,
        anio: anio,
        cantidadRuedas: cantidadRuedas,
      );

      if (foto != null) {
        await _repository.subirFotoVehiculo(
          vehiculoId: id,
          foto: foto,
        );
      }

      await fetchVehiculos();
      return true;
    } on DioException catch (e) {
      submitErrorMessage = _extractApiErrorMessage(
        e,
        fallback: 'No se pudo editar el vehículo.',
      );
      return false;
    } catch (e) {
      submitErrorMessage = 'No se pudo editar el vehículo. Error: $e';
      return false;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }

  void updateFiltros({
    required String marca,
    required String modelo,
  }) {
    marcaFiltro = marca;
    modeloFiltro = modelo;
    notifyListeners();
  }

  void limpiarFiltros() {
    marcaFiltro = '';
    modeloFiltro = '';
    notifyListeners();
  }

  String _extractApiErrorMessage(
      DioException exception, {
        required String fallback,
      }) {
    final data = exception.response?.data;

    if (data is Map<String, dynamic>) {
      final message = data['message']?.toString();
      if (message != null && message.isNotEmpty) {
        return message;
      }
    }

    return fallback;
  }
}