/// Clase que centraliza los nombres de las rutas de la aplicación.
///
/// Esto evita escribir strings sueltos por todo el proyecto
/// y reduce errores de navegación.
class AppRoutes {
  static const String splash = '/';
  static const String dashboard = '/dashboard';

  static const String login = '/login';

  static const String registro = '/registro';
  static const String activar = '/activar';

  static const String noticias = '/noticias';
  static const String noticiaDetalle = '/noticia-detalle';

  static const String videos = '/videos';
  static const String videoDetalle = '/video-detalle';

  static const String catalogo = '/catalogo';
  static const String catalogoDetalle = '/catalogo-detalle';

  static const String foro = '/foro';
  static const String foroDetalle = '/foro-detalle';
  static const String crearTema = '/crear-tema';
  static const String responderTema = '/responder-tema';

  static const String perfil = '/perfil';

  static const String acercaDe = '/acerca-de';

  static const String misVehiculos = '/mis-vehiculos';
  static const String vehiculoForm = '/vehiculo-form';
  static const String vehiculoDetalle = '/vehiculo-detalle';
}