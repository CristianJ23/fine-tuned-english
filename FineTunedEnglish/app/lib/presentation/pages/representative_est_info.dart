// ✅ RepresentativeFormPage actualizado para guardar en Firestore y manejar el rol "representante"

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/usuarios.dart';
import '../widgets/shared_footer.dart';

class RepresentativeFormPage extends StatefulWidget {
  const RepresentativeFormPage({super.key});

  @override
  State<RepresentativeFormPage> createState() => _RepresentativeFormPageState();
}

class _RepresentativeFormPageState extends State<RepresentativeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _idNumberController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  String? _selectedEducation;
  DateTime? _selectedBirthDate;

  bool _isChecked = false;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  void _onCheckboxChanged(bool? value) async {
    setState(() => _isChecked = value ?? false);
    if (_isChecked) {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('usuarios').doc(user.uid).get();
        if (doc.exists) {
          final usuario = Usuarios.fromFirestore(doc);
          setState(() {
            _firstNameController.text = usuario.nombres;
            _lastNameController.text = usuario.apellidos;
            _emailController.text = usuario.email;
            _idNumberController.text = usuario.numeroCedula;
            _phoneController.text = usuario.telefono;
            _selectedBirthDate = usuario.fechaNacimiento;
            _birthDateController.text =
            "\${usuario.fechaNacimiento.day}/\${usuario.fechaNacimiento.month}/\${usuario.fechaNacimiento.year}";
            _selectedEducation = usuario.nivelEducacion;
          });
        }
      }
    } else {
      setState(() {
        _firstNameController.clear();
        _lastNameController.clear();
        _emailController.clear();
        _idNumberController.clear();
        _phoneController.clear();
        _birthDateController.clear();
        _selectedEducation = null;
        _selectedBirthDate = null;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final user = _auth.currentUser;
    if (user == null) return;

    final nuevoUsuario = Usuarios(
      id: user.uid,
      email: _emailController.text.trim(),
      password: '',
      nombres: _firstNameController.text.trim(),
      apellidos: _lastNameController.text.trim(),
      numeroCedula: _idNumberController.text.trim(),
      telefono: _phoneController.text.trim(),
      fechaNacimiento: _selectedBirthDate ?? DateTime.now(),
      rol: 'representante',
      nivelEducacion: _selectedEducation,
      representanteId: null,
    );

    await _firestore.collection('usuarios').doc(user.uid).set(nuevoUsuario.toJson());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Información guardada correctamente')),
    );

    Navigator.pop(context);
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
        _birthDateController.text = "\${picked.day}/\${picked.month}/\${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos del Representante', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF213354),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildRepresentativeSelector(),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(labelText: 'Nombres'),
                      validator: (value) => value == null || value.isEmpty ? 'Este campo es requerido' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(labelText: 'Apellidos'),
                      validator: (value) => value == null || value.isEmpty ? 'Este campo es requerido' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(labelText: 'Correo electrónico'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) => value == null || !value.contains('@') ? 'Correo inválido' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _idNumberController,
                      decoration: const InputDecoration(labelText: 'Número de cédula'),
                      keyboardType: TextInputType.number,
                      validator: (value) => value == null || value.isEmpty ? 'Este campo es requerido' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(labelText: 'Número de celular'),
                      keyboardType: TextInputType.phone,
                      validator: (value) => value == null || value.isEmpty ? 'Este campo es requerido' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedEducation,
                      decoration: const InputDecoration(labelText: 'Nivel de educación'),
                      items: const [
                        DropdownMenuItem(value: 'Primaria', child: Text('Primaria')),
                        DropdownMenuItem(value: 'Secundaria', child: Text('Secundaria')),
                        DropdownMenuItem(value: 'Bachillerato', child: Text('Bachillerato')),
                        DropdownMenuItem(value: 'Universitaria', child: Text('Universitaria')),
                        DropdownMenuItem(value: 'Postgrado', child: Text('Postgrado')),
                      ],
                      onChanged: (value) => setState(() => _selectedEducation = value),
                      validator: (value) => value == null ? 'Seleccione un nivel' : null,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _selectDate,
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _birthDateController,
                          decoration: const InputDecoration(
                            labelText: 'Fecha de nacimiento',
                            suffixIcon: Icon(Icons.calendar_today),
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Seleccione una fecha' : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Guardar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SharedFooter(),
        ],
      ),
    );
  }

  Widget _buildRepresentativeSelector() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black87, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            '¿Te representas a ti mismo?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF213354)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Si es así, marca aquí:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(width: 12),
              Checkbox(
                value: _isChecked,
                activeColor: Colors.orange,
                onChanged: _onCheckboxChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
