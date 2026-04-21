import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/foro/crear_tema_response.dart';
import '../models/foro/foro_detalle_model.dart';
import '../models/foro/foro_tema_model.dart';
import '../models/foro/responder_tema_response.dart';
import '../repositories/foro_repository.dart';

/// Provider encargado de manejar el estado del módulo de foro.
///
/// Este provider administra:
/// - el listado de temas del foro
/// - el detalle de un tema específico
/// - la creación de nuevos temas
/// - el envío de respuestas a un tema
/// - los estados de carga
/// - los mensajes de error
///
/// También sincroniza la información en pantalla después de:
/// - crear un tema
/// - responder un tema
class ForoProvider extends ChangeNotifier {
  final ForoRepository _repository;

  ForoProvider(this._repository);

  /// Estado de carga del listado de temas.
  bool isLoading = false;

  /// Estado de carga del detalle de un tema.
  bool isDetalleLoading = false;

  /// Estado de envío al crear un nuevo tema.
  bool isCreatingTema = false;

  /// Estado de envío al responder un tema.
  bool isReplyingTema = false;

  /// Mensaje de error del listado.
  String? errorMessage;

  /// Mensaje de error del detalle.
  String? detalleErrorMessage;

  /// Mensaje de error al crear tema.
  String? crearTemaErrorMessage;

  /// Mensaje de error al responder tema.
  String? responderTemaErrorMessage;

  /// Lista de temas cargados en el foro.
  List<ForoTemaModel> temas = [];

  /// Detalle del tema seleccionado actualmente.
  ForoDetalleModel? detalle;

  /// Última respuesta de creación de tema.
  CrearTemaResponse? crearTemaResponse;

  /// Última respuesta de responder tema.
  ResponderTemaResponse? responderTemaResponse;

  /// Carga el listado de temas del foro.
  ///
  /// Este metodo se usa en la pantalla principal del foro.
  Future<void> fetchTemas() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      temas = await _repository.getTemas();
    } catch (e) {
      errorMessage = 'No se pudieron cargar los temas del foro. Error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Carga el detalle de un tema según su ID.
  ///
  /// Este metodo se usa al abrir la pantalla de detalle.
  Future<void> fetchDetalle(int id) async {
    isDetalleLoading = true;
    detalleErrorMessage = null;
    detalle = null;
    notifyListeners();

    try {
      detalle = await _repository.getDetalle(id);
    } catch (e) {
      detalleErrorMessage =
      'No se pudo cargar el detalle del tema. Error: $e';
    } finally {
      isDetalleLoading = false;
      notifyListeners();
    }
  }

  /// Crea un nuevo tema en el foro.
  ///
  /// Si el proceso es exitoso:
  /// - guarda la respuesta recibida
  /// - actualiza el listado de temas
  ///
  /// Retorna `true` si se creó correctamente.
  /// Retorna `false` si ocurrió un error.
  Future<bool> crearTema({
    required int vehiculoId,
    required String titulo,
    required String descripcion,
  }) async {
    isCreatingTema = true;
    crearTemaErrorMessage = null;
    crearTemaResponse = null;
    notifyListeners();

    try {
      final result = await _repository.crearTema(
        vehiculoId: vehiculoId,
        titulo: titulo,
        descripcion: descripcion,
      );

      crearTemaResponse = result;

      if (!result.success) {
        crearTemaErrorMessage = result.message.isNotEmpty
            ? result.message
            : 'No se pudo crear el tema.';
        return false;
      }

      /// Refresca la lista de temas para que el nuevo aparezca de inmediato.
      await fetchTemas();
      return true;
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        crearTemaErrorMessage =
            data['message']?.toString() ?? 'No se pudo crear el tema.';
      } else {
        crearTemaErrorMessage = 'No se pudo crear el tema.';
      }

      return false;
    } catch (e) {
      crearTemaErrorMessage = 'No se pudo crear el tema. Error: $e';
      return false;
    } finally {
      isCreatingTema = false;
      notifyListeners();
    }
  }

  /// Envía una respuesta a un tema del foro.
  ///
  /// Si el proceso es exitoso:
  /// - guarda la respuesta recibida
  /// - refresca el detalle del tema
  /// - refresca el listado general de temas
  ///
  /// Esto es importante para que se actualice también
  /// el contador de respuestas en la lista principal.
  ///
  /// Retorna `true` si respondió correctamente.
  /// Retorna `false` si ocurrió un error.
  Future<bool> responderTema({
    required int temaId,
    required String contenido,
  }) async {
    isReplyingTema = true;
    responderTemaErrorMessage = null;
    responderTemaResponse = null;
    notifyListeners();

    try {
      final result = await _repository.responderTema(
        temaId: temaId,
        contenido: contenido,
      );

      responderTemaResponse = result;

      if (!result.success) {
        responderTemaErrorMessage = result.message.isNotEmpty
            ? result.message
            : 'No se pudo responder el tema.';
        return false;
      }

      /// Refresca el detalle para ver la nueva respuesta.
      await fetchDetalle(temaId);

      /// Refresca la lista principal para actualizar el total de respuestas.
      await fetchTemas();

      return true;
    } on DioException catch (e) {
      final data = e.response?.data;

      if (data is Map<String, dynamic>) {
        responderTemaErrorMessage =
            data['message']?.toString() ?? 'No se pudo responder el tema.';
      } else {
        responderTemaErrorMessage = 'No se pudo responder el tema.';
      }

      return false;
    } catch (e) {
      responderTemaErrorMessage =
      'No se pudo responder el tema. Error: $e';
      return false;
    } finally {
      isReplyingTema = false;
      notifyListeners();
    }
  }
}