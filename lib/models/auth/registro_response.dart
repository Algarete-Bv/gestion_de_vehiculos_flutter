/// Modelo de respuesta para el endpoint de registro.
///
/// Este endpoint normalmente devuelve un token temporal
/// que luego se usa en la activación de la cuenta.
class RegistroResponse {
  final bool success;
  final String message;
  final String tempToken;

  const RegistroResponse({
    required this.success,
    required this.message,
    required this.tempToken,
  });

  factory RegistroResponse.fromJson(Map<String, dynamic> json) {
    return RegistroResponse(
      success: _parseBool(json['success'] ?? json['status']),
      message: _parseString(json['message']),
      tempToken: _parseString(
        json['token'] ?? json['tempToken'] ?? json['temporaryToken'],
      ),
    );
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true' || value.toLowerCase() == 'ok';
    }
    return false;
  }

  static String _parseString(dynamic value) {
    return value?.toString() ?? '';
  }
}