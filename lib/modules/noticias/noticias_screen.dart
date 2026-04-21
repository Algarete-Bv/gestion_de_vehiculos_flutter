import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../providers/noticias_provider.dart';
import '../../models/noticias/noticia_model.dart';

/// Pantalla Noticias.
///
/// Esta pantalla muestra todas las noticias
/// obtenidas desde la API.
///
/// El usuario puede:
/// - ver listado de noticias
/// - ver imagen de cada noticia
/// - leer resumen rapido
/// - abrir detalle completo
/// - actualizar deslizando hacia abajo
class NoticiasScreen extends StatefulWidget {
  const NoticiasScreen({super.key});

  @override
  State<NoticiasScreen> createState() =>
      _NoticiasScreenState();
}

class _NoticiasScreenState
    extends State<NoticiasScreen> {
  @override
  void initState() {
    super.initState();

    /// Al abrir pantalla carga noticias.
    Future.microtask(() {
      if (!mounted) return;

      context
          .read<NoticiasProvider>()
          .fetchNoticias();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Barra superior
      appBar: AppBar(
        title: const Text('Noticias'),
      ),

      body: Consumer<NoticiasProvider>(
        builder: (
            context,
            provider,
            _,
            ) {
          /// Mientras carga datos
          if (provider.isLoading) {
            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          /// Si ocurre error
          if (provider.errorMessage !=
              null) {
            return _ErrorView(
              message:
              provider.errorMessage!,
              onRetry:
              provider.fetchNoticias,
            );
          }

          /// Si no hay noticias
          if (provider
              .noticias.isEmpty) {
            return const Center(
              child: Text(
                'No hay noticias disponibles por el momento.',
              ),
            );
          }

          /// Lista principal
          return RefreshIndicator(
            onRefresh:
            provider.fetchNoticias,

            child: ListView.separated(
              padding:
              const EdgeInsets.all(
                  16),

              itemCount: provider
                  .noticias.length,

              separatorBuilder:
                  (_, __) =>
              const SizedBox(
                height: 14,
              ),

              itemBuilder:
                  (context, index) {
                final NoticiaModel
                noticia = provider
                    .noticias[index];

                return InkWell(
                  borderRadius:
                  BorderRadius
                      .circular(
                      16),

                  /// Abrir detalle
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/noticia-detalle',
                      arguments:
                      noticia.id,
                    );
                  },

                  child: Card(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      children: [
                        /// Imagen
                        if (noticia
                            .imagenUrl
                            .isNotEmpty)
                          ClipRRect(
                            borderRadius:
                            const BorderRadius
                                .vertical(
                              top: Radius
                                  .circular(
                                  16),
                            ),
                            child:
                            CachedNetworkImage(
                              imageUrl:
                              noticia
                                  .imagenUrl,

                              width: double
                                  .infinity,

                              height: 200,

                              fit: BoxFit
                                  .cover,

                              /// Loader imagen
                              placeholder:
                                  (_, __) =>
                              const SizedBox(
                                height:
                                200,
                                child:
                                Center(
                                  child:
                                  CircularProgressIndicator(),
                                ),
                              ),

                              /// Error imagen
                              errorWidget:
                                  (_, __,
                                  ___) =>
                                  Container(
                                    height:
                                    200,
                                    width: double
                                        .infinity,
                                    alignment:
                                    Alignment
                                        .center,
                                    child:
                                    const Icon(
                                      Icons
                                          .image_not_supported,
                                    ),
                                  ),
                            ),
                          ),

                        /// Contenido noticia
                        Padding(
                          padding:
                          const EdgeInsets
                              .all(14),

                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [
                              /// Titulo
                              Text(
                                noticia
                                    .titulo,
                                style:
                                const TextStyle(
                                  fontSize:
                                  18,
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),

                              const SizedBox(
                                  height:
                                  8),

                              /// Fecha
                              if (noticia
                                  .fecha
                                  .isNotEmpty)
                                Text(
                                  noticia
                                      .fecha,
                                  style:
                                  const TextStyle(
                                    fontSize:
                                    13,
                                    color:
                                    Colors.grey,
                                  ),
                                ),

                              const SizedBox(
                                  height:
                                  10),

                              /// Resumen
                              Text(
                                noticia
                                    .resumen
                                    .isNotEmpty
                                    ? noticia
                                    .resumen
                                    : 'Sin resumen disponible.',
                              ),
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

/// Vista cuando ocurre error.
///
/// Muestra mensaje y boton reintentar.
class _ErrorView
    extends StatelessWidget {
  final String message;
  final Future<void> Function()
  onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding:
        const EdgeInsets.all(24),

        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
            ),

            const SizedBox(
                height: 12),

            Text(
              message,
              textAlign:
              TextAlign.center,
            ),

            const SizedBox(
                height: 16),

            ElevatedButton(
              onPressed: onRetry,
              child: const Text(
                'Reintentar',
              ),
            ),
          ],
        ),
      ),
    );
  }
}