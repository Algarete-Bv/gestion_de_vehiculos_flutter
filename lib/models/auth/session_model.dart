/// Modelo simple para representar la sesión autenticada del usuario.
class SessionModel {
  final String token;
  final String refreshToken;

  const SessionModel({
    required this.token,
    required this.refreshToken,
  });
}