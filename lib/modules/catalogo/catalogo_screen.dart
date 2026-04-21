import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/routes/app_routes.dart';
import '../../models/catalogo/catalogo_item_model.dart';
import '../../providers/catalogo_provider.dart';

/// Pantalla principal del módulo de catálogo.
///
/// Esta pantalla permite:
/// - Consultar el listado de vehículos disponibles
/// - Filtrar por marca, modelo, año y rango de precio
/// - Mostrar estados de carga, error y lista vacía
/// - Navegar al detalle de un vehículo específico
class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  /// Controlador para el campo de marca.
  final _marcaController = TextEditingController();

  /// Controlador para el campo de modelo.
  final _modeloController = TextEditingController();

  /// Controlador para el campo de año.
  final _anioController = TextEditingController();

  /// Controlador para el campo de precio mínimo.
  final _precioMinController = TextEditingController();

  /// Controlador para el campo de precio máximo.
  final _precioMaxController = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// Al cargar la pantalla por primera vez,
    /// se consulta el catálogo completo sin filtros.
    Future.microtask(() {
      if (!mounted) return;
      context.read<CatalogoProvider>().fetchCatalogo();
    });
  }

  @override
  void dispose() {
    /// Se liberan los controladores para evitar fugas de memoria.
    _marcaController.dispose();
    _modeloController.dispose();
    _anioController.dispose();
    _precioMinController.dispose();
    _precioMaxController.dispose();
    super.dispose();
  }

  /// Aplica los filtros escritos por el usuario y vuelve a consultar el catálogo.
  void _buscar() {
    final provider = context.read<CatalogoProvider>();

    provider.updateFiltros(
      marca: _marcaController.text.trim(),
      modelo: _modeloController.text.trim(),
      anio: _anioController.text.trim(),
      precioMin: _precioMinController.text.trim(),
      precioMax: _precioMaxController.text.trim(),
    );

    provider.fetchCatalogo();
  }

  /// Limpia todos los campos de filtro y vuelve a consultar
  /// el catálogo sin parámetros.
  void _limpiar() {
    _marcaController.clear();
    _modeloController.clear();
    _anioController.clear();
    _precioMinController.clear();
    _precioMaxController.clear();

    final provider = context.read<CatalogoProvider>();
    provider.limpiarFiltros();
    provider.fetchCatalogo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo'),
      ),

      /// Se observa el estado del [CatalogoProvider]
      /// para reconstruir la interfaz según el resultado.
      body: Consumer<CatalogoProvider>(
        builder: (context, provider, _) {
          return Column(
            children: [
              /// Sección superior con filtros de búsqueda.
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  children: [
                    /// Campo para filtrar por marca.
                    TextField(
                      controller: _marcaController,
                      decoration: const InputDecoration(
                        labelText: 'Marca',
                        prefixIcon: Icon(Icons.directions_car_outlined),
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// Campo para filtrar por modelo.
                    TextField(
                      controller: _modeloController,
                      decoration: const InputDecoration(
                        labelText: 'Modelo',
                        prefixIcon: Icon(Icons.sell_outlined),
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// Campo para filtrar por año.
                    TextField(
                      controller: _anioController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Año',
                        prefixIcon: Icon(Icons.calendar_month_outlined),
                      ),
                    ),
                    const SizedBox(height: 10),

                    /// Fila con rango de precios.
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _precioMinController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Precio mín.',
                              prefixIcon: Icon(Icons.attach_money_outlined),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _precioMaxController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Precio máx.',
                              prefixIcon: Icon(Icons.money_off_csred_outlined),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    /// Botones de acción para buscar y limpiar filtros.
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: provider.isLoading ? null : _buscar,
                            child: const Text('Buscar'),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: provider.isLoading ? null : _limpiar,
                            child: const Text('Limpiar'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              /// Sección principal donde se muestran:
              /// - loading
              /// - error
              /// - lista vacía
              /// - resultados
              Expanded(
                child: Builder(
                  builder: (_) {
                    /// Estado de carga mientras la API responde.
                    if (provider.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    /// Estado de error cuando la consulta falla.
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

                    /// Estado vacío cuando la API responde correctamente,
                    /// pero no devuelve vehículos.
                    if (provider.items.isEmpty) {
                      return Center(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.directions_car_outlined,
                                size: 56,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              Text(
                                'No hay vehículos disponibles en el catálogo en este momento.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Prueba con otros filtros o inténtalo más tarde.',
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

                    /// Lista de vehículos encontrada.
                    return RefreshIndicator(
                      onRefresh: provider.fetchCatalogo,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: provider.items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final CatalogoItemModel item = provider.items[index];

                          /// Cada tarjeta representa un vehículo del catálogo.
                          /// Al tocarla, se navega a la pantalla de detalle.
                          return InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.catalogoDetalle,
                                arguments: item.id,
                              );
                            },
                            child: Card(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Imagen principal del vehículo,
                                  /// si la API devuelve una URL válida.
                                  if (item.imagenUrl.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: item.imagenUrl,
                                        width: double.infinity,
                                        height: 210,
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) => const SizedBox(
                                          height: 210,
                                          child: Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
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

                                  /// Información textual del vehículo.
                                  Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        /// Nombre completo del vehículo.
                                        Text(
                                          item.nombreCompleto.isNotEmpty
                                              ? item.nombreCompleto
                                              : 'Vehículo sin nombre',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),

                                        /// Año del vehículo.
                                        if (item.anio.isNotEmpty)
                                          Text(
                                            'Año: ${item.anio}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        const SizedBox(height: 6),

                                        /// Precio del vehículo.
                                        if (item.precio.isNotEmpty)
                                          Text(
                                            'Precio: ${item.precio}',
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        const SizedBox(height: 10),

                                        /// Descripción breve del vehículo.
                                        Text(
                                          item.descripcion.isNotEmpty
                                              ? item.descripcion
                                              : 'Sin descripción disponible.',
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
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