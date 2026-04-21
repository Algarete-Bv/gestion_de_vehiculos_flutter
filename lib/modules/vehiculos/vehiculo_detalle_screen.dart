import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/vehiculos_provider.dart';

class VehiculoDetalleScreen extends StatefulWidget {
  const VehiculoDetalleScreen({super.key});

  @override
  State<VehiculoDetalleScreen> createState() => _VehiculoDetalleScreenState();
}

class _VehiculoDetalleScreenState extends State<VehiculoDetalleScreen> {
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_loaded) return;
    _loaded = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    int id = 0;

    if (args is int) {
      id = args;
    } else if (args is String) {
      id = int.tryParse(args) ?? 0;
    }

    if (id > 0) {
      Future.microtask(() {
        if (!mounted) return;
        context.read<VehiculosProvider>().fetchDetalle(id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del vehículo'),
      ),
      body: Consumer<VehiculosProvider>(
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (detalle.fotoUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CachedNetworkImage(
                      imageUrl: detalle.fotoUrl,
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
                const SizedBox(height: 12),
                Text('Placa: ${detalle.placa}'),
                Text('Chasis: ${detalle.chasis}'),
                Text('Año: ${detalle.anio}'),
                if (detalle.cantidadRuedas.isNotEmpty)
                  Text('Cantidad de ruedas: ${detalle.cantidadRuedas}'),
                const SizedBox(height: 20),
                if (detalle.resumenFinanciero.isNotEmpty) ...[
                  const Text(
                    'Resumen financiero',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ...detalle.resumenFinanciero.entries.map(
                        (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text('${entry.key}: ${entry.value}'),
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