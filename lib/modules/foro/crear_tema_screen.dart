import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/vehiculos/vehiculo_item_model.dart';
import '../../providers/foro_provider.dart';
import '../../providers/vehiculos_provider.dart';

/// Pantalla para crear un nuevo tema en el foro.
///
/// Aqui el usuario puede:
/// - seleccionar uno de sus vehiculos
/// - escribir el titulo del tema
/// - escribir la descripcion
/// - publicar el tema en el foro
///
/// Esta pantalla necesita que el usuario tenga
/// al menos un vehiculo registrado.
class CrearTemaScreen extends StatefulWidget {
  const CrearTemaScreen({super.key});

  @override
  State<CrearTemaScreen> createState() =>
      _CrearTemaScreenState();
}

class _CrearTemaScreenState extends State<CrearTemaScreen> {
  /// Llave del formulario para validar datos.
  final _formKey = GlobalKey<FormState>();

  /// Controlador del titulo.
  final _tituloController = TextEditingController();

  /// Controlador de la descripcion.
  final _descripcionController = TextEditingController();

  /// Guarda el ID del vehiculo seleccionado.
  int? _vehiculoIdSeleccionado;

  @override
  void initState() {
    super.initState();

    /// Al abrir la pantalla, carga los vehiculos del usuario.
    Future.microtask(() {
      if (!mounted) return;

      context
          .read<VehiculosProvider>()
          .fetchVehiculos();
    });
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  /// Publica el nuevo tema en el foro.
  ///
  /// Primero valida:
  /// - que el formulario este correcto
  /// - que haya un vehiculo seleccionado
  ///
  /// Si todo sale bien:
  /// - muestra mensaje de exito
  /// - regresa a la pantalla anterior
  Future<void> _publicarTema() async {
    if (!_formKey.currentState!.validate()) return;

    if (_vehiculoIdSeleccionado == null ||
        _vehiculoIdSeleccionado! <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Debes seleccionar un vehiculo.',
          ),
        ),
      );
      return;
    }

    final foroProvider =
    context.read<ForoProvider>();

    final ok = await foroProvider.crearTema(
      vehiculoId: _vehiculoIdSeleccionado!,
      titulo: _tituloController.text.trim(),
      descripcion:
      _descripcionController.text.trim(),
    );

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
          Text('Tema creado correctamente.'),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            foroProvider.crearTemaErrorMessage ??
                'No se pudo crear el tema.',
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
        title: const Text('Crear tema'),
      ),

      body: Consumer2<ForoProvider,
          VehiculosProvider>(
        builder: (
            context,
            foroProvider,
            vehiculosProvider,
            _,
            ) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  /// Titulo principal.
                  Text(
                    'Publica un nuevo tema en el foro',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall,
                  ),

                  const SizedBox(height: 8),

                  /// Texto explicativo.
                  Text(
                    'Selecciona uno de tus vehiculos y comparte tu consulta o experiencia.',
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge,
                  ),

                  const SizedBox(height: 20),

                  /// Selector de vehiculo.
                  DropdownButtonFormField<int>(
                    value:
                    _vehiculoIdSeleccionado,
                    decoration:
                    const InputDecoration(
                      labelText: 'Vehiculo',
                      prefixIcon: Icon(
                        Icons
                            .directions_car_outlined,
                      ),
                    ),

                    items: vehiculosProvider
                        .vehiculos
                        .map(
                          (VehiculoItemModel v) {
                        return DropdownMenuItem<int>(
                          value: v.id,
                          child: Text(
                            v.nombreCompleto
                                .isNotEmpty
                                ? '${v.nombreCompleto} - ${v.anio}'
                                : 'Vehiculo ${v.id}',
                          ),
                        );
                      },
                    ).toList(),

                    onChanged: (value) {
                      setState(() {
                        _vehiculoIdSeleccionado =
                            value;
                      });
                    },

                    validator: (value) {
                      if (value == null ||
                          value <= 0) {
                        return 'Debes seleccionar un vehiculo.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  /// Campo titulo.
                  TextFormField(
                    controller: _tituloController,
                    decoration:
                    const InputDecoration(
                      labelText: 'Titulo',
                      prefixIcon: Icon(
                        Icons.title_outlined,
                      ),
                    ),
                    validator: (value) {
                      if ((value ?? '')
                          .trim()
                          .isEmpty) {
                        return 'Debes ingresar el titulo.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  /// Campo descripcion.
                  TextFormField(
                    controller:
                    _descripcionController,
                    maxLines: 5,
                    decoration:
                    const InputDecoration(
                      labelText: 'Descripcion',
                      alignLabelWithHint: true,
                      prefixIcon: Icon(
                        Icons
                            .description_outlined,
                      ),
                    ),
                    validator: (value) {
                      if ((value ?? '')
                          .trim()
                          .isEmpty) {
                        return 'Debes ingresar la descripcion.';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24),

                  /// Boton publicar.
                  ElevatedButton(
                    onPressed: foroProvider
                        .isCreatingTema
                        ? null
                        : _publicarTema,
                    child: foroProvider
                        .isCreatingTema
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                        : const Text(
                      'Publicar tema',
                    ),
                  ),

                  /// Mensaje si no hay vehiculos.
                  if (vehiculosProvider
                      .vehiculos.isEmpty) ...[
                    const SizedBox(height: 16),
                    const Text(
                      'No tienes vehiculos cargados. Debes registrar al menos uno para crear un tema.',
                      style:
                      TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}