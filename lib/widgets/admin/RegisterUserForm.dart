import 'package:flutter/material.dart';
import 'package:grovehubmusic/services/services_auth.dart';

class RegisterUserForm extends StatefulWidget {
  final Function onUserAdded;

  const RegisterUserForm({Key? key, required this.onUserAdded})
      : super(key: key);

  @override
  _RegisterUserFormState createState() => _RegisterUserFormState();
}

class _RegisterUserFormState extends State<RegisterUserForm> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _authService = ApiService(); // Initialize your auth service

  String _email = '';
  String _password = '';
  String _username = '';
  String _fullName = '';
  String _role = 'listener';

  final List<String> _roles = ['admin', 'artist', 'listener', 'moderator'];

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        await _authService.register(
            _email, _password, _username, _fullName, _role);
        widget.onUserAdded();
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registrar nuevo usuario'),
        backgroundColor: Color(0xFF212121),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter an email' : null,
                  onSaved: (value) => _email = value!,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a password' : null,
                  onSaved: (value) => _password = value!,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a username' : null,
                  onSaved: (value) => _username = value!,
                ),
                SizedBox(height: 16),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nombre completo',
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  style: TextStyle(color: Colors.white),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter full name' : null,
                  onSaved: (value) => _fullName = value!,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Role',
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  style: TextStyle(color: Colors.white),
                  dropdownColor: Colors.grey[800],
                  value: _role,
                  items: _roles.map((String role) {
                    return DropdownMenuItem<String>(
                      value: role,
                      child: Text(role),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _role = newValue!;
                    });
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Regitrar'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
