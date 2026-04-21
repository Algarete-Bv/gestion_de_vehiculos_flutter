import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';

/// Clase utilitaria para manejar almacenamiento local.
///
/// Se utiliza principalmente para:
/// - guardar token
/// - guardar refreshToken
/// - leer datos persistidos
/// - eliminar datos específicos de sesión
class LocalStorage {
  /// Guarda un valor tipo String.
  static Future<void> setString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  /// Obtiene un valor tipo String.
  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  /// Elimina una llave específica.
  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  /// Limpia únicamente los datos de sesión.
  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(StorageKeys.token);
    await prefs.remove(StorageKeys.refreshToken);
    await prefs.remove(StorageKeys.userId);
    await prefs.remove(StorageKeys.userName);
    await prefs.remove(StorageKeys.userPhoto);
  }
}