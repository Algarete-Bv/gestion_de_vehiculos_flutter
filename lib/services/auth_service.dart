import 'dart:convert';

import 'package:dio/dio.dart';

import '../core/network/dio_client.dart';
import '../models/auth/activar_response.dart';
import '../models/auth/forgot_password_response.dart';
import '../models/auth/login_response.dart';
import '../models/auth/registro_response.dart';

/// Servicio encargado de consumir los endpoints de autenticación.
///
/// Este servicio centraliza las operaciones relacionadas con:
/// - registro de usuario por matrícula
/// - activación de cuenta con token temporal
/// - inicio de sesión
/// - recuperación de contraseña
/// - refresh token
///
/// Además, implementa una estrategia flexible para adaptarse
/// a posibles variaciones del backend:
/// - prueba distintos nombres de campos (`password`, `contrasena`, `clave`)
/// - prueba distintos formatos de envío:
///   1. `datax` dentro de form-urlencoded
///   2. form-urlencoded simple
///   3. JSON normal
///
/// Esto es útil cuando la documentación del backend no siempre coincide
/// exactamente con el comportamiento real de la API.
class AuthService {
  /// Cliente HTTP centralizado basado en Dio.
  final Dio _dio = DioClient().dio;

  /// Registra una matrícula en el sistema.
  ///
  /// Flujo esperado:
  /// - se envía la matrícula limpia
  /// - el backend devuelve un token temporal
  ///
  /// Endpoint:
  /// `POST auth/registro`
  Future<RegistroResponse> registrar(String matricula) async {
    final payload = {
      /// Se limpia la matrícula por si viene con guiones o espacios.
      'matricula': matricula.replaceAll('-', '').trim(),
    };

    final response = await _postWithAutoFormat(
      endpoint: 'auth/registro',
      payload: payload,
    );

    return RegistroResponse.fromJson(_extractMap(response.data));
  }

  /// Activa una cuenta usando token temporal y contraseña.
  ///
  /// Este metodo prueba varios nombres posibles para el campo de contraseña:
  /// - `password`
  /// - `contrasena`
  /// - `clave`
  ///
  /// Endpoint:
  /// `POST auth/activar`
  Future<ActivarResponse> activar({
    required String token,
    required String password,
  }) async {
    final attempts = <Map<String, dynamic>>[
      {
        'token': token.trim(),
        'password': password.trim(),
      },
      {
        'token': token.trim(),
        'contrasena': password.trim(),
      },
      {
        'token': token.trim(),
        'clave': password.trim(),
      },
    ];

    DioException? lastError;

    /// Se intenta cada posible payload hasta que uno funcione.
    for (final payload in attempts) {
      try {
        print('ACTIVAR TRY PAYLOAD => $payload');

        final response = await _postWithAutoFormat(
          endpoint: 'auth/activar',
          payload: payload,
        );

        return ActivarResponse.fromJson(_extractMap(response.data));
      } on DioException catch (error) {
        lastError = error;
        print('ACTIVAR PAYLOAD ERROR => $payload');
        print('ACTIVAR ERROR DATA => ${error.response?.data}');
      }
    }

    /// Si todos los intentos fallan, se lanza el último error recibido.
    throw lastError ??
        DioException(
          requestOptions: RequestOptions(path: 'auth/activar'),
          error: 'No se pudo activar la cuenta.',
        );
  }

