import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/videos/video_model.dart';

class VideoDetalleScreen extends StatelessWidget {
  const VideoDetalleScreen({super.key});

  Future<void> _abrirVideo(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('No se pudo abrir el video.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments;
    final video = args is VideoModel ? args : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del video'),
      ),
      body: video == null
          ? const Center(
        child: Text('No se encontró la información del video.'),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (video.resolvedThumbnail.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  video.resolvedThumbnail,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) {
                    return Container(
                      height: 220,
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.image_not_supported_rounded,
                        size: 42,
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16),
            Text(
              video.titulo.isNotEmpty ? video.titulo : 'Video sin título',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (video.categoria.isNotEmpty)
              Text(
                'Categoría: ${video.categoria}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              video.descripcion.isNotEmpty
                  ? video.descripcion
                  : 'Sin descripción disponible.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: video.resolvedUrl.isEmpty
                  ? null
                  : () => _abrirVideo(video.resolvedUrl),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Ver video'),
            ),
          ],
        ),
      ),
    );
  }
}