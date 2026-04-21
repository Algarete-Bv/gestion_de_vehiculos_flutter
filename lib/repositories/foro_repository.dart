import '../models/foro/crear_tema_response.dart';
import '../models/foro/foro_detalle_model.dart';
import '../models/foro/foro_tema_model.dart';
import '../models/foro/responder_tema_response.dart';
import '../services/foro_service.dart';

/// Repositorio encargado del módulo de foro.
///
/// Este archivo conecta la aplicación con el servicio del foro.
///
/// Su función principal es organizar las operaciones relacionadas con:
/// - ver temas publicados
/// - ver detalle de un tema
/// - crear nuevos temas
/// - responder temas existentes
///
/// De esta manera, el provider trabaja con este repositorio
/// y no directamente con la API.
class ForoRepository {
  /// Servicio que realiza las peticiones del foro.
  final ForoService _service;

  /// Constructor principal.
  ForoRepository(this._service);

  /// Obtiene la lista general de temas del foro.
  ///
  /// Retorna todos los temas disponibles
  /// para mostrarlos en pantalla.
  Future<List<ForoTemaModel>> getTemas() {
    return _service.getTemas();
  }

  /// Obtiene el detalle de un tema específico.
  ///
  /// Recibe el ID del tema y devuelve:
  /// - título
  /// - descripción
  /// - autor
  /// - respuestas
  /// - fecha
  Future<ForoDetalleModel> getDetalle(int id) {
    return _service.getDetalle(id);
  }

  /// Crea un nuevo tema en el foro.
  ///
  /// Requiere:
  /// - vehículo relacionado
  /// - título
  /// - descripción
  ///
  /// Retorna la respuesta del servidor.
  Future<CrearTemaResponse> crearTema({
    required int vehiculoId,
    required String titulo,
    required String descripcion,
  }) {
    return _service.crearTema(
      vehiculoId: vehiculoId,
      titulo: titulo,
      descripcion: descripcion,
    );
  }

  /// Envía una respuesta a un tema existente.
  ///
  /// Requiere:
  /// - ID del tema
  /// - contenido de la respuesta
  ///
  /// Retorna la respuesta del servidor.
  Future<ResponderTemaResponse> responderTema({
    required int temaId,
    required String contenido,
  }) {
    return _service.responderTema(
      temaId: temaId,
      contenido: contenido,
    );
  }
}