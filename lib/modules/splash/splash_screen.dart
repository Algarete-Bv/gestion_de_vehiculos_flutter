import 'dart:async';
import 'package:flutter/material.dart';

import '../../core/routes/app_routes.dart';

/// Pantalla de inicio de la aplicación.
///
/// Su propósito es:
/// - Mostrar branding de la app
/// - Dar una entrada visual agradable
/// - Redirigir automáticamente al Dashboard
///
/// Más adelante, aquí también se puede validar si el usuario
/// ya tiene sesión iniciada para enviarlo al menú adecuado.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToDashboard();
  }

  /// Espera unos segundos y luego navega al Dashboard.
  void _navigateToDashboard() {
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.directions_car_filled_rounded,
                size: 90,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              const Text(
                'Gestión de Vehículos',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Controla, organiza y cuida tu vehículo desde una sola app.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 32),
              const CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}