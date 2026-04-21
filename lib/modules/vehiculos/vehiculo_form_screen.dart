import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../models/vehiculos/vehiculo_item_model.dart';
import '../../providers/vehiculos_provider.dart';

class VehiculoFormScreen extends StatefulWidget {
  const VehiculoFormScreen({super.key});

  @override
  State<VehiculoFormScreen> createState() => _VehiculoFormScreenState();
}

class _VehiculoFormScreenState extends State<VehiculoFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _placaController = TextEditingController();
  final _chasisController = TextEditingController();
  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _anioController = TextEditingController();
  final _cantidadRuedasController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  VehiculoItemModel? vehiculoEditar;
  bool _loaded = false;

  File? _fotoSeleccionada;

  @override
  void dispose() {
    _placaController.dispose();
    _chasisController.dispose();
    _marcaController.dispose();
    _modeloController.dispose();
    _anioController.dispose();
    _cantidadRuedasController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_loaded) return;
    _loaded = true;

    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is VehiculoItemModel) {
      vehiculoEditar = args;
      _placaController.text = args.placa;
      _chasisController.text = args.chasis;
      _marcaController.text = args.marca;
      _modeloController.text = args.modelo;
      _anioController.text = args.anio;
    }
  }

  Future<void> _seleccionarDesdeGaleria() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return;

    setState(() {
      _fotoSeleccionada = File(image.path);
    });
  }

  Future<void> _tomarFoto() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (image == null) return;

    setState(() {
      _fotoSeleccionada = File(image.path);
    });
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<VehiculosProvider>();

    final placa = _placaController.text.trim();
    final chasis = _chasisController.text.trim();
    final marca = _marcaController.text.trim();
    final modelo = _modeloController.text.trim();
    final anio = _anioController.text.trim();
    final cantidadRuedas = _cantidadRuedasController.text.trim().isEmpty
        ? '4'
        : _cantidadRuedasController.text.trim();

    bool ok;

    if (vehiculoEditar == null) {
      ok = await provider.crearVehiculo(
        placa: placa,
        chasis: chasis,
        marca: marca,
        modelo: modelo,
        anio: anio,
        cantidadRuedas: cantidadRuedas,
        foto: _fotoSeleccionada,
      );
    } else {
      ok = await provider.editarVehiculo(
        id: vehiculoEditar!.id,
        placa: placa,
        chasis: chasis,
        marca: marca,
        modelo: modelo,
        anio: anio,
        cantidadRuedas: cantidadRuedas,
        foto: _fotoSeleccionada,
      );
    }

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            vehiculoEditar == null
                ? 'Vehículo guardado correctamente.'
                : 'Vehículo actualizado correctamente.',
          ),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            provider.submitErrorMessage ??
                'No se pudo guardar el vehículo.',
          ),
        ),
      );
    }
  }

  Widget _buildPreviewFoto() {
    if (_fotoSeleccionada != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(
          _fotoSeleccionada!,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    if (vehiculoEditar != null &&
        vehiculoEditar!.fotoUrl.isNotEmpty &&
        _fotoSeleccionada == null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          vehiculoEditar!.fotoUrl,
          height: 180,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) {
            return Container(
              height: 180,
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200,
              ),
              child: const Icon(
                Icons.image_not_supported_outlined,
                size: 40,
              ),
            );
          },
        ),
      );
    }

    return Container(
      height: 180,
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade100,
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.camera_alt_outlined,
            size: 40,
            color: Colors.grey,
          ),
          SizedBox(height: 8),
          Text(
            'Sin foto seleccionada',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          vehiculoEditar == null ? 'Agregar vehículo' : 'Editar vehículo',
        ),
      ),
      body: Consumer<VehiculosProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildPreviewFoto(),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _seleccionarDesdeGaleria,
                          icon: const Icon(Icons.photo_library_outlined),
                          label: const Text('Galería'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _tomarFoto,
                          icon: const Icon(Icons.photo_camera_outlined),
                          label: const Text('Cámara'),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _placaController,
                    decoration: const InputDecoration(
                      labelText: 'Placa',
                    ),
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Debes ingresar la placa.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _chasisController,
                    decoration: const InputDecoration(
                      labelText: 'Chasis',
                    ),
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Debes ingresar el chasis.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _marcaController,
                    decoration: const InputDecoration(
                      labelText: 'Marca',
                    ),
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Debes ingresar la marca.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _modeloController,
                    decoration: const InputDecoration(
                      labelText: 'Modelo',
                    ),
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Debes ingresar el modelo.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _anioController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Año',
                    ),
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return 'Debes ingresar el año.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cantidadRuedasController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cantidad de ruedas',
                      hintText: 'Ej. 4',
                    ),
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: provider.isSubmitting ? null : _guardar,
                    child: provider.isSubmitting
                        ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                        : Text(
                      vehiculoEditar == null
                          ? 'Guardar vehículo'
                          : 'Actualizar vehículo',
                    ),
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