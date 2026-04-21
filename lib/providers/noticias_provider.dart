import 'package:flutter/material.dart';

import '../models/noticias/noticia_detalle_model.dart';
import '../models/noticias/noticia_model.dart';
import '../repositories/noticias_repository.dart';

/// Provider para manejar el estado del módulo de noticias.
///
/// Controla:
/// - loading del listado
/// - loading del detalle
/// - errores
/// - datos cargados
class NoticiasProvider extends ChangeNotifier {
  final NoticiasRepository _repository;

  NoticiasProvider(this._repository);

  bool isLoading = false;
  bool isDetalleLoading = false;

  String? errorMessage;
  String? detalleErrorMessage;

  List<NoticiaModel> noticias = [];
  NoticiaDetalleModel? noticiaDetalle;

  Future<void> fetchNoticias() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      noticias = await _repository.getNoticias();
    } catch (e) {
      errorMessage = 'No se pudieron cargar las noticias.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchNoticiaDetalle(int id) async {
    isDetalleLoading = true;
    detalleErrorMessage = null;
    noticiaDetalle = null;
    notifyListeners();

    try {
      noticiaDetalle = await _repository.getNoticiaDetalle(id);
    } catch (e) {
      detalleErrorMessage = 'No se pudo cargar el detalle de la noticia.';
    } finally {
      isDetalleLoading = false;
      notifyListeners();
    }
  }
}