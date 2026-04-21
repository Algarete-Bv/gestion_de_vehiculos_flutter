/// Modelo que representa la respuesta
/// del servidor al responder un tema del foro.
///
/// Se utiliza despues de enviar una respuesta
/// dentro de un tema.
///
/// Guarda informacion simple como:
/// - si la operacion fue exitosa
/// - mensaje devuelto por la API
///
/// Ejemplo de mensaje:
/// - Respuesta enviada correctamente
/// - No se pudo responder el tema
class ResponderTemaResponse {
  /// Indica si la operacion fue exitosa.
  final bool success;

  /// Mensaje recibido desde la API.
  final String message;

  /// Constructor principal.
  const ResponderTemaResponse({
    required this.success,
    required this.message,
  });

  /// Crea una instancia desde JSON.
  ///
  /// Este modelo intenta adaptarse a distintas
  /// estructuras posibles del backend.
  ///
  /// Puede leer:
  /// - success
  /// - status
  /// - message
  /// - data.message
  factory ResponderTemaResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    /// Si la respuesta trae un objeto interno "data",
    /// tambien se revisa.
    final nested = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : <String, dynamic>{};

    return ResponderTemaResponse(
      success: _parseBool(
        json['success'] ??
            json['status'],
      ),

      message: _parseString(
        json['message'] ??
            nested['message'],
      ),
    );
  }

  /// Convierte diferentes tipos de valores
  /// a verdadero o falso.
  ///
  /// Soporta:
  /// - bool
  /// - texto: true, ok, success, 1
  /// - numero: 1
  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      final lower =
      value.toLowerCase();

      return lower == 'true' ||
          lower == 'ok' ||
          lower == 'success' ||
          lower == '1';
    }

    if (value is int) {
      return value == 1;
    }

    return false;
  }

  /// Convierte cualquier valor a texto.
  ///
  /// Si viene null, retorna vacio.
  static String _parseString(
      dynamic value,
      ) {
    return value?.toString() ?? '';
  }
}