/// Modelo que representa la respuesta
/// del endpoint de recuperacion
/// de contraseña.
///
/// Se utiliza cuando el usuario solicita
/// restablecer su acceso.
///
/// Guarda informacion simple como:
/// - si la solicitud fue exitosa
/// - mensaje enviado por la API
///
/// Ejemplo:
/// - Correo enviado correctamente
/// - Usuario no encontrado
class ForgotPasswordResponse {
  /// Indica si la operacion fue exitosa.
  final bool success;

  /// Mensaje recibido del servidor.
  final String message;

  /// Constructor principal.
  const ForgotPasswordResponse({
    required this.success,
    required this.message,
  });

  /// Crea una instancia desde JSON.
  ///
  /// El backend puede devolver datos:
  /// - en la raiz del JSON
  /// - dentro de data
  factory ForgotPasswordResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    /// Si existe objeto data,
    /// tambien se utiliza.
    final nested =
    json['data'] is Map<String, dynamic>
        ? json['data']
    as Map<String, dynamic>
        : <String, dynamic>{};

    return ForgotPasswordResponse(
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

  /// Convierte distintos tipos
  /// de valores a true o false.
  ///
  /// Soporta:
  /// - bool
  /// - texto: true, ok, success, 1
  /// - numero: 1
  static bool _parseBool(
      dynamic value,
      ) {
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