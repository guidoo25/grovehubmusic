import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grovehubmusic/cubit/cloudinary.dart';

class SongInfoForm extends StatefulWidget {
  @override
  _SongInfoFormState createState() => _SongInfoFormState();
}

class _SongInfoFormState extends State<SongInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _promptController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Título'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese un título';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(labelText: 'Descripción'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese una descripción';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _genreController,
            decoration: InputDecoration(labelText: 'Género'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese un género';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _promptController,
            decoration: InputDecoration(labelText: 'Prompt para la imagen'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingrese un prompt para la imagen';
              }
              return null;
            },
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Aquí iría la lógica para actualizar la información de la canción
                // Por ahora, solo actualizaremos la imagen con el prompt
                context
                    .read<ImagePromptCubit>()
                    .setPromptForImage(_promptController.text);
              }
            },
            child: Text('Actualizar información'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _genreController.dispose();
    _promptController.dispose();
    super.dispose();
  }
}
