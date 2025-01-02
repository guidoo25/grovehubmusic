import 'package:flutter/material.dart';
import 'dart:convert';

class FormularioUsuario extends StatefulWidget {
  const FormularioUsuario({super.key});

  @override
  State<FormularioUsuario> createState() => _FormularioUsuarioState();
}

class _FormularioUsuarioState extends State<FormularioUsuario> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  String _selectedRole = 'artist';

  final List<String> _roles = [
    'artist',
    'admin',
    'moderator',
    'user',
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final userData = {
        'email': _emailController.text,
        'password': _passwordController.text,
        'username': _usernameController.text,
        'full_name': _fullNameController.text,
        'role': _selectedRole,
      };

      // Mostrar el JSON en la consola (para demostración)
      print(jsonEncode(userData));

      // Mostrar un SnackBar de éxito
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuario creado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );

      // Limpiar el formulario
      _formKey.currentState!.reset();
      _emailController.clear();
      _passwordController.clear();
      _usernameController.clear();
      _fullNameController.clear();
      setState(() {
        _selectedRole = 'artist';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF212121),
        title: const Text('Crear Nuevo Usuario'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Card(
                color: const Color(0xFF212121),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Información del Usuario',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Correo Electrónico',
                          icon: Icons.email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese un correo electrónico';
                            }
                            if (!value.contains('@')) {
                              return 'Por favor ingrese un correo electrónico válido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _passwordController,
                          label: 'Contraseña',
                          icon: Icons.lock,
                          isPassword: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese una contraseña';
                            }
                            if (value.length < 6) {
                              return 'La contraseña debe tener al menos 6 caracteres';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _usernameController,
                          label: 'Nombre de Usuario',
                          icon: Icons.person,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese un nombre de usuario';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _fullNameController,
                          label: 'Nombre Completo',
                          icon: Icons.badge,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese el nombre completo';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildDropdown(
                          label: 'Rol',
                          icon: Icons.admin_panel_settings,
                          value: _selectedRole,
                          items: _roles,
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              setState(() {
                                _selectedRole = newValue;
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: _submitForm,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Crear Usuario',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            OutlinedButton(
                              onPressed: () {
                                _formKey.currentState?.reset();
                              },
                              style: OutlinedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text('Limpiar'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: Colors.grey[400]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        filled: true,
        fillColor: Colors.grey[900],
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: Colors.grey[400]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
        ),
        filled: true,
        fillColor: Colors.grey[900],
      ),
      dropdownColor: Colors.grey[900],
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value.toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        );
      }).toList(),
    );
  }
}