  /// Inicia sesión con matrícula y contraseña.
  ///
  /// Este metodo prueba varios nombres posibles para el campo de contraseña:
  /// - `password`
  /// - `contrasena`
  /// - `clave`
  ///
  /// Endpoint:
  /// `POST auth/login`
  Future<LoginResponse> login({
    required String matricula,
    required String password,
  }) async {
    final attempts = <Map<String, dynamic>>[
      {
        'matricula': matricula.replaceAll('-', '').trim(),
        'password': password.trim(),
      },
      {
        'matricula': matricula.replaceAll('-', '').trim(),
        'contrasena': password.trim(),
      },
      {
        'matricula': matricula.replaceAll('-', '').trim(),
        'clave': password.trim(),
      },
    ];

    DioException? lastError;

    /// Se intenta cada combinación posible.
    for (final payload in attempts) {
      try {
        print('LOGIN TRY PAYLOAD => $payload');

        final response = await _postWithAutoFormat(
          endpoint: 'auth/login',
          payload: payload,
        );

        return LoginResponse.fromJson(_extractMap(response.data));
      } on DioException catch (error) {
        lastError = error;
        print('LOGIN PAYLOAD ERROR => $payload');
        print('LOGIN ERROR DATA => ${error.response?.data}');
      }
    }

    throw lastError ??
        DioException(
          requestOptions: RequestOptions(path: 'auth/login'),
          error: 'No se pudo iniciar sesión.',
        );
  }

  /// Solicita recuperación de contraseña usando matrícula.
  ///
  /// Endpoint:
  /// `POST auth/olvidar`
  Future<ForgotPasswordResponse> olvidar(String matricula) async {
    final payload = {
      'matricula': matricula.replaceAll('-', '').trim(),
    };

    final response = await _postWithAutoFormat(
      endpoint: 'auth/olvidar',
      payload: payload,
    );

    return ForgotPasswordResponse.fromJson(_extractMap(response.data));
  }

  /// Renueva la sesión usando un refresh token.
  ///
  /// Endpoint:
  /// `POST auth/refresh`
  Future<LoginResponse> refreshToken(String refreshToken) async {
    final payload = {
      'refreshToken': refreshToken.trim(),
    };

    final response = await _postWithAutoFormat(
      endpoint: 'auth/refresh',
      payload: payload,
    );

    return LoginResponse.fromJson(_extractMap(response.data));
  }

  /// Envía una petición POST probando automáticamente varios formatos.
  ///
  /// Orden de intentos:
  /// 1. `datax` como JSON dentro de `application/x-www-form-urlencoded`
  /// 2. payload simple en `application/x-www-form-urlencoded`
  /// 3. payload como JSON normal
  ///
  /// Este metodo existe para adaptarse a inconsistencias del backend.
  Future<Response<dynamic>> _postWithAutoFormat({
    required String endpoint,
    required Map<String, dynamic> payload,
  }) async {
    DioException? lastError;

    final attempts = <Future<Response<dynamic>> Function()>[
          () {
        print('AUTH TRY => datax form-urlencoded');
        return _dio.post(
          endpoint,
          data: {
            'datax': jsonEncode(payload),
          },
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
          ),
        );
      },
          () {
        print('AUTH TRY => simple form-urlencoded');
        return _dio.post(
          endpoint,
          data: payload,
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
          ),
        );
      },
          () {
        print('AUTH TRY => raw json');
        return _dio.post(
          endpoint,
          data: payload,
          options: Options(
            contentType: Headers.jsonContentType,
          ),
        );
      },
    ];

    /// Se intenta cada formato hasta que alguno funcione.
    for (final attempt in attempts) {
      try {
        return await attempt();
      } on DioException catch (error) {
        lastError = error;
        print('AUTH ERROR => ${error.response?.data}');
      }
    }

    throw lastError ??
        DioException(
          requestOptions: RequestOptions(path: endpoint),
          error: 'No se pudo completar la solicitud de autenticación.',
        );
  }

  /// Extrae un mapa útil desde la respuesta del backend.
  ///
  /// Casos soportados:
  /// - respuesta directa: `{ ... }`
  /// - respuesta anidada: `{ data: { ... } }`
  ///
  /// Si no encuentra un mapa válido, devuelve uno vacío.
  Map<String, dynamic> _extractMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      final nested = data['data'];
      if (nested is Map<String, dynamic>) return nested;
      return data;
    }
    return {};
  }
}