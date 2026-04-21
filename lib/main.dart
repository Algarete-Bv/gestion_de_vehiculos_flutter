import 'package:flutter/material.dart';
import 'app.dart';

/// Punto de entrada principal de la aplicación.
///
/// Aquí se inicializa Flutter y se levanta el widget raíz [GestionDeVehiculosApp].
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GestionDeVehiculosApp());
}