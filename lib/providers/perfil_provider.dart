import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/perfil/perfil_model.dart';
import '../repositories/perfil_repository.dart';

/// Provider del módulo Perfil.
///
/// Maneja:
/// - obtener datos del perfil
/// - estado de carga
/// - errores
/// - subida de foto de perfil
class PerfilProvider extends ChangeNotifier {
  final PerfilRepository _repository;

  PerfilProvider(this._repository);

  bool isLoading = false;
  bool isUploadingPhoto = false;

  String? errorMessage;
  String? uploadPhotoErrorMessage;

  PerfilModel? perfil;

  Future<void> fetchPerfil() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      perfil = await _repository.getPerfil();
    } on DioException catch (e) {
      errorMessage = _extractApiErrorMessage(
        e,
        fallback: 'No se pudo cargar el perfil.',
      );
    } catch (e) {
      errorMessage = 'No se pudo cargar el perfil. Error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> subirFotoPerfil(File foto) async {
    isUploadingPhoto = true;
    uploadPhotoErrorMessage = null;
    notifyListeners();

    try {
      await _repository.subirFotoPerfil(foto);
      await fetchPerfil();
      return true;
    } on DioException catch (e) {
      uploadPhotoErrorMessage = _extractApiErrorMessage(
        e,
        fallback: 'No se pudo subir la foto de perfil.',
      );
      return false;
    } catch (e) {
      uploadPhotoErrorMessage =
      'No se pudo subir la foto de perfil. Error: $e';
      return false;
    } finally {
      isUploadingPhoto = false;
      notifyListeners();
    }
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