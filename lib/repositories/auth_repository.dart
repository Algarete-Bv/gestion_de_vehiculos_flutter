import '../models/auth/activar_response.dart';
import '../models/auth/forgot_password_response.dart';
import '../models/auth/login_response.dart';
import '../models/auth/registro_response.dart';
import '../services/auth_service.dart';

/// Repositorio encargado del modulo de autenticacion.
///
/// Este archivo conecta la app con el servicio
/// encargado del acceso de usuarios.
///
/// Desde aqui se manejan acciones como:
/// - registrar usuario
/// - activar cuenta
/// - iniciar sesion
/// - recuperar acceso
/// - renovar sesion
///
/// Sirve como puente entre el provider
/// y el servicio que consume la API.
class AuthRepository {
  /// Servicio principal de autenticacion.
  final AuthService _service;

  /// Constructor principal.
  AuthRepository(this._service);

  /// Registra una matricula nueva en el sistema.
  ///
  /// Normalmente devuelve un token temporal
  /// para continuar con la activacion.
  Future<RegistroResponse> registrar(String matricula) {
    return _service.registrar(matricula);
  }

  /// Activa la cuenta del usuario.
  ///
  /// Requiere:
  /// - token recibido
  /// - nueva clave
  Future<ActivarResponse> activar({
    required String token,
    required String password,
  }) {
    return _service.activar(
      token: token,
      password: password,
    );
  }

  /// Inicia sesion del usuario.
  ///
  /// Requiere:
  /// - matricula
  /// - clave
  Future<LoginResponse> login({
    required String matricula,
    required String password,
  }) {
    return _service.login(
      matricula: matricula,
      password: password,
    );
  }

  /// Solicita recuperacion de acceso.
  ///
  /// Se usa cuando el usuario olvido
  /// su clave o necesita reactivar acceso.
  Future<ForgotPasswordResponse> olvidar(String matricula) {
    return _service.olvidar(matricula);
  }

  /// Renueva la sesion usando refresh token.
  ///
  /// Se utiliza para mantener al usuario
  /// conectado sin volver a iniciar sesion.
  Future<LoginResponse> refreshToken(String refreshToken) {
    return _service.refreshToken(refreshToken);
  }
}