/// Constantes relacionadas con la API.
///
/// Aquí centralizamos:
/// - URL base
/// - timeouts
/// - endpoints comunes si luego quieres agruparlos
class ApiConstants {
  static const String baseUrl = 'https://taller-itla.ia3x.com/api/';

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);
}