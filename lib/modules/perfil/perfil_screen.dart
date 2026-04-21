import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/perfil_provider.dart';

/// Pantalla Mi Perfil.
///
/// Aqui el usuario puede:
/// - ver su informacion personal
/// - ver foto de perfil
/// - actualizar foto desde galeria
/// - tomar foto con camara
/// - refrescar informacion
class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() =>
      _PerfilScreenState();
}

class _PerfilScreenState
    extends State<PerfilScreen> {
  /// Selector de imagenes.
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    /// Carga inicial del perfil.
    Future.microtask(() {
      if (!mounted) return;

      context
          .read<PerfilProvider>()
          .fetchPerfil();
    });
  }

  /// Selecciona imagen desde galeria.
  Future<void>
  _seleccionarDesdeGaleria() async {
    final XFile? image =
    await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return;

    final ok = await context
        .read<PerfilProvider>()
        .subirFotoPerfil(
      File(image.path),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Foto de perfil actualizada correctamente.'
              : (context
              .read<
              PerfilProvider>()
              .uploadPhotoErrorMessage ??
              'No se pudo actualizar la foto de perfil.'),
        ),
      ),
    );
  }

  /// Toma foto con camara.
  Future<void> _tomarFoto() async {
    final XFile? image =
    await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );

    if (image == null) return;

    final ok = await context
        .read<PerfilProvider>()
        .subirFotoPerfil(
      File(image.path),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(
          ok
              ? 'Foto de perfil actualizada correctamente.'
              : (context
              .read<
              PerfilProvider>()
              .uploadPhotoErrorMessage ??
              'No se pudo actualizar la foto de perfil.'),
        ),
      ),
    );
  }

  /// Construye avatar del usuario.
  ///
  /// Si hay foto, muestra imagen.
  /// Si no hay foto, muestra inicial.
  Widget _buildAvatar(
      String fotoUrl,
      String inicial,
      ) {
    if (fotoUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 52,
        backgroundImage:
        NetworkImage(fotoUrl),
        onBackgroundImageError:
            (_, __) {},
      );
    }

    return CircleAvatar(
      radius: 52,
      child: Text(
        inicial,
        style: const TextStyle(
          fontSize: 28,
          fontWeight:
          FontWeight.bold,
        ),
      ),
    );
  }

  /// Tarjeta reutilizable de datos.
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(
          value.isNotEmpty
              ? value
              : 'No disponible',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Barra superior.
      appBar: AppBar(
        title: const Text('Mi Perfil'),
      ),

      body: Consumer<PerfilProvider>(
        builder: (
            context,
            provider,
            _,
            ) {
          /// Cargando datos.
          if (provider.isLoading) {
            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          /// Error al cargar.
          if (provider.errorMessage !=
              null) {
            return Center(
              child: Padding(
                padding:
                const EdgeInsets.all(
                    24),
                child: Text(
                  provider.errorMessage!,
                  textAlign:
                  TextAlign.center,
                ),
              ),
            );
          }

          final perfil =
              provider.perfil;

          /// Sin informacion.
          if (perfil == null) {
            return const Center(
              child: Text(
                'No se encontro la informacion del perfil.',
              ),
            );
          }

          /// Inicial del usuario.
          final inicial = perfil
              .nombreCompleto
              .isNotEmpty
              ? perfil
              .nombreCompleto[0]
              .toUpperCase()
              : 'U';

          return RefreshIndicator(
            onRefresh:
            provider.fetchPerfil,
            child: ListView(
              padding:
              const EdgeInsets.all(
                  16),
              children: [
                /// Avatar
                Center(
                  child: _buildAvatar(
                    perfil.fotoUrl,
                    inicial,
                  ),
                ),

                const SizedBox(
                    height: 16),

                /// Nombre
                Center(
                  child: Text(
                    perfil.nombreCompleto
                        .isNotEmpty
                        ? perfil
                        .nombreCompleto
                        : 'Usuario',
                    style:
                    const TextStyle(
                      fontSize: 22,
                      fontWeight:
                      FontWeight
                          .bold,
                    ),
                    textAlign:
                    TextAlign
                        .center,
                  ),
                ),

                const SizedBox(
                    height: 8),

                /// Correo
                Center(
                  child: Text(
                    perfil.correo
                        .isNotEmpty
                        ? perfil.correo
                        : 'Sin correo',
                    textAlign:
                    TextAlign
                        .center,
                    style:
                    const TextStyle(
                      color:
                      Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(
                    height: 20),

                /// Botones de foto
                Row(
                  children: [
                    Expanded(
                      child:
                      OutlinedButton
                          .icon(
                        onPressed: provider
                            .isUploadingPhoto
                            ? null
                            : _seleccionarDesdeGaleria,
                        icon:
                        const Icon(
                          Icons
                              .photo_library_outlined,
                        ),
                        label:
                        const Text(
                          'Galeria',
                        ),
                      ),
                    ),

                    const SizedBox(
                        width: 10),

                    Expanded(
                      child:
                      OutlinedButton
                          .icon(
                        onPressed: provider
                            .isUploadingPhoto
                            ? null
                            : _tomarFoto,
                        icon:
                        const Icon(
                          Icons
                              .photo_camera_outlined,
                        ),
                        label:
                        const Text(
                          'Camara',
                        ),
                      ),
                    ),
                  ],
                ),

                /// Loader al subir foto
                if (provider
                    .isUploadingPhoto) ...[
                  const SizedBox(
                      height: 16),
                  const Center(
                    child:
                    CircularProgressIndicator(),
                  ),
                ],

                const SizedBox(
                    height: 24),

                /// Datos del usuario
                _buildInfoTile(
                  icon:
                  Icons.person_outline,
                  title: 'Nombre',
                  value: perfil
                      .nombreCompleto,
                ),

                _buildInfoTile(
                  icon:
                  Icons.email_outlined,
                  title: 'Correo',
                  value: perfil.correo,
                ),

                _buildInfoTile(
                  icon:
                  Icons.badge_outlined,
                  title: 'Rol',
                  value: perfil.rol,
                ),

                _buildInfoTile(
                  icon:
                  Icons.group_outlined,
                  title: 'Grupo',
                  value: perfil.grupo,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}