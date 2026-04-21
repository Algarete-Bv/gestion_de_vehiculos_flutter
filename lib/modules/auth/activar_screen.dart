import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../providers/auth_provider.dart';

/// Pantalla de activación de cuenta.
///
/// Recibe el token temporal enviado desde la pantalla de registro.
/// Luego permite establecer la contraseña final de la cuenta.
///
/// Flujo:
/// 1. Se recibe el token temporal
/// 2. El usuario escribe la contraseña
/// 3. Se llama al endpoint de activación
/// 4. Se guardan token y refreshToken
/// 5. Se redirige al dashboard
class ActivarScreen extends StatefulWidget {
  const ActivarScreen({super.key});

  @override
  State<ActivarScreen> createState() => _ActivarScreenState();
}

class _ActivarScreenState extends State<ActivarScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _tokenInitialized = false;

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_tokenInitialized) return;
    _tokenInitialized = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String && args.trim().isNotEmpty) {
      _tokenController.text = args;
    }
  }

  /// Valida el formulario y activa la cuenta.
  Future<void> _activarCuenta() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = context.read<AuthProvider>();

    final success = await authProvider.activar(
      token: _tokenController.text.trim(),
      password: _passwordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cuenta activada correctamente.'),
        ),
      );

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.dashboard,
            (route) => false,
      );
    } else {
      final error = authProvider.activateError ?? 'No se pudo activar la cuenta.';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Activar cuenta'),
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
                    'Activa tu cuenta',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ingresa el token temporal y define tu contraseña final para completar la activación.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 24),

                  TextFormField(
                    controller: _tokenController,
                    decoration: const InputDecoration(
                      labelText: 'Token temporal',
                      hintText: 'Token recibido en el registro',
                      prefixIcon: Icon(Icons.vpn_key_outlined),
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) {
                        return 'Debes ingresar el token temporal.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      hintText: 'Mínimo 6 caracteres',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) {
                        return 'Debes ingresar una contraseña.';
                      }
                      if (text.length < 6) {
                        return 'La contraseña debe tener al menos 6 caracteres.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_confirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirmar contraseña',
                      hintText: 'Repite la contraseña',
                      prefixIcon: const Icon(Icons.lock_person_outlined),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _confirmPasswordVisible = !_confirmPasswordVisible;
                          });
                        },
                        icon: Icon(
                          _confirmPasswordVisible
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                        ),
                      ),
                    ),
                    validator: (value) {
                      final text = value?.trim() ?? '';
                      if (text.isEmpty) {
                        return 'Debes confirmar la contraseña.';
                      }
                      if (text != _passwordController.text.trim()) {
                        return 'Las contraseñas no coinciden.';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _activarCuenta(),
                  ),

                  const SizedBox(height: 24),

                  ElevatedButton(
                    onPressed: authProvider.isActivateLoading ? null : _activarCuenta,
                    child: authProvider.isActivateLoading
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                        : const Text('Activar cuenta'),
                  ),

                  const SizedBox(height: 16),

                  if (authProvider.activateError != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        authProvider.activateError!,
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