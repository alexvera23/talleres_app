// lib/screens/workshop_list_screen.dart
import 'package:flutter/material.dart';
import '../models/workshop_model.dart'; // Importar el modelo creado por el Integrante 1

class WorkshopListScreen extends StatelessWidget {
  const WorkshopListScreen({super.key});

  // Mock Data: Datos simulados para probar la tabla
  List<Workshop> get mockWorkshops => [
    Workshop(
      id: '1',
      title: 'Introducción a Flutter',
      modality: 'En Línea',
      date: 'Lunes 10:00 AM',
    ),
    Workshop(
      id: '2',
      title: 'Robótica con Arduino',
      modality: 'Presencial',
      date: 'Martes 12:00 PM',
    ),
    Workshop(
      id: '3',
      title: 'Bases de Datos en la Nube',
      modality: 'Híbrida',
      date: 'Miércoles 09:00 AM',
    ),
    Workshop(
      id: '4',
      title: 'Inteligencia Artificial 101',
      modality: 'En Línea',
      date: 'Jueves 04:00 PM',
    ),
    Workshop(
      id: '5',
      title: 'Ciberseguridad Básica',
      modality: 'Presencial',
      date: 'Viernes 11:00 AM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Talleres'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Talleres Disponibles',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Tabla de datos
            Card(
              elevation: 4,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Taller',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Modalidad',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Fecha',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                  rows: mockWorkshops
                      .map(
                        (workshop) => DataRow(
                          cells: [
                            DataCell(Text(workshop.title)),
                            DataCell(
                              Chip(
                                label: Text(
                                  workshop.modality,
                                  style: const TextStyle(fontSize: 12),
                                ),
                                backgroundColor: _getModalityColor(
                                  workshop.modality,
                                ),
                              ),
                            ),
                            DataCell(Text(workshop.date)),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navega al formulario (que hará el Integrante 3)
                Navigator.pushNamed(context, '/registro');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Ir al Formulario de Registro',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Método auxiliar para colores de los Chips
  Color _getModalityColor(String modality) {
    switch (modality) {
      case 'Presencial':
        return Colors.green.shade100;
      case 'En Línea':
        return Colors.blue.shade100;
      case 'Híbrida':
        return Colors.orange.shade100;
      default:
        return Colors.grey.shade100;
    }
  }
}
