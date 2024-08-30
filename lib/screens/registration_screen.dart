import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  String _phone = '';
  String _email = '';
  String _password = '';
  DateTime? _birthDate;
  int? _age;
  String? _gender;

  void _calculateAge() {
    if (_birthDate != null) {
      final now = DateTime.now();
      _age = now.year - _birthDate!.year;
      if (now.month < _birthDate!.month ||
          (now.month == _birthDate!.month && now.day < _birthDate!.day)) {
        _age = _age! - 1;
      }
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', _firstName);
      await prefs.setString('lastName', _lastName);
      await prefs.setString('phone', _phone);
      await prefs.setString('email', _email);
      await prefs.setString('password', _password);
      await prefs.setString('birthDate', _birthDate!.toIso8601String());
      await prefs.setInt('age', _age!);
      await prefs.setString('gender', _gender!);
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _birthDate) {
      setState(() {
        _birthDate = pickedDate;
        _calculateAge();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registro")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextFormField(
                label: "Nombre",
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                    return 'Por favor, ingrese un nombre válido';
                  }
                  return null;
                },
                onSaved: (value) => _firstName = value!,
              ),
              _buildTextFormField(
                label: "Apellido",
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                    return 'Por favor, ingrese un apellido válido';
                  }
                  return null;
                },
                onSaved: (value) => _lastName = value!,
              ),
              _buildTextFormField(
                label: "Teléfono",
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Por favor, ingrese un número de teléfono válido';
                  }
                  return null;
                },
                onSaved: (value) => _phone = value!,
              ),
              _buildTextFormField(
                label: "Correo electrónico",
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                    return 'Por favor, ingrese un correo electrónico válido';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ),
              _buildTextFormField(
                label: "Contraseña",
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su contraseña';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ),
              _buildBirthDateField(context),
              _buildDisabledTextFormField(
                label: "Edad",
                hintText: _age?.toString() ?? '',
              ),
              _buildGenderField(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required String label,
    required FormFieldValidator<String> validator,
    required FormFieldSetter<String> onSaved,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        validator: validator,
        onSaved: onSaved,
      ),
    );
  }

  Widget _buildBirthDateField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: "Fecha de nacimiento",
          hintText: _birthDate == null
              ? 'Seleccione su fecha de nacimiento'
              : DateFormat('yyyy-MM-dd').format(_birthDate!),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onTap: () => _selectBirthDate(context),
        validator: (value) {
          if (_birthDate == null) {
            return 'Por favor, seleccione su fecha de nacimiento';
          }
          return null;
        },
        controller: TextEditingController(
          text: _birthDate != null
              ? DateFormat('yyyy-MM-dd').format(_birthDate!)
              : '',
        ),
      ),
    );
  }

  Widget _buildDisabledTextFormField({
    required String label,
    required String hintText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        enabled: false,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: "Género",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        items: ['Masculino', 'Femenino', 'Otro'].map((String gender) {
          return DropdownMenuItem<String>(
            value: gender,
            child: Text(gender),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _gender = value;
          });
        },
        validator: (value) {
          if (value == null) {
            return 'Por favor, seleccione un género';
          }
          return null;
        },
      ),
    );
  }
}
