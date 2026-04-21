/// Modelo que representa la informacion
/// del usuario autenticado.
///
/// Este modelo se utiliza para guardar
/// los datos principales del perfil
/// recibidos desde la API.
///
/// Incluye datos como:
/// - id del usuario
/// - nombre
/// - apellido
/// - correo
/// - foto de perfil
/// - rol dentro del sistema
/// - grupo asignado
class PerfilModel {
  /// Identificador unico del usuario.
  final int id;

  /// Nombre del usuario.
  final String nombre;

  /// Apellido del usuario.
  final String apellido;

  /// Correo electronico.
  final String correo;

  /// URL de la foto de perfil.
  final String fotoUrl;

  /// Rol del usuario dentro del sistema.
  ///
  /// Ejemplo:
  /// - Estudiante
  /// - Administrador
  final String rol;

  /// Grupo asignado al usuario.
  final String grupo;

  /// Constructor principal.
  const PerfilModel({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.correo,
    required this.fotoUrl,
    required this.rol,
    required this.grupo,
  });

  /// Crea una instancia del modelo
  /// a partir de un JSON recibido de la API.
  ///
  /// Tambien intenta leer distintos nombres
  /// posibles para la foto:
  /// - fotoUrl
  /// - foto_url
  /// - foto
  /// - imagen
  factory PerfilModel.fromJson(
      Map<String, dynamic> json,
      ) {
    return PerfilModel(
      id: _parseInt(json['id']),
      nombre: _parseString(json['nombre']),
      apellido: _parseString(json['apellido']),
      correo: _parseString(json['correo']),
      fotoUrl: _parseString(
        json['fotoUrl'] ??
            json['foto_url'] ??
            json['foto'] ??
            json['imagen'],
      ),
      rol: _parseString(json['rol']),
      grupo: _parseString(json['grupo']),
    );
  }

  /// Retorna nombre y apellido unidos.
  ///
  /// Ejemplo:
  /// Juan Perez
  String get nombreCompleto =>
      '$nombre $apellido'.trim();

  /// Convierte cualquier valor a entero.
  ///
  /// Si falla, retorna 0.
  static int _parseInt(dynamic value) {
    if (value is int) return value;

    return int.tryParse(
      value?.toString() ?? '',
    ) ??
        0;
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