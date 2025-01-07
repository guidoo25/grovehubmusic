import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:grovehubmusic/config/enviroments.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _username = '';
  String _fullName = '';
  String _role = 'listener';
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      try {
        final response = await http.post(
          Uri.parse('${Enviroments.apiUrl}/register'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'email': _email,
            'password': _password,
            'username': _username,
            'full_name': _fullName,
            'role': _role,
          }),
        );

        final responseData = json.decode(response.body);

        if (responseData['success']) {
          // Registration successful, navigate to next screen or show success message
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/home');
          }
        } else {
          setState(() {
            _errorMessage = responseData['message'];
          });
        }
      } catch (error) {
        setState(() {
          _errorMessage = 'An error occurred. Please try again.';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Crea tu cuenta en GroveHub',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      decoration: _inputDecoration('Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      onSaved: (value) => _email = value!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: _inputDecoration('Username'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                      onSaved: (value) => _username = value!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: _inputDecoration('Full Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                      onSaved: (value) => _fullName = value!,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: _inputDecoration('Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        return null;
                      },
                      onSaved: (value) => _password = value!,
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Choose your role:',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _roleButton('Fan', 'listener'),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _roleButton('Artista', 'artist'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Registrarse',
                              style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 255, 35, 207),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        // Navigate to login screen
                        GoRouter.of(context).go('/login');
                      },
                      child: const Text(
                        'Tienes cuenta ya ? Ingresa',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white30),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green),
      ),
      errorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      filled: true,
      fillColor: Colors.white10,
    );
  }

  Widget _roleButton(String label, String value) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _role = value;
        });
      },
      child: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: _role == value
            ? const Color.fromARGB(255, 255, 35, 207)
            : Colors.grey,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}
