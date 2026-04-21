import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/foro_provider.dart';

/// Pantalla para responder un tema del foro.
///
/// Esta vista permite al usuario autenticado:
/// - escribir una respuesta
/// - validar que el contenido no esté vacío
/// - enviar la respuesta al backend
/// - mostrar mensajes de éxito o error
///
/// Recibe el `temaId` mediante argumentos enviados
/// desde la navegación con `Navigator.pushNamed()`.
class ResponderTemaScreen extends StatefulWidget {
  const ResponderTemaScreen({super.key});

  @override
  State<ResponderTemaScreen> createState() => _ResponderTemaScreenState();
}

class _ResponderTemaScreenState extends State<ResponderTemaScreen> {
  /// Llave global del formulario.
  ///
  /// Se utiliza para validar los campos antes de enviar.
  final _formKey = GlobalKey<FormState>();

  /// Controlador del campo donde el usuario escribe la respuesta.
  final _contenidoController = TextEditingController();

  /// ID del tema que será respondido.
  int temaId = 0;

  /// Control para evitar ejecutar varias veces
  /// la lectura de argumentos al reconstruirse la pantalla.
  bool _loaded = false;

  @override
  void dispose() {
    /// Libera memoria del controlador al cerrar la pantalla.
    _contenidoController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// Solo se ejecuta una vez.
    if (_loaded) return;
    _loaded = true;

    /// Obtiene los argumentos enviados por navegación.
    final args = ModalRoute.of(context)?.settings.arguments;

    /// Se aceptan distintos formatos:
    /// int, String o num.
    if (args is int) {
      temaId = args;
    } else if (args is String) {
      temaId = int.tryParse(args) ?? 0;
    } else if (args is num) {
      temaId = args.toInt();
    }
  }

  /// Envía la respuesta al backend.
  ///
  /// Flujo:
  /// 1. valida formulario
  /// 2. valida temaId
  /// 3. llama al provider
  /// 4. muestra mensaje
  /// 5. regresa al detalle si fue exitoso
  Future<void> _enviarRespuesta() async {
    /// Si el formulario no es válido, se detiene.
    if (!_formKey.currentState!.validate()) return;

    /// Si no existe tema válido, muestra error.
    if (temaId <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontró el tema a responder.'),
        ),
      );
      return;
    }

    final provider = context.read<ForoProvider>();

    /// Llama al provider para responder.
    final ok = await provider.responderTema(
      temaId: temaId,
      contenido: _contenidoController.text.trim(),
    );

    /// Verifica si el widget sigue montado.
    if (!mounted) return;

    /// Si respondió correctamente:
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Respuesta enviada correctamente.'),
        ),
      );

      /// Regresa a la pantalla anterior
      /// devolviendo true como resultado.
      Navigator.pop(context, true);
    } else {
      /// Si falló, muestra mensaje de error.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.responderTemaErrorMessage ??
                'No se pudo responder el tema.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Barra superior.
      appBar: AppBar(
        title: const Text('Responder tema'),
      ),

      /// Consumer escucha cambios del provider.
      body: Consumer<ForoProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            /// Formulario principal.
            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Título principal.
                  Text(
                    'Escribe tu respuesta',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),

                  const SizedBox(height: 8),

                  /// Texto descriptivo.
                  Text(
                    'Comparte tu opinión, recomendación o solución sobre este tema.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const SizedBox(height: 20),

                  /// Campo de texto para respuesta.
                  TextFormField(
                    controller: _contenidoController,
                    maxLines: 6,

                    decoration: const InputDecoration(
                      labelText: 'Contenido',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(Icons.reply_outlined),
                    ),

                    /// Validación obligatoria.
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Debes escribir una respuesta.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  /// Botón de enviar respuesta.
                  ElevatedButton(
                    onPressed:
                    provider.isReplyingTema ? null : _enviarRespuesta,

                    child: provider.isReplyingTema
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                        : const Text('Enviar respuesta'),
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