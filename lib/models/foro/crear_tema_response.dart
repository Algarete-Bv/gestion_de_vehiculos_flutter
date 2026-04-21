/// Modelo que representa la respuesta
/// del servidor al crear un tema en el foro.
///
/// Se utiliza luego de enviar una nueva
/// publicacion desde la app.
///
/// Guarda informacion simple como:
/// - si la operacion fue exitosa
/// - mensaje devuelto por la API
///
/// Ejemplo:
/// - Tema creado correctamente
/// - No se pudo crear el tema
class CrearTemaResponse {
  /// Indica si la operacion fue exitosa.
  final bool success;

  /// Mensaje recibido desde el servidor.
  final String message;

  /// Constructor principal.
  const CrearTemaResponse({
    required this.success,
    required this.message,
  });

  /// Crea una instancia desde JSON.
  ///
  /// Este modelo intenta adaptarse a
  /// distintas respuestas posibles
  /// del backend.
  ///
  /// Puede leer:
  /// - success
  /// - status
  /// - message
  /// - data.message
  factory CrearTemaResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    /// Si la API trae datos internos
    /// dentro de "data", tambien se revisa.
    final nested = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : <String, dynamic>{};

    return CrearTemaResponse(
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

  /// Convierte distintos tipos de datos
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
  /// Si viene null retorna vacio.
  static String _parseString(
      dynamic value,
      ) {
    return value?.toString() ?? '';
  }
}