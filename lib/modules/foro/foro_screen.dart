import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../models/foro/foro_tema_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/foro_provider.dart';

/// Pantalla principal del foro.
///
/// Aqui el usuario puede:
/// - ver todos los temas publicados
/// - abrir el detalle de un tema
/// - actualizar la lista deslizando hacia abajo
/// - crear un nuevo tema si tiene sesion iniciada
class ForoScreen extends StatefulWidget {
  const ForoScreen({super.key});

  @override
  State<ForoScreen> createState() => _ForoScreenState();
}

class _ForoScreenState extends State<ForoScreen> {
  @override
  void initState() {
    super.initState();

    /// Carga inicial de temas al entrar a la pantalla.
    Future.microtask(() {
      if (!mounted) return;

      context.read<ForoProvider>().fetchTemas();
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Verifica si el usuario tiene sesion iniciada.
    final bool hasSession =
        context.watch<AuthProvider>().isAuthenticated;

    return Scaffold(
      /// Barra superior.
      appBar: AppBar(
        title: const Text('Foro'),
      ),

      /// Boton para crear tema.
      ///
      /// Solo aparece si el usuario esta autenticado.
      floatingActionButton: hasSession
          ? FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.crearTema,
          );
        },
        child: const Icon(Icons.add),
      )
          : null,

      body: Consumer<ForoProvider>(
        builder: (context, provider, _) {
          /// Estado de carga.
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          /// Estado de error.
          if (provider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  provider.errorMessage!,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          /// Estado sin temas disponibles.
          if (provider.temas.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.forum_outlined,
                      size: 56,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No hay temas disponibles en el foro en este momento.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Intentalo nuevamente mas tarde.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          /// Lista principal del foro.
          return RefreshIndicator(
            onRefresh: provider.fetchTemas,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: provider.temas.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final ForoTemaModel tema = provider.temas[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(16),

                  /// Al tocar una tarjeta se abre el detalle del tema.
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.foroDetalle,
                      arguments: tema.id,
                    );
                  },

                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Imagen del tema o del vehiculo relacionado.
                        if (tema.fotoUrl.isNotEmpty)
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: tema.fotoUrl,
                              width: double.infinity,
                              height: 210,
                              fit: BoxFit.cover,

                              /// Loader mientras carga imagen.
                              placeholder: (_, __) => const SizedBox(
                                height: 210,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),

                              /// Vista alternativa si falla la imagen.
                              errorWidget: (_, __, ___) => Container(
                                height: 210,
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.image_not_supported_rounded,
                                  size: 42,
                                ),
                              ),
                            ),
                          ),

                        /// Informacion del tema.
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Titulo del tema.
                              Text(
                                tema.titulo.isNotEmpty
                                    ? tema.titulo
                                    : 'Tema sin titulo',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              /// Autor del tema.
                              if (tema.autor.isNotEmpty)
                                Text(
                                  'Autor: ${tema.autor}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),

                              const SizedBox(height: 6),

                              /// Vehiculo relacionado.
                              if (tema.vehiculo.isNotEmpty)
                                Text(
                                  'Vehiculo: ${tema.vehiculo}',
                                ),

                              const SizedBox(height: 6),

                              /// Cantidad de respuestas.
                              Text(
                                'Respuestas: ${tema.cantidadRespuestas}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),

                              const SizedBox(height: 10),

                              /// Descripcion corta del tema.
                              Text(
                                tema.descripcion.isNotEmpty
                                    ? tema.descripcion
                                    : 'Sin descripcion disponible.',
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),

                              /// Fecha del tema.
                              if (tema.fecha.isNotEmpty) ...[
                                const SizedBox(height: 10),
                                Text(
                                  tema.fecha,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}