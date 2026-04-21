import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_routes.dart';
import 'core/routes/route_generator.dart';
import 'core/theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/catalogo_provider.dart';
import 'providers/foro_provider.dart';
import 'providers/noticias_provider.dart';
import 'providers/perfil_provider.dart';
import 'providers/vehiculos_provider.dart';
import 'providers/videos_provider.dart';
import 'repositories/auth_repository.dart';
import 'repositories/catalogo_repository.dart';
import 'repositories/foro_repository.dart';
import 'repositories/noticias_repository.dart';
import 'repositories/perfil_repository.dart';
import 'repositories/vehiculos_repository.dart';
import 'repositories/videos_repository.dart';
import 'services/auth_service.dart';
import 'services/catalogo_service.dart';
import 'services/foro_service.dart';
import 'services/noticias_service.dart';
import 'services/perfil_service.dart';
import 'services/vehiculos_service.dart';
import 'services/videos_service.dart';

/// Widget raíz de la aplicación.
///
/// Aquí se configuran los elementos globales de la app:
/// - tema visual principal
/// - ruta inicial
/// - sistema centralizado de navegación
/// - providers globales para manejo de estado
///
/// Cada provider registrado aquí estará disponible en toda la aplicación.
///
/// A medida que se agreguen nuevos módulos, sus respectivos providers
/// también deberán registrarse en este archivo.
class GestionDeVehiculosApp extends StatelessWidget {
  const GestionDeVehiculosApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// Provider del módulo de autenticación.
        ///
        /// Maneja:
        /// - registro
        /// - activación
        /// - login
        /// - recuperación de contraseña
        /// - refresh token
        /// - cierre de sesión
        /// - persistencia de sesión local
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(
            AuthRepository(
              AuthService(),
            ),
          ),
        ),

        /// Provider del módulo de noticias.
        ///
        /// Maneja:
        /// - listado de noticias
        /// - detalle de noticias
        /// - estado de carga
        /// - manejo de errores
        ChangeNotifierProvider<NoticiasProvider>(
          create: (_) => NoticiasProvider(
            NoticiasRepository(
              NoticiasService(),
            ),
          ),
        ),

        /// Provider del módulo de videos.
        ///
        /// Maneja:
        /// - listado de videos educativos
        /// - estado de carga
        /// - manejo de errores
        ChangeNotifierProvider<VideosProvider>(
          create: (_) => VideosProvider(
            VideosRepository(
              VideosService(),
            ),
          ),
        ),

        /// Provider del módulo de catálogo.
        ///
        /// Maneja:
        /// - listado de vehículos del catálogo
        /// - filtros de búsqueda
        /// - detalle de vehículo
        /// - estado de carga
        /// - manejo de errores
        ChangeNotifierProvider<CatalogoProvider>(
          create: (_) => CatalogoProvider(
            CatalogoRepository(
              CatalogoService(),
            ),
          ),
        ),

        /// Provider del módulo de foro.
        ///
        /// Maneja:
        /// - listado de temas del foro
        /// - detalle de cada tema
        /// - respuestas asociadas
        /// - creación de temas
        /// - estado de carga
        /// - manejo de errores
        ChangeNotifierProvider<ForoProvider>(
          create: (_) => ForoProvider(
            ForoRepository(
              ForoService(),
            ),
          ),
        ),

        /// Provider del módulo de vehículos.
        ///
        /// Maneja:
        /// - listado de vehículos del usuario
        /// - filtros por marca y modelo
        /// - detalle de vehículo
        /// - creación de nuevos vehículos
        /// - edición de vehículos existentes
        /// - subida y cambio de foto del vehículo
        /// - estado de carga
        /// - manejo de errores
        ChangeNotifierProvider<VehiculosProvider>(
          create: (_) => VehiculosProvider(
            VehiculosRepository(
              VehiculosService(),
            ),
          ),
        ),

        /// Provider del módulo de perfil.
        ///
        /// Maneja:
        /// - consulta de los datos del perfil
        /// - nombre, apellido, correo, rol y grupo
        /// - carga de foto de perfil
        /// - estado de carga
        /// - manejo de errores
        ChangeNotifierProvider<PerfilProvider>(
          create: (_) => PerfilProvider(
            PerfilRepository(
              PerfilService(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gestión de Vehículos',
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}