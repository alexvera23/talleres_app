import 'package:flutter/material.dart';

import '../models/registration_model.dart';
import '../services/database_service.dart';

class RegisteredUsersScreen extends StatefulWidget {
  const RegisteredUsersScreen({super.key});

  @override
  State<RegisteredUsersScreen> createState() => _RegisteredUsersScreenState();
}

class _RegisteredUsersScreenState extends State<RegisteredUsersScreen> {
  late Future<List<Registration>> _registrationsFuture;

  @override
  void initState() {
    super.initState();
    _registrationsFuture = DatabaseService.instance.getRegistrations();
  }

  Future<void> _refresh() async {
    setState(() {
      _registrationsFuture = DatabaseService.instance.getRegistrations();
    });
    await _registrationsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios Registrados'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder<List<Registration>>(
        future: _registrationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'No se pudieron cargar los usuarios registrados.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final registrations = snapshot.data ?? [];
          if (registrations.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                children: const [
                  SizedBox(height: 180),
                  Icon(Icons.group_off, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Aún no hay usuarios registrados.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: registrations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final registration = registrations[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${registration.id ?? index + 1}'),
                    ),
                    title: Text(registration.name),
                    subtitle: Text(
                      '${registration.email}\n'
                      'Talleres: ${registration.workshops}\n'
                      'Modalidad: ${registration.modality}',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
