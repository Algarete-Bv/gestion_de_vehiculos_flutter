import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../providers/noticias_provider.dart';

/// Pantalla para mostrar el detalle completo de una noticia.
///
/// Aqui se muestra:
/// - titulo
/// - fecha
/// - contenido HTML
/// - imagenes dentro del contenido
/// - enlaces externos
///
/// Esta pantalla recibe el ID de la noticia
/// por medio de la navegacion.
class NoticiaDetalleScreen extends StatefulWidget {
  const NoticiaDetalleScreen({super.key});

  @override
  State<NoticiaDetalleScreen> createState() =>
      _NoticiaDetalleScreenState();
}

class _NoticiaDetalleScreenState
    extends State<NoticiaDetalleScreen> {
  /// Control para evitar cargar el detalle varias veces.
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    /// Solo se ejecuta una vez al abrir la pantalla.
    if (_loaded) return;
    _loaded = true;

    /// Obtiene el argumento enviado por la ruta.
    final args = ModalRoute.of(context)?.settings.arguments;

    int noticiaId = 0;

    /// Convierte el argumento a entero de forma segura.
    if (args is int) {
      noticiaId = args;
    } else if (args is String) {
      noticiaId = int.tryParse(args) ?? 0;
    } else if (args is num) {
      noticiaId = args.toInt();
    }

    /// Si el ID es valido, se pide el detalle al provider.
    if (noticiaId > 0) {
      Future.microtask(() {
        if (!mounted) return;

        context
            .read<NoticiasProvider>()
            .fetchNoticiaDetalle(noticiaId);
      });
    }
  }

  /// Abre enlaces externos del contenido HTML.
  Future<void> _abrirLink(String url) async {
    final uri = Uri.tryParse(url);

    if (uri == null) return;

    await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Barra superior de la pantalla.
      appBar: AppBar(
        title: const Text('Detalle de noticia'),
      ),

      body: Consumer<NoticiasProvider>(
        builder: (context, provider, _) {
          /// Estado mientras carga.
          if (provider.isDetalleLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          /// Estado cuando ocurre error.
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

          final detalle = provider.noticiaDetalle;

          /// Estado cuando no hay datos.
          if (detalle == null) {
            return const Center(
              child: Text(
                'No se encontro el detalle.',
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// Tarjeta principal con titulo y fecha.
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        color:
                        Colors.black.withOpacity(.05),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      /// Titulo de la noticia.
                      Text(
                        detalle.titulo,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight:
                          FontWeight.bold,
                          height: 1.25,
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// Fecha de publicacion.
                      Text(
                        detalle.fecha,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                /// Tarjeta con contenido HTML.
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,
                        color:
                        Colors.black.withOpacity(.04),
                      ),
                    ],
                  ),
                  child: Html(
                    /// Contenido HTML recibido desde la API.
                    data: detalle.contenidoHtml,

                    /// Permite abrir enlaces del contenido.
                    onLinkTap:
                        (url, attributes, element) async {
                      if (url == null) return;
                      await _abrirLink(url);
                    },

                    /// Personalizacion de imagenes dentro del HTML.
                    ///
                    /// Esto ayuda a que se vean mejor en pantalla
                    /// y evita que salgan deformadas o muy pequeñas.
                    extensions: [
                      TagExtension(
                        tagsToExtend: {"img"},
                        builder: (context) {
                          final src =
                              context.attributes['src'] ?? '';

                          if (src.isEmpty) {
                            return const SizedBox();
                          }

                          return Padding(
                            padding:
                            const EdgeInsets.only(
                              bottom: 18,
                            ),
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(14),
                              child: Image.network(
                                src,
                                width: double.infinity,
                                fit: BoxFit.cover,

                                /// Loader mientras carga imagen.
                                loadingBuilder: (
                                    context,
                                    child,
                                    progress,
                                    ) {
                                  if (progress == null) {
                                    return child;
                                  }

                                  return SizedBox(
                                    height: 220,
                                    child: Center(
                                      child:
                                      CircularProgressIndicator(
                                        value: progress
                                            .expectedTotalBytes !=
                                            null
                                            ? progress
                                            .cumulativeBytesLoaded /
                                            progress
                                                .expectedTotalBytes!
                                            : null,
                                      ),
                                    ),
                                  );
                                },

                                /// Vista si falla la imagen.
                                errorBuilder: (
                                    context,
                                    error,
                                    stackTrace,
                                    ) {
                                  return Container(
                                    height: 220,
                                    color: Colors
                                        .grey
                                        .shade200,
                                    alignment:
                                    Alignment.center,
                                    child: const Icon(
                                      Icons
                                          .image_not_supported,
                                      size: 40,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ],

                    /// Estilos generales del HTML.
                    style: {
                      "body": Style(
                        margin: Margins.zero,
                        padding: HtmlPaddings.zero,
                        fontSize: FontSize(16),
                        lineHeight:
                        const LineHeight(1.65),
                      ),

                      "p": Style(
                        margin:
                        Margins.only(bottom: 14),
                      ),

                      "a": Style(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        textDecoration:
                        TextDecoration.underline,
                      ),
                    },
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