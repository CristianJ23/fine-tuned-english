import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // <-- IMPORT
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuarios.dart';
import '../models/representative.dart';
import '../services/auth_service.dart';
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
  final _idNumberController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  DateTime? _selectedBirthDate;

  bool _isChecked = false;
  final RepresentativeService _repService = RepresentativeService();
  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _idNumberController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    super.dispose();
  }
  
  void _clearForm() {
    _firstNameController.clear();
    _lastNameController.clear();
    _emailController.clear();
    _idNumberController.clear();
    _phoneController.clear();
    _birthDateController.clear();
    setState(() => _selectedBirthDate = null);
  }
  
  void _onCheckboxChanged(bool? value) {
    setState(() => _isChecked = value ?? false);

    if (_isChecked) {
      final Usuarios? currentUser = AuthService.currentUser;
      if (currentUser != null) {
        setState(() {
          _firstNameController.text = currentUser.nombres;
          _lastNameController.text = currentUser.apellidos;
          _emailController.text = currentUser.email;
          _idNumberController.text = currentUser.numeroCedula;
          _phoneController.text = currentUser.telefono;
          _selectedBirthDate = currentUser.fechaNacimiento;
          _birthDateController.text = DateFormat.yMd(context.locale.toString()).format(currentUser.fechaNacimiento);
        });
      }
    } else {
      _clearForm();
    }
  }

    Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; });
    
    try {
      final representativeData = Representative(
        id: '',
        nombres: _firstNameController.text.trim(),
        apellidos: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        numeroCedula: _idNumberController.text.trim(),
        telefono: _phoneController.text.trim(),
        fechaNacimiento: _selectedBirthDate!,
      );

      final representativeId = await _repService.findOrCreateRepresentative(representativeData);
      
      final studentId = AuthService.currentUser?.id;
      if (studentId != null) {
        await _repService.linkStudentToRepresentative(
            studentId: studentId, 
            representativeId: representativeId
        );
      }
      
      if(mounted) {
        // <-- CORRECCIÓN
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('pages.payment.dataSavedSuccessfully'.tr()), backgroundColor: Colors.green));
        Navigator.pop(context, true);
      }

    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() { _isLoading = false; });
    }
  }


  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      // Para que el calendario también se muestre en el idioma correcto
      locale: context.locale, 
    );
    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
        // Usar DateFormat para mostrar la fecha en el formato local
        _birthDateController.text = DateFormat.yMd(context.locale.toString()).format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // <-- CORRECCIÓN
        title: Text('pages.representative.title'.tr(), style: const TextStyle(color: Colors.white)),
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildRepresentativeSelector(),
                    const SizedBox(height: 24),
                    // <-- CORRECCIÓN
                    Text('pages.representative.pleaseFillData'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    // <-- CORRECCIONES EN TODOS LOS CAMPOS
                    TextFormField(controller: _firstNameController, decoration: InputDecoration(labelText: 'common.names'.tr()), validator: (v) => v!.isEmpty ? 'validators.requiredField'.tr() : null),
                    const SizedBox(height: 16),
                    TextFormField(controller: _lastNameController, decoration: InputDecoration(labelText: 'common.lastNames'.tr()), validator: (v) => v!.isEmpty ? 'validators.requiredField'.tr() : null),
                    const SizedBox(height: 16),
                    TextFormField(controller: _emailController, decoration: InputDecoration(labelText: 'common.email'.tr()), keyboardType: TextInputType.emailAddress, validator: (v) => v!.isEmpty || !v.contains('@') ? 'validators.invalidEmail'.tr() : null),
                    const SizedBox(height: 16),
                    TextFormField(controller: _idNumberController, decoration: InputDecoration(labelText: 'common.idNumber'.tr()), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? 'validators.requiredField'.tr() : null),
                    const SizedBox(height: 16),
                    TextFormField(controller: _phoneController, decoration: InputDecoration(labelText: 'common.phoneNumber'.tr()), keyboardType: TextInputType.phone, validator: (v) => v!.isEmpty ? 'validators.requiredField'.tr() : null),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _selectDate,
                      child: AbsorbPointer(
                        child: TextFormField(controller: _birthDateController, decoration: InputDecoration(labelText: 'common.birthDate'.tr(), suffixIcon: const Icon(Icons.calendar_today)), validator: (v) => v!.isEmpty ? 'validators.selectADate'.tr() : null),
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF213354), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 14)),
                      onPressed: _submitForm,
                      // <-- CORRECCIÓN
                      child: Text('pages.representative.saveInformation'.tr()),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.amber[100], borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        // <-- CORRECCIÓN
        Text('pages.representative.isOwnRepresentative'.tr(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF213354)), textAlign: TextAlign.center),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          // <-- CORRECCIÓN
          Text('pages.representative.ifSoCheckHere'.tr(), style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Checkbox(value: _isChecked, activeColor: Colors.orange, onChanged: _onCheckboxChanged),
        ]),
      ]),
    );
  }
}