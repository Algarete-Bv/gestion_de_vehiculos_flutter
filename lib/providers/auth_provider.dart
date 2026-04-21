import 'package:flutter/material.dart';

import '../core/constants/storage_keys.dart';
import '../core/storage/local_storage.dart';
import '../models/auth/activar_response.dart';
import '../models/auth/forgot_password_response.dart';
import '../models/auth/login_response.dart';
import '../models/auth/registro_response.dart';
import '../repositories/auth_repository.dart';

/// Provider encargado de manejar el estado del módulo de autenticación.
///
/// Maneja:
/// - registro
/// - activación
/// - estados de carga
/// - mensajes de error
/// - guardado de token y refresh token

class AuthProvider extends ChangeNotifier {
  final AuthRepository _repository;

  AuthProvider(this._repository);

  bool isRegisterLoading = false;
  bool isActivateLoading = false;
  bool isLoginLoading = false;
  bool isForgotLoading = false;
  bool isRefreshingToken = false;

  String? registerError;
  String? activateError;
  String? loginError;
  String? forgotError;

  RegistroResponse? registroResponse;
  ActivarResponse? activarResponse;
  LoginResponse? loginResponse;
  ForgotPasswordResponse? forgotPasswordResponse;

  bool get isAuthenticated {
    if (activarResponse?.token.isNotEmpty == true) return true;
    if (loginResponse?.token.isNotEmpty == true) return true;
    return false;
  }

  Future<bool> registrar(String matricula) async {
    isRegisterLoading = true;
    registerError = null;
    registroResponse = null;
    notifyListeners();

    try {
      final result = await _repository.registrar(matricula);
      registroResponse = result;

      if (!result.success && result.tempToken.isEmpty) {
        registerError = result.message.isNotEmpty
            ? result.message
            : 'No se pudo completar el registro.';
        return false;
      }

      return true;
    } catch (e) {
      registerError = 'No se pudo registrar la matrícula. Error: $e';
      return false;
    } finally {
      isRegisterLoading = false;
      notifyListeners();
    }
  }

  Future<bool> activar({
    required String token,
    required String password,
  }) async {
    isActivateLoading = true;
    activateError = null;
    activarResponse = null;
    notifyListeners();

    try {
      final result = await _repository.activar(
        token: token,
        password: password,
      );

      activarResponse = result;

      if (!result.success && result.token.isEmpty) {
        activateError = result.message.isNotEmpty
            ? result.message
            : 'No se pudo activar la cuenta.';
        return false;
      }

      await _saveSessionData(
        token: result.token,
        refreshToken: result.refreshToken,
      );

      return true;
    } catch (e) {
      activateError = 'No se pudo activar la cuenta. Error: $e';
      return false;
    } finally {
      isActivateLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({
    required String matricula,
    required String password,
  }) async {
    isLoginLoading = true;
    loginError = null;
    loginResponse = null;
    notifyListeners();

    try {
      final result = await _repository.login(
        matricula: matricula,
        password: password,
      );

      loginResponse = result;

      if (!result.success && result.token.isEmpty) {
        loginError = result.message.isNotEmpty
            ? result.message
            : 'No se pudo iniciar sesión.';
        return false;
      }

      await _saveSessionData(
        token: result.token,
        refreshToken: result.refreshToken,
        userId: result.userId,
        userName: '${result.nombre} ${result.apellido}'.trim(),
        userPhoto: result.fotoUrl,
      );

      return true;
    } catch (e) {
      loginError = 'No se pudo iniciar sesión. Error: $e';
      return false;
    } finally {
      isLoginLoading = false;
      notifyListeners();
    }
  }

  Future<bool> olvidar(String matricula) async {
    isForgotLoading = true;
    forgotError = null;
    forgotPasswordResponse = null;
    notifyListeners();

    try {
      final result = await _repository.olvidar(matricula);
      forgotPasswordResponse = result;

      if (!result.success) {
        forgotError = result.message.isNotEmpty
            ? result.message
            : 'No se pudo restablecer la contraseña.';
        return false;
      }

      return true;
    } catch (e) {
      forgotError = 'No se pudo restablecer la contraseña. Error: $e';
      return false;
    } finally {
      isForgotLoading = false;
      notifyListeners();
    }
  }

  Future<bool> refreshSession() async {
    isRefreshingToken = true;
    notifyListeners();

    try {
      final refreshToken =
      await LocalStorage.getString(StorageKeys.refreshToken);

      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final result = await _repository.refreshToken(refreshToken);
      loginResponse = result;

      if (result.token.isEmpty) {
        return false;
      }

      await _saveSessionData(
        token: result.token,
        refreshToken: result.refreshToken.isNotEmpty
            ? result.refreshToken
            : refreshToken,
        userId: result.userId,
        userName: '${result.nombre} ${result.apellido}'.trim(),
        userPhoto: result.fotoUrl,
      );

      return true;
    } catch (_) {
      return false;
    } finally {
      isRefreshingToken = false;
      notifyListeners();
    }
  }

  Future<bool> hasSavedSession() async {
    final token = await LocalStorage.getString(StorageKeys.token);
    return token != null && token.isNotEmpty;
  }

  Future<void> logout() async {
    registroResponse = null;
    activarResponse = null;
    loginResponse = null;
    forgotPasswordResponse = null;

    registerError = null;
    activateError = null;
    loginError = null;
    forgotError = null;

    await LocalStorage.clearSession();
    notifyListeners();
  }

  Future<void> _saveSessionData({
    required String token,
    required String refreshToken,
    int? userId,
    String? userName,
    String? userPhoto,
  }) async {
    await LocalStorage.setString(StorageKeys.token, token);
    await LocalStorage.setString(StorageKeys.refreshToken, refreshToken);

    if (userId != null && userId > 0) {
      await LocalStorage.setString(StorageKeys.userId, userId.toString());
    }

    if (userName != null && userName.isNotEmpty) {
      await LocalStorage.setString(StorageKeys.userName, userName);
    }

    if (userPhoto != null && userPhoto.isNotEmpty) {
      await LocalStorage.setString(StorageKeys.userPhoto, userPhoto);
    }
  }

  void clearErrors() {
    registerError = null;
    activateError = null;
    loginError = null;
    forgotError = null;
    notifyListeners();
  }
}

