import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../providers/auth_provider.dart';

/// Pantalla de registro.
///
/// Permite al usuario registrar su matrícula para obtener
/// un token temporal de activación.
///
/// Flujo:
/// 1. El usuario escribe su matrícula
/// 2. Se llama al endpoint de registro
/// 3. Si el backend responde correctamente, se navega
///    a la pantalla de activación enviando el token temporal
class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _matriculaController = TextEditingController();

  @override
  void dispose() {
    _matriculaController.dispose();
    super.dispose();
  }

  /// Valida y ejecuta el proceso de registro.
  Future<void> _registrar() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();
    final matricula = _matriculaController.text.trim();

    final success = await authProvider.registrar(matricula);

    if (!mounted) return;

    if (success && authProvider.registroResponse != null) {
      final tempToken = authProvider.registroResponse!.tempToken;

      if (tempToken.isNotEmpty) {
        Navigator.pushNamed(
          context,
          AppRoutes.activar,
          arguments: tempToken,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No se recibió el token temporal de activación.'),
          ),
        );
      }
    } else {
      final error = authProvider.registerError ?? 'No se pudo completar el registro.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Registra tu matrícula',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ingresa tu matrícula del ITLA para recibir un token temporal y activar tu cuenta.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _matriculaController,
                    decoration: const InputDecoration(
                      labelText: 'Matrícula',
                      hintText: 'Ej. 2023-0001',
                      prefixIcon: Icon(Icons.badge_outlined),
                    ),
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) {
                        return 'Debes ingresar la matrícula.';
                      }
                      if (text.length < 4) {
                        return 'La matrícula no parece válida.';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _registrar(),
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: authProvider.isRegisterLoading ? null : _registrar,
                    child: authProvider.isRegisterLoading
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                        : const Text('Continuar'),
                  ),

                  const SizedBox(height: 16),

                  if (authProvider.registerError != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        authProvider.registerError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}