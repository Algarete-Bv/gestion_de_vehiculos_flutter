import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/catalogo_provider.dart';

class CatalogoDetalleScreen extends StatefulWidget {
  const CatalogoDetalleScreen({super.key});

  @override
  State<CatalogoDetalleScreen> createState() => _CatalogoDetalleScreenState();
}

class _CatalogoDetalleScreenState extends State<CatalogoDetalleScreen> {
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_loaded) return;
    _loaded = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    final int id = args is int ? args : 0;

    if (id > 0) {
      Future.microtask(() {
        if (!mounted) return;
        context.read<CatalogoProvider>().fetchDetalle(id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del vehículo'),
      ),
      body: Consumer<CatalogoProvider>(
        builder: (context, provider, _) {
          if (provider.isDetalleLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

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

          if (detalle == null) {
            return const Center(
              child: Text('No se encontró el detalle del vehículo.'),
            );
          }

          final imagenPrincipal =
          detalle.imagenes.isNotEmpty ? detalle.imagenes.first : '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imagenPrincipal.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: imagenPrincipal,
                      width: double.infinity,
                      height: 230,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const SizedBox(
                        height: 230,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        height: 230,
                        alignment: Alignment.center,
                        child: const Icon(Icons.image_not_supported_rounded),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  detalle.nombreCompleto.isNotEmpty
                      ? detalle.nombreCompleto
                      : 'Vehículo sin nombre',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                if (detalle.anio.isNotEmpty)
                  Text(
                    'Año: ${detalle.anio}',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                const SizedBox(height: 6),
                if (detalle.precio.isNotEmpty)
                  Text(
                    'Precio: ${detalle.precio}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  detalle.descripcion.isNotEmpty
                      ? detalle.descripcion
                      : 'Sin descripción disponible.',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                if (detalle.especificaciones.isNotEmpty) ...[
                  const Text(
                    'Especificaciones',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...detalle.especificaciones.entries.map(
                        (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '${entry.key}: ${entry.value}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
                if (detalle.imagenes.length > 1) ...[
                  const SizedBox(height: 20),
                  const Text(
                    'Galería',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: detalle.imagenes.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final image = detalle.imagenes[index];

                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CachedNetworkImage(
                            imageUrl: image,
                            width: 120,
                            height: 100,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              width: 120,
                              height: 100,
                              alignment: Alignment.center,
                              child: const Icon(Icons.broken_image_outlined),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}