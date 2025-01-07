import 'package:flutter/material.dart';

class FiltrosScreen extends StatefulWidget {
  @override
  _FiltrosScreenState createState() => _FiltrosScreenState();
}

class _FiltrosScreenState extends State<FiltrosScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtros'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Nombre de usuario'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo electrónico'),
            ),
            DropdownButtonFormField<String>(
              value: _selectedRole,
              decoration: InputDecoration(labelText: 'Rol'),
              items: [
                DropdownMenuItem(value: 'admin', child: Text('Administrador')),
                DropdownMenuItem(
                    value: 'subscriber', child: Text('Suscriptor')),
                DropdownMenuItem(value: 'moderator', child: Text('Moderador')),
                DropdownMenuItem(
                    value: 'artist_manager', child: Text('Gestor de artistas')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedRole = value;
                });
              },
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                final filters = {
                  'username': _usernameController.text,
                  'email': _emailController.text,
                  'role': _selectedRole,
                };
                Navigator.pop(context, filters);
              },
              child: Text('Aplicar filtros'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
