/// Modelo que representa la respuesta
/// del endpoint de login.
///
/// Se utiliza cuando el usuario inicia sesion
/// en la aplicacion.
///
/// Guarda informacion importante como:
/// - si el login fue exitoso
/// - mensaje del servidor
/// - datos del usuario
/// - token de acceso
/// - refresh token
///
/// El backend puede enviar los datos:
/// - directamente en la raiz del JSON
/// - dentro de un objeto llamado data
class LoginResponse {
  /// Indica si el login fue exitoso.
  final bool success;

  /// Mensaje recibido desde la API.
  final String message;

  /// ID unico del usuario.
  final int userId;

  /// Nombre del usuario.
  final String nombre;

  /// Apellido del usuario.
  final String apellido;

  /// Correo electronico.
  final String correo;

  /// URL de la foto de perfil.
  final String fotoUrl;

  /// Token principal de acceso.
  ///
  /// Se usa para endpoints protegidos.
  final String token;

  /// Token para renovar sesion.
  final String refreshToken;

  /// Constructor principal.
  const LoginResponse({
    required this.success,
    required this.message,
    required this.userId,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.fotoUrl,
    required this.token,
    required this.refreshToken,
  });

  /// Crea una instancia desde JSON.
  ///
  /// Soporta varias estructuras posibles
  /// del backend para evitar errores.
  factory LoginResponse.fromJson(
      Map<String, dynamic> json,
      ) {
    /// Si existe un objeto data,
    /// tambien se utiliza.
    final nested =
    json['data'] is Map<String, dynamic>
        ? json['data']
    as Map<String, dynamic>
        : <String, dynamic>{};

    return LoginResponse(
      success: _parseBool(
        json['success'] ??
            json['status'],
      ),

      message: _parseString(
        json['message'] ??
            nested['message'],
      ),

      userId: _parseInt(
        json['id'] ??
            nested['id'] ??
            nested['userId'] ??
            nested['user_id'],
      ),

      nombre: _parseString(
        json['nombre'] ??
            nested['nombre'],
      ),

      apellido: _parseString(
        json['apellido'] ??
            nested['apellido'],
      ),

      correo: _parseString(
        json['correo'] ??
            nested['correo'],
      ),

      fotoUrl: _parseString(
        json['fotoUrl'] ??
            json['foto_url'] ??
            nested['fotoUrl'] ??
            nested['foto_url'],
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

  /// Convierte distintos tipos de valor
  /// a verdadero o falso.
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

  /// Convierte cualquier valor a entero.
  ///
  /// Si falla retorna 0.
  static int _parseInt(
      dynamic value,
      ) {
    if (value is int) return value;

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
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