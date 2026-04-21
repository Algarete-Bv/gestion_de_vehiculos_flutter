import 'package:flutter/material.dart';

import '../../modules/acerca_de/acerca_de_screen.dart';
import '../../modules/auth/activar_screen.dart';
import '../../modules/auth/login_screen.dart';
import '../../modules/auth/registro_screen.dart';
import '../../modules/catalogo/catalogo_detalle_screen.dart';
import '../../modules/catalogo/catalogo_screen.dart';
import '../../modules/dashboard/dashboard_screen.dart';
import '../../modules/foro/foro_detalle_screen.dart';
import '../../modules/foro/foro_screen.dart';
import '../../modules/foro/responder_tema_screen.dart';

import '../../modules/noticias/noticia_detalle_screen.dart';
import '../../modules/noticias/noticias_screen.dart';
import '../../modules/splash/splash_screen.dart';
import '../../modules/videos/video_detalle_screen.dart';
import '../../modules/videos/videos_screen.dart';

import '../../modules/vehiculos/mis_vehiculos_screen.dart';
import '../../modules/vehiculos/vehiculo_detalle_screen.dart';
import '../../modules/vehiculos/vehiculo_form_screen.dart';

import '../../modules/foro/crear_tema_screen.dart';

import '../../modules/perfil/perfil_screen.dart';
import 'app_routes.dart';

/// Generador centralizado de rutas.
///
/// Desde aquí se define qué pantalla abrir según el nombre de la ruta.
/// También se conservan los argumentos enviados en la navegación
/// mediante `settings: settings`.
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );

      case AppRoutes.dashboard:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const DashboardScreen(),
        );

      case AppRoutes.login:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const LoginScreen(),
        );

      case AppRoutes.registro:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const RegistroScreen(),
        );

      case AppRoutes.activar:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ActivarScreen(),
        );

      case AppRoutes.noticias:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const NoticiasScreen(),
        );

      case AppRoutes.noticiaDetalle:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const NoticiaDetalleScreen(),
        );

      case AppRoutes.videos:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const VideosScreen(),
        );

      case AppRoutes.videoDetalle:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const VideoDetalleScreen(),
        );

      case AppRoutes.catalogo:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CatalogoScreen(),
        );

      case AppRoutes.catalogoDetalle:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CatalogoDetalleScreen(),
        );

      case AppRoutes.foro:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ForoScreen(),
        );

      case AppRoutes.foroDetalle:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ForoDetalleScreen(),
        );

      case AppRoutes.crearTema:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const CrearTemaScreen(),
        );

      case AppRoutes.responderTema:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const ResponderTemaScreen(),
        );

      case AppRoutes.acercaDe:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const AcercaDeScreen(),
        );
      case AppRoutes.misVehiculos:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const MisVehiculosScreen(),
        );

      case AppRoutes.vehiculoForm:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const VehiculoFormScreen(),
        );

      case AppRoutes.vehiculoDetalle:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const VehiculoDetalleScreen(),
        );

      case AppRoutes.perfil:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const PerfilScreen(),
        );

      default:
        return MaterialPageRoute(
          settings: settings,
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('Ruta no encontrada'),
            ),
          ),
        );
    }
  }
}
