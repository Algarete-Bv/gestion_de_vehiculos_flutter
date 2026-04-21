import 'package:flutter/material.dart';

/// Pantalla Acerca de.
///
/// Esta pantalla muestra informacion general del proyecto.
/// Aqui se presenta:
/// - nombre de la aplicacion
/// - version
/// - descripcion
/// - funciones principales
/// - tecnologias utilizadas
/// - integrantes del proyecto
class AcercaDeScreen extends StatelessWidget {
  const AcercaDeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Barra superior.
      appBar: AppBar(
        title: const Text('Acerca de'),
      ),

      /// Scroll principal para que toda la informacion
      /// se pueda ver aunque la pantalla sea pequeña.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Tarjeta principal del proyecto.
            ///
            /// Aqui se muestra:
            /// - icono
            /// - nombre de la app
            /// - version
            /// - descripcion general
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(.05),
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: Column(
                children: [
                  /// Icono principal decorativo.
                  Container(
                    width: 82,
                    height: 82,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.directions_car_filled,
                      size: 42,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Nombre de la aplicacion.
                  const Text(
                    'Gestión de Vehículos',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// Version actual del proyecto.
                  const Text(
                    'Versión 1.0.0',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// Descripcion general del proyecto.
                  const Text(
                    'Aplicación móvil desarrollada en Flutter para gestionar vehículos, consultar noticias automotrices, ver contenido educativo y participar en un foro comunitario.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.5,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            /// Tarjeta con funciones principales.
            _buildCard(
              icon: Icons.dashboard_customize,
              title: 'Funciones principales',
              children: const [
                _Item(text: 'Registro e inicio de sesión'),
                _Item(text: 'Perfil de usuario'),
                _Item(text: 'Mis vehículos'),
                _Item(text: 'Catálogo vehicular'),
                _Item(text: 'Noticias automotrices'),
                _Item(text: 'Videos educativos'),
                _Item(text: 'Foro comunitario'),
              ],
            ),

            const SizedBox(height: 18),

            /// Tarjeta con tecnologias utilizadas.
            _buildCard(
              icon: Icons.code,
              title: 'Tecnologías utilizadas',
              children: const [
                _Item(text: 'Flutter'),
                _Item(text: 'Dart'),
                _Item(text: 'Provider'),
                _Item(text: 'Dio'),
                _Item(text: 'REST API'),
                _Item(text: 'SharedPreferences'),
              ],
            ),

            const SizedBox(height: 18),

            /// Tarjeta con integrantes del proyecto.
            _buildCard(
              icon: Icons.people,
              title: 'Desarrollado por',
              children: const [
                _InfoRow(
                  label: 'Integrante 1',
                  value: 'Ramsés Ambiorix Arnó Rosario',
                ),
                _InfoRow(
                  label: 'Matrícula',
                  value: '20240078',
                ),

                SizedBox(height: 10),

                _InfoRow(
                  label: 'Integrante 2',
                  value: 'Geraldo Familia',
                ),
                _InfoRow(
                  label: 'Matrícula',
                  value: '20210145',
                ),

                SizedBox(height: 10),

                _InfoRow(
                  label: 'Institución',
                  value: 'Instituto Tecnológico de Las Américas (ITLA)',
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// Texto final inferior.
            Center(
              child: Text(
                'Proyecto académico 2026',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Tarjeta reutilizable.
  ///
  /// Se usa para mostrar secciones como:
  /// - funciones
  /// - tecnologias
  /// - desarrolladores
  Widget _buildCard({
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(.04),
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Encabezado de la tarjeta.
          Row(
            children: [
              Icon(icon, color: Colors.blue),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Contenido interno de la tarjeta.
          ...children,
        ],
      ),
    );
  }
}

/// Item visual tipo lista.
///
/// Se usa para mostrar elementos simples
/// como funciones o tecnologias.
class _Item extends StatelessWidget {
  final String text;

  const _Item({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle,
            size: 18,
            color: Colors.green,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}

/// Fila de informacion.
///
/// Se usa para mostrar datos como:
/// - nombre
/// - matricula
/// - institucion
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 15,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}