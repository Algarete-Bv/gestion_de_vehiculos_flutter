/// Modelo de respuesta para el endpoint de activación.
///
/// Después de activar la cuenta, el backend debe devolver:
/// - token principal
/// - refresh token
///
/// Esta versión es flexible porque algunos backends retornan:
/// {
///   success: true,
///   token: ...
/// }
///
/// Y otros retornan:
/// {
///   success: true,
///   data: {
///     token: ...
///   }
/// }
class ActivarResponse {
  final bool success;
  final String message;
  final String token;
  final String refreshToken;

  const ActivarResponse({
    required this.success,
    required this.message,
    required this.token,
    required this.refreshToken,
  });

  factory ActivarResponse.fromJson(Map<String, dynamic> json) {
    /// Si existe un objeto interno llamado data,
    /// también se analizará.
    final nested = json['data'] is Map<String, dynamic>
        ? json['data'] as Map<String, dynamic>
        : <String, dynamic>{};

    return ActivarResponse(
      success: _parseBool(
        json['success'] ?? json['status'],
      ),

      message: _parseString(
        json['message'] ?? nested['message'],
      ),

      token: _parseString(
        json['token'] ??
            nested['token'] ??
            nested['accessToken'] ??
            nested['access_token'],
      ),

      refreshToken: _parseString(
        json['refreshToken'] ??
            json['refresh_token'] ??
            nested['refreshToken'] ??
            nested['refresh_token'],
      ),
    );
  }

  /// Convierte distintos formatos a bool.
  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is String) {
      final lower = value.toLowerCase();

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

  /// Convierte cualquier valor a String segura.
  static String _parseString(dynamic value) {
    return value?.toString() ?? '';
  }

  /// Indica si la activación devolvió sesión válida.
  bool get hasSession =>
      token.isNotEmpty && refreshToken.isNotEmpty;
}