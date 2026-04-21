import '../models/noticias/noticia_detalle_model.dart';
import '../models/noticias/noticia_model.dart';
import '../services/noticias_service.dart';

/// Repositorio del módulo de noticias.
///
/// Sirve de capa intermedia entre el provider y el service.
class NoticiasRepository {
  final NoticiasService _service;

  NoticiasRepository(this._service);

  Future<List<NoticiaModel>> getNoticias() {
    return _service.getNoticias();
  }

  Future<NoticiaDetalleModel> getNoticiaDetalle(int id) {
    return _service.getNoticiaDetalle(id);
  }
}