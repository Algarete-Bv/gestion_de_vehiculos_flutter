import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../providers/auth_provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final bool hasSession = authProvider.isAuthenticated;

        final List<_DashboardOption> options = [
          /// Opciones cuando NO hay sesión
          if (!hasSession)
            _DashboardOption(
              title: 'Login',
              icon: Icons.login_rounded,
              route: AppRoutes.login,
            ),
          if (!hasSession)
            _DashboardOption(
              title: 'Registro',
              icon: Icons.app_registration_rounded,
              route: AppRoutes.registro,
            ),
              ///Mi perfil
          if (hasSession)
            _DashboardOption(
              title: 'Mi Perfil',
              icon: Icons.person_rounded,
              route: AppRoutes.perfil,
            ),

          /// Opción cuando SÍ hay sesión
          if (hasSession)
            _DashboardOption(
              title: 'Mis Vehículos',
              icon: Icons.garage_outlined,
              route: AppRoutes.misVehiculos,
            ),

          /// Opciones públicas
          _DashboardOption(
            title: 'Noticias',
            icon: Icons.newspaper_rounded,
            route: AppRoutes.noticias,
          ),
          _DashboardOption(
            title: 'Videos',
            icon: Icons.play_circle_fill_rounded,
            route: AppRoutes.videos,
          ),
          _DashboardOption(
            title: 'Catálogo',
            icon: Icons.directions_car_rounded,
            route: AppRoutes.catalogo,
          ),
          _DashboardOption(
            title: 'Foro',
            icon: Icons.forum_rounded,
            route: AppRoutes.foro,
          ),
          _DashboardOption(
            title: 'Acerca de',
            icon: Icons.info_rounded,
            route: AppRoutes.acercaDe,
          ),
        ];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Inicio'),
            actions: [
              if (hasSession)
                IconButton(
                  tooltip: 'Cerrar sesión',
                  onPressed: () async {
                    await authProvider.logout();

                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sesión cerrada correctamente.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.logout_rounded),
                ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenido',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  hasSession
                      ? 'Tu sesión está activa. Ya puedes usar los módulos privados.'
                      : 'Explora los módulos públicos o inicia sesión para desbloquear más funciones.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    itemCount: options.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 14,
                      crossAxisSpacing: 14,
                      childAspectRatio: 1.1,
                    ),
                    itemBuilder: (context, index) {
                      final option = options[index];

                      return InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () {
                          Navigator.pushNamed(context, option.route);
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  option.icon,
                                  size: 42,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondary,
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  option.title,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DashboardOption {
  final String title;
  final IconData icon;
  final String route;

  _DashboardOption({
    required this.title,
    required this.icon,
    required this.route,
  });
}