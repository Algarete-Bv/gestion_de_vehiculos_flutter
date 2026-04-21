import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../providers/foro_provider.dart';

/// Pantalla de detalle de un tema del foro.
///
/// Esta vista muestra:
/// - imagen del vehículo asociado al tema
/// - título del tema
/// - autor
/// - vehículo relacionado
/// - fecha de publicación
/// - descripción del tema
/// - listado de respuestas
///
/// Si el usuario tiene sesión iniciada:
/// - se muestra botón flotante para responder el tema
class ForoDetalleScreen extends StatefulWidget {
  const ForoDetalleScreen({super.key});

  @override
  State<ForoDetalleScreen> createState() => _ForoDetalleScreenState();
}

class _ForoDetalleScreenState extends State<ForoDetalleScreen> {
  /// Evita ejecutar varias veces la carga inicial.
  bool _loaded = false;

  /// ID del tema actual.
  int _temaId = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// Solo se ejecuta una vez.
    if (_loaded) return;
    _loaded = true;

    /// Obtiene argumentos enviados por navegación.
    final args = ModalRoute.of(context)?.settings.arguments;

    int id = 0;

    /// Se aceptan varios tipos:
    /// int, String, num.
    if (args is int) {
      id = args;
    } else if (args is String) {
      id = int.tryParse(args) ?? 0;
    } else if (args is num) {
      id = args.toInt();
    }

    _temaId = id;

    print('FORO DETALLE ID => $id');

    /// Si el ID es válido, carga el detalle.
    if (id > 0) {
      Future.microtask(() {
        if (!mounted) return;

        context.read<ForoProvider>().fetchDetalle(id);
      });
    }
  }

  /// Navega a la pantalla de responder tema.
  ///
  /// Si el usuario responde exitosamente,
  /// se recarga el detalle al regresar.
  Future<void> _irAResponder() async {
    if (_temaId <= 0) return;

    final result = await Navigator.pushNamed(
      context,
      AppRoutes.responderTema,
      arguments: _temaId,
    );

    if (!mounted) return;

    /// Si regresó con éxito, recarga detalle.
    if (result == true && _temaId > 0) {
      await context.read<ForoProvider>().fetchDetalle(_temaId);
    }
  }

  @override
  Widget build(BuildContext context) {
    /// Detecta si el usuario tiene sesión iniciada.
    final bool hasSession =
        context.watch<AuthProvider>().isAuthenticated;

    return Scaffold(
      /// Barra superior.
      appBar: AppBar(
        title: const Text('Detalle del tema'),
      ),

      /// Botón flotante para responder.
      ///
      /// Solo aparece con sesión iniciada.
      floatingActionButton: hasSession && _temaId > 0
          ? FloatingActionButton(
        onPressed: _irAResponder,
        child: const Icon(Icons.reply),
      )
          : null,

      /// Consumer escucha cambios del provider.
      body: Consumer<ForoProvider>(
        builder: (context, provider, _) {
          /// Estado cargando.
          if (provider.isDetalleLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          /// Estado error.
          if (provider.detalleErrorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  provider.detalleErrorMessage!,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final detalle = provider.detalle;

          /// Si no existe data.
          if (detalle == null) {
            return const Center(
              child: Text(
                'No se encontró el detalle del tema.',
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Imagen del vehículo asociado.
                if (detalle.fotoUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: detalle.fotoUrl,
                      width: double.infinity,
                      height: 230,
                      fit: BoxFit.cover,

                      /// Placeholder mientras carga.
                      placeholder: (_, __) => const SizedBox(
                        height: 230,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),

                      /// Imagen fallback si falla.
                      errorWidget: (_, __, ___) => Container(
                        height: 230,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.image_not_supported_rounded,
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                /// Título del tema.
                Text(
                  detalle.titulo.isNotEmpty
                      ? detalle.titulo
                      : 'Tema sin título',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                /// Autor.
                if (detalle.autor.isNotEmpty)
                  Text(
                    'Autor: ${detalle.autor}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                const SizedBox(height: 6),

                /// Vehículo relacionado.
                if (detalle.vehiculo.isNotEmpty)
                  Text(
                    'Vehículo: ${detalle.vehiculo}',
                  ),

                const SizedBox(height: 6),

                /// Fecha publicación.
                if (detalle.fecha.isNotEmpty)
                  Text(
                    detalle.fecha,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                const SizedBox(height: 16),

                /// Descripción del tema.
                Text(
                  detalle.descripcion.isNotEmpty
                      ? detalle.descripcion
                      : 'Sin contenido disponible.',
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 24),

                /// Título sección respuestas.
                const Text(
                  'Respuestas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                /// Si no hay respuestas.
                if (detalle.respuestas.isEmpty)
                  const Text(
                    'Este tema aún no tiene respuestas.',
                  ),

                /// Si existen respuestas.
                if (detalle.respuestas.isNotEmpty)
                  ...detalle.respuestas.map(
                        (respuesta) => Card(
                      margin: const EdgeInsets.only(
                        bottom: 12,
                      ),

                      child: Padding(
                        padding: const EdgeInsets.all(14),

                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            /// Autor respuesta.
                            Text(
                              respuesta.autor.isNotEmpty
                                  ? respuesta.autor
                                  : 'Usuario',
                              style: const TextStyle(
                                fontWeight:
                                FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 6),

                            /// Contenido respuesta.
                            Text(
                              respuesta.contenido
                                  .isNotEmpty
                                  ? respuesta.contenido
                                  : 'Sin contenido.',
                            ),

                            const SizedBox(height: 8),

                            /// Fecha respuesta.
                            if (respuesta.fecha.isNotEmpty)
                              Text(
                                respuesta.fecha,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}