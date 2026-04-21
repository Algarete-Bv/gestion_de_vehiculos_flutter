import 'package:flutter/material.dart';

import '../models/catalogo/catalogo_detalle_model.dart';
import '../models/catalogo/catalogo_item_model.dart';
import '../repositories/catalogo_repository.dart';

/// Provider encargado de manejar el estado del catálogo.
class CatalogoProvider extends ChangeNotifier {
  final CatalogoRepository _repository;

  CatalogoProvider(this._repository);

  bool isLoading = false;
  bool isDetalleLoading = false;

  String? errorMessage;
  String? detalleErrorMessage;

  List<CatalogoItemModel> items = [];
  CatalogoDetalleModel? detalle;

  String marca = '';
  String modelo = '';
  String anio = '';
  String precioMin = '';
  String precioMax = '';

  Future<void> fetchCatalogo() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      items = await _repository.getCatalogo(
        marca: marca,
        modelo: modelo,
        anio: anio,
        precioMin: precioMin,
        precioMax: precioMax,
      );
    } catch (e) {
      errorMessage = 'No se pudo cargar el catálogo. Error: $e';
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
      detalle = await _repository.getCatalogoDetalle(id);
    } catch (e) {
      detalleErrorMessage = 'No se pudo cargar el detalle. Error: $e';
    } finally {
      isDetalleLoading = false;
      notifyListeners();
    }
  }

  void updateFiltros({
    required String marca,
    required String modelo,
    required String anio,
    required String precioMin,
    required String precioMax,
  }) {
    this.marca = marca;
    this.modelo = modelo;
    this.anio = anio;
    this.precioMin = precioMin;
    this.precioMax = precioMax;
    notifyListeners();
  }

  void limpiarFiltros() {
    marca = '';
    modelo = '';
    anio = '';
    precioMin = '';
    precioMax = '';
    notifyListeners();
  }
}