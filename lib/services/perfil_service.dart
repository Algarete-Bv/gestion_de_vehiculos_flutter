import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import '../core/network/dio_client.dart';
import '../models/perfil/perfil_model.dart';

/// Servicio del módulo Perfil.
///
/// Endpoints esperados:
/// - GET /perfil
/// - POST /perfil/foto
class PerfilService {
  final Dio _dio = DioClient().dio;

  Future<PerfilModel> getPerfil() async {
    final response = await _dio.get('perfil');
    final data = _extractMap(response.data);
    return PerfilModel.fromJson(data);
  }

  Future<void> subirFotoPerfil(File foto) async {
    final fileName = foto.path.split(Platform.pathSeparator).last;

    final formData = FormData.fromMap({
      'datax': jsonEncode({}),
      'foto': await MultipartFile.fromFile(
        foto.path,
        filename: fileName,
      ),
    });

    await _dio.post(
      'perfil/foto',
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
      ),
    );
  }

  Map<String, dynamic> _extractMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      final nested = data['data'];
      if (nested is Map<String, dynamic>) return nested;
      return data;
    }

    return {};
  }
}