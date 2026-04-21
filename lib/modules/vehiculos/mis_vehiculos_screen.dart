import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../models/vehiculos/vehiculo_item_model.dart';
import '../../providers/vehiculos_provider.dart';

/// Pantalla Mis Vehiculos.
///
/// Aqui el usuario puede:
/// - ver sus vehiculos registrados
/// - buscar por marca
/// - buscar por modelo
/// - limpiar filtros
/// - entrar al detalle
/// - editar vehiculos
/// - agregar un nuevo vehiculo
class MisVehiculosScreen extends StatefulWidget {
  const MisVehiculosScreen({super.key});

  @override
  State<MisVehiculosScreen> createState() =>
      _MisVehiculosScreenState();
}

class _MisVehiculosScreenState
    extends State<MisVehiculosScreen> {
  /// Controladores de filtros.
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// Carga inicial de vehiculos.
    Future.microtask(() {
      if (!mounted) return;

      context
          .read<VehiculosProvider>()
          .fetchVehiculos();
    });
  }

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    super.dispose();
  }

  /// Busca usando filtros escritos.
  void _buscar() {
    final provider =
    context.read<VehiculosProvider>();

    provider.updateFiltros(
      marca: _marcaController.text.trim(),
      modelo: _modeloController.text.trim(),
    );

    provider.fetchVehiculos();
  }

  /// Limpia filtros y recarga listado.
  void _limpiar() {
    _marcaController.clear();
    _modeloController.clear();

    final provider =
    context.read<VehiculosProvider>();

    provider.limpiarFiltros();
    provider.fetchVehiculos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Barra superior.
      appBar: AppBar(
        title: const Text('Mis Vehiculos'),
      ),

      /// Boton para crear nuevo vehiculo.
      floatingActionButton:
      FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AppRoutes.vehiculoForm,
          );
        },
        child: const Icon(Icons.add),
      ),

      body: Consumer<VehiculosProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              /// Zona de filtros.
              Padding(
                padding:
                const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  8,
                ),
                child: Column(
                  children: [
                    TextField(
                      controller:
                      _marcaController,
                      decoration:
                      const InputDecoration(
                        labelText:
                        'Filtrar por marca',
                        prefixIcon: Icon(
                          Icons
                              .directions_car_outlined,
                        ),
                      ),
                    ),

                    const SizedBox(
                        height: 10),

                    TextField(
                      controller:
                      _modeloController,
                      decoration:
                      const InputDecoration(
                        labelText:
                        'Filtrar por modelo',
                        prefixIcon: Icon(
                          Icons
                              .sell_outlined,
                        ),
                      ),
                    ),

                    const SizedBox(
                        height: 12),

                    Row(
                      children: [
                        Expanded(
                          child:
                          ElevatedButton(
                            onPressed:
                            provider
                                .isLoading
                                ? null
                                : _buscar,
                            child:
                            const Text(
                              'Buscar',
                            ),
                          ),
                        ),

                        const SizedBox(
                            width: 10),

                        Expanded(
                          child:
                          OutlinedButton(
                            onPressed:
                            provider
                                .isLoading
                                ? null
                                : _limpiar,
                            child:
                            const Text(
                              'Limpiar',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// Area principal.
              Expanded(
                child: Builder(
                  builder: (_) {
                    /// Cargando.
                    if (provider
                        .isLoading) {
                      return const Center(
                        child:
                        CircularProgressIndicator(),
                      );
                    }

                    /// Error.
                    if (provider
                        .errorMessage !=
                        null) {
                      return Center(
                        child: Padding(
                          padding:
                          const EdgeInsets
                              .all(24),
                          child: Text(
                            provider
                                .errorMessage!,
                            textAlign:
                            TextAlign
                                .center,
                          ),
                        ),
                      );
                    }

                    /// Lista vacia.
                    if (provider
                        .vehiculos
                        .isEmpty) {
                      return const Center(
                        child: Padding(
                          padding:
                          EdgeInsets
                              .all(24),
                          child: Column(
                            mainAxisSize:
                            MainAxisSize
                                .min,
                            children: [
                              Icon(
                                Icons
                                    .directions_car_outlined,
                                size: 56,
                                color: Colors
                                    .grey,
                              ),
                              SizedBox(
                                  height:
                                  16),
                              Text(
                                'Todavia no tienes vehiculos registrados.',
                                textAlign:
                                TextAlign
                                    .center,
                                style:
                                TextStyle(
                                  fontSize:
                                  16,
                                  fontWeight:
                                  FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                  height:
                                  8),
                              Text(
                                'Pulsa el boton + para agregar tu primer vehiculo.',
                                textAlign:
                                TextAlign
                                    .center,
                                style:
                                TextStyle(
                                  fontSize:
                                  14,
                                  color: Colors
                                      .grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    /// Lista con datos.
                    return RefreshIndicator(
                      onRefresh: provider
                          .fetchVehiculos,
                      child:
                      ListView.separated(
                        padding:
                        const EdgeInsets
                            .all(16),
                        itemCount: provider
                            .vehiculos
                            .length,
                        separatorBuilder:
                            (_, __) =>
                        const SizedBox(
                          height: 14,
                        ),
                        itemBuilder:
                            (context,
                            index) {
                          final VehiculoItemModel
                          item =
                          provider
                              .vehiculos[
                          index];

                          return InkWell(
                            borderRadius:
                            BorderRadius
                                .circular(
                                16),

                            /// Ir al detalle.
                            onTap: () {
                              Navigator
                                  .pushNamed(
                                context,
                                AppRoutes
                                    .vehiculoDetalle,
                                arguments:
                                item.id,
                              );
                            },

                            child: Card(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  /// Imagen del vehiculo.
                                  if (item
                                      .fotoUrl
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
                                        item.fotoUrl,
                                        width: double
                                            .infinity,
                                        height:
                                        210,
                                        fit: BoxFit
                                            .cover,
                                        placeholder:
                                            (_, __) =>
                                        const SizedBox(
                                          height:
                                          210,
                                          child:
                                          Center(
                                            child:
                                            CircularProgressIndicator(),
                                          ),
                                        ),
                                        errorWidget:
                                            (_, __,
                                            ___) =>
                                            Container(
                                              height:
                                              210,
                                              alignment:
                                              Alignment.center,
                                              child:
                                              const Icon(
                                                Icons.image_not_supported_rounded,
                                                size:
                                                42,
                                              ),
                                            ),
                                      ),
                                    ),

                                  /// Datos del vehiculo.
                                  Padding(
                                    padding:
                                    const EdgeInsets
                                        .all(
                                        14),
                                    child:
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      children: [
                                        Text(
                                          item.nombreCompleto.isNotEmpty
                                              ? item.nombreCompleto
                                              : 'Vehiculo sin nombre',
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

                                        if (item
                                            .anio
                                            .isNotEmpty)
                                          Text(
                                              'Año: ${item.anio}'),

                                        if (item
                                            .placa
                                            .isNotEmpty)
                                          Text(
                                              'Placa: ${item.placa}'),

                                        if (item
                                            .chasis
                                            .isNotEmpty)
                                          Text(
                                              'Chasis: ${item.chasis}'),

                                        const SizedBox(
                                            height:
                                            10),

                                        /// Boton editar.
                                        Align(
                                          alignment:
                                          Alignment
                                              .centerRight,
                                          child:
                                          TextButton.icon(
                                            onPressed:
                                                () {
                                              Navigator.pushNamed(
                                                context,
                                                AppRoutes.vehiculoForm,
                                                arguments:
                                                item,
                                              );
                                            },
                                            icon:
                                            const Icon(
                                              Icons.edit_outlined,
                                            ),
                                            label:
                                            const Text(
                                              'Editar',
                                            ),
                                          ),
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
              ),
            ],
          );
        },
      ),
    );
  }
}