import 'dart:io';

import '../models/perfil/perfil_model.dart';
import '../services/perfil_service.dart';

/// Repositorio del módulo Perfil.
class PerfilRepository {
  final PerfilService _service;

  PerfilRepository(this._service);

  Future<PerfilModel> getPerfil() {
    return _service.getPerfil();
  }

  Future<void> subirFotoPerfil(File foto) {
    return _service.subirFotoPerfil(foto);
  }
}