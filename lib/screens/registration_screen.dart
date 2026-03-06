import 'package:flutter/material.dart';

import '../models/registration_model.dart';
import '../services/database_service.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<String> _selectedWorkshops = [];
  String? _selectedModality;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final RegExp _nameRegex = RegExp(r"^[A-Za-zÁÉÍÓÚáéíóúÑñ'\- ]{3,60}$");
  final RegExp _emailRegex = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  final List<String> _workshops = [
    'Flutter',
    'Robótica',
    'Bases de Datos',
    'Inteligencia Artificial',
    'Ciberseguridad',
  ];
  final List<String> _modalities = ['Presencial', 'Híbrida', 'En línea'];

  bool _isSaving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_selectedWorkshops.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona al menos un taller'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    final registration = Registration(
      name: _nameController.text.trim(),
      email: _emailController.text.trim().toLowerCase(),
      workshops: _selectedWorkshops.join(', '),
      modality: _selectedModality!,
    );

    try {
      await DatabaseService.instance.insertRegistration(registration);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '¡Registro exitoso para ${_nameController.text.trim()}! (${_selectedWorkshops.length} talleres)',
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      _formKey.currentState?.reset();
      _nameController.clear();
      _emailController.clear();
      setState(() {
        _selectedWorkshops.clear();
        _selectedModality = null;
      });
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
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
                validator: (value) {
                  final sanitized = value?.trim() ?? '';
                  if (sanitized.isEmpty) {
                    return 'Por favor ingresa tu nombre';
                  }
                  if (!_nameRegex.hasMatch(sanitized)) {
                    return 'Solo letras, espacios, guiones y apóstrofes (3-60)';
                  }
                  return null;
                },
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
                  final sanitized = value?.trim() ?? '';
                  if (sanitized.isEmpty) {
                    return 'Por favor ingresa tu correo';
                  }
                  if (!_emailRegex.hasMatch(sanitized)) {
                    return 'Ingresa un correo válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Selecciona los talleres de interés:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Column(
                  children: _workshops.map((workshop) {
                    return CheckboxListTile(
                      title: Text(workshop),
                      value: _selectedWorkshops.contains(workshop),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked == true) {
                            _selectedWorkshops.add(workshop);
                          } else {
                            _selectedWorkshops.remove(workshop);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Modalidad preferida',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                value: _selectedModality,
                items: _modalities
                    .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                    .toList(),
                onChanged: (newValue) =>
                    setState(() => _selectedModality = newValue),
                validator: (value) =>
                    value == null ? 'Selecciona una modalidad' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSaving ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: Text(
                  _isSaving ? 'Guardando...' : 'Confirmar Registro',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
