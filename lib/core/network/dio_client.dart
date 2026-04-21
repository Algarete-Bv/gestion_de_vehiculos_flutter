import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../constants/storage_keys.dart';
import '../storage/local_storage.dart';

/// Cliente HTTP centralizado usando Dio.
///
/// Desde aquí se configuran:
/// - URL base de la API
/// - Timeouts de conexión y respuesta
/// - Headers por defecto
/// - Interceptores para logging y autenticación
///
/// Esta clase permite que todas las peticiones HTTP de la app
/// compartan una misma configuración base.
///
/// Además, si existe un token guardado en almacenamiento local,
/// se agrega automáticamente al header Authorization.
class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        headers: {
          'Accept': 'application/json',
        },
      ),
    );

    _initializeInterceptors();
  }

  /// Inicializa los interceptores del cliente HTTP.
  ///
  /// Los interceptores permiten:
  /// - Monitorear cada petición enviada al servidor
  /// - Analizar las respuestas recibidas
  /// - Detectar y manejar errores de forma centralizada
  /// - Agregar automáticamente el token de autenticación
  ///
  /// En este proyecto se usan para:
  /// - Mostrar logs útiles durante el desarrollo
  /// - Enviar el token guardado si ya existe
  void _initializeInterceptors() {
    dio.interceptors.add(
      InterceptorsWrapper(
        /// Se ejecuta antes de enviar la petición al servidor.
        ///
        /// Aquí se realiza lo siguiente:
        /// - Se busca el token guardado localmente
        /// - Si existe, se agrega al header Authorization
        /// - Se imprime información de depuración en consola
        onRequest: (options, handler) async {
          final token = await LocalStorage.getString(StorageKeys.token);

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          print('REQUEST[${options.method}] => PATH: ${options.path}');
          print('HEADERS => ${options.headers}');
          print('QUERY => ${options.queryParameters}');
          print('BODY => ${options.data}');

          handler.next(options);
        },

        /// Se ejecuta cuando el servidor responde correctamente.
        ///
        /// Aquí se imprime:
        /// - Código de estado HTTP
        /// - Endpoint solicitado
        /// - Datos devueltos por el servidor
        onResponse: (response, handler) {
          print(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          print('DATA => ${response.data}');

          handler.next(response);
        },

        /// Se ejecuta cuando ocurre un error en la petición.
        ///
        /// Aquí se imprime:
        /// - Código de error HTTP
        /// - Endpoint donde ocurrió el error
        /// - Estructura de error devuelta por el servidor
        ///
        /// Esto ayuda a identificar problemas como:
        /// - Token inválido o expirado
        /// - Rutas mal configuradas
        /// - Errores del backend
        onError: (DioException error, handler) {
          print(
            'ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}',
          );
          print('ERROR DATA => ${error.response?.data}');

          handler.next(error);
        },
      ),
    );
  }
}