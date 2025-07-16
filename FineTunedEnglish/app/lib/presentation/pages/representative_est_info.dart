import 'package:flutter/material.dart';
import '../services/representative_service.dart';
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
  final _idNumbreController = TextEditingController();
  final _phoneController = TextEditingController();
  final _educationLevelController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _dateController = TextEditingController();

  final RepresentativeService _representativeService = RepresentativeService();

  bool _isChecked = false;
  String? _selectedEducation;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _idNumbreController.dispose();
    _phoneController.dispose();
    _educationLevelController.dispose();
    _birthDateController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _onCheckboxChanged(bool? value) async {
    setState(() {
      _isChecked = value ?? false;
    });

    if (_isChecked) {
      final representative = await _representativeService.getCurrentRepresentative();
      setState(() {
        _firstNameController.text = representative.firstName;
        _lastNameController.text = representative.lastName;
        _emailController.text = representative.email;
        _idNumbreController.text = representative.idNumber;
        _phoneController.text = representative.phone;
        _selectedEducation = representative.educationLevel;
        _birthDateController.text = representative.birthDate != null
            ? '${representative.birthDate!.day}/${representative.birthDate!.month}/${representative.birthDate!.year}'
            : '';
      });
    } else {
      setState(() {
        _firstNameController.clear();
        _lastNameController.clear();
        _emailController.clear();
        _idNumbreController.clear();
        _phoneController.clear();
        _selectedEducation = null;
        _birthDateController.clear();
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Formulario enviado')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.amber[700]!,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
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
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF213354),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Si es así, marca aquí:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(width: 12),
              Theme(
                data: Theme.of(context).copyWith(
                  unselectedWidgetColor: Colors.black,
                ),
                child: Checkbox(
                  value: _isChecked,
                  activeColor: Colors.orange,
                  checkColor: Colors.white,
                  onChanged: _onCheckboxChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
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
                child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildRepresentativeSelector(),
                    const SizedBox(height: 20),
                    const Text('Por favor, completa los datos:', style: TextStyle(fontSize: 18)),
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
                      controller: _idNumbreController,
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
                      decoration: InputDecoration(
                        labelText: 'Nivel de educación',
                        filled: true,
                        fillColor: Colors.amber[50],
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
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
                          readOnly: true,
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
                      child: const Text('Enviar'),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
                ),
              ),
            ),
          ),
          const SharedFooter(),
        ],
      ),
    );
  }
}
