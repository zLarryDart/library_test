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
      await prefs.setString('password', _password); // Guardamos la contraseña
      await prefs.setString(
          'birthDate',
          _birthDate!
              .toIso8601String()); // Guardamos la fecha en formato ISO 8601
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
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "First Name"),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                    return 'Please enter a valid first name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _firstName = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Last Name"),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
                    return 'Please enter a valid last name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _lastName = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Phone"),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _phone = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (value) {
                  _password = value!;
                },
              ),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Birth Date",
                  hintText: _birthDate == null
                      ? 'Select your birth date'
                      : DateFormat('yyyy-MM-dd').format(_birthDate!),
                ),
                onTap: () {
                  _selectBirthDate(context);
                },
                validator: (value) {
                  if (_birthDate == null) {
                    return 'Please select your birth date';
                  }
                  return null;
                },
              ),
              TextFormField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: "Age",
                  hintText: _age?.toString() ?? '',
                ),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: "Gender"),
                items: ['Male', 'Female', 'Other'].map((String gender) {
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
                    return 'Please select a gender';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveForm,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
