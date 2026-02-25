// lib/main.dart
import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/workshop_list_screen.dart';
import 'screens/registration_screen.dart';

void main() {
  runApp(const TalleresApp());
}

class TalleresApp extends StatelessWidget {
  const TalleresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Semana de Talleres',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // La ruta '/' es la pantalla inicial
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),

        // --- TAREAS PARA TUS COMPAÑEROS ---
        // El Integrante 2 debe crear WorkshopListScreen() y descomentar esto:
        '/talleres': (context) => const WorkshopListScreen(),

        // El Integrante 3 debe crear RegistrationScreen() y descomentar esto:
        '/registro': (context) => const RegistrationScreen(),
      },
    );
  }
}
