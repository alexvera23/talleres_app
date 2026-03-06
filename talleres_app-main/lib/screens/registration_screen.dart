import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  // Llave para validar el formulario
  final _formKey = GlobalKey<FormState>();

  // Variables de estado
  String? _selectedWorkshop;
  String? _selectedModality;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final List<String> _workshops = [
    'Flutter',
    'Robótica',
    'Bases de Datos',
    'Inteligencia Artificial',
    'Ciberseguridad',
  ];
  final List<String> _modalities = ['Presencial', 'Híbrida', 'En línea'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Registro exitoso para ${_nameController.text}!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) Navigator.popUntil(context, ModalRoute.withName('/'));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro de Estudiantes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Completa tus datos',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre Completo',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) => (value == null || value.isEmpty)
                    ? 'Por favor ingresa tu nombre'
                    : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Correo Institucional',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa tu correo';
                  }
                  if (!value.contains('@')) {
                    return 'Ingresa un correo válido con "@"';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Taller de interés',
                  prefixIcon: Icon(Icons.book),
                  border: OutlineInputBorder(),
                ),
                initialValue: _selectedWorkshop,
                items: _workshops
                    .map(
                      (String workshop) => DropdownMenuItem(
                        value: workshop,
                        child: Text(workshop),
                      ),
                    )
                    .toList(),
                onChanged: (newValue) =>
                    setState(() => _selectedWorkshop = newValue),
                validator: (value) =>
                    value == null ? 'Selecciona un taller' : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Modalidad preferida',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                initialValue: _selectedModality,
                items: _modalities
                    .map(
                      (String modality) => DropdownMenuItem(
                        value: modality,
                        child: Text(modality),
                      ),
                    )
                    .toList(),
                onChanged: (newValue) =>
                    setState(() => _selectedModality = newValue),
                validator: (value) =>
                    value == null ? 'Selecciona una modalidad' : null,
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Confirmar Registro',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
