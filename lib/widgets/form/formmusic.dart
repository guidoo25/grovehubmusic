import 'package:flutter/material.dart';

class FormularioDinamico extends StatefulWidget {
  final List<Map<String, dynamic>> campos;

  const FormularioDinamico({super.key, required this.campos});

  @override
  State<FormularioDinamico> createState() => _FormularioDinamicoState();
}

class _FormularioDinamicoState extends State<FormularioDinamico> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> _formData = {};

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...widget.campos.map((campo) => _buildCampo(campo)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _enviarFormulario,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: const Text('Subir Contenido'),
          ),
        ],
      ),
    );
  }

  Widget _buildCampo(Map<String, dynamic> campo) {
    switch (campo['tipo']) {
      case 'texto':
        return _buildCampoTexto(campo);
      case 'numero':
        return _buildCampoNumero(campo);
      case 'seleccion':
        return _buildCampoSeleccion(campo);
      case 'fecha':
        return _buildCampoFecha(campo);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCampoTexto(Map<String, dynamic> campo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: campo['etiqueta'],
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (campo['requerido'] && (value == null || value.isEmpty)) {
            return 'Este campo es requerido';
          }
          return null;
        },
        onSaved: (value) => _formData[campo['nombre']] = value,
      ),
    );
  }

  Widget _buildCampoNumero(Map<String, dynamic> campo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: campo['etiqueta'],
          border: const OutlineInputBorder(),
        ),
        keyboardType: TextInputType.number,
        validator: (value) {
          if (campo['requerido'] && (value == null || value.isEmpty)) {
            return 'Este campo es requerido';
          }
          if (value != null && int.tryParse(value) == null) {
            return 'Ingrese un número válido';
          }
          return null;
        },
        onSaved: (value) =>
            _formData[campo['nombre']] = int.tryParse(value ?? ''),
      ),
    );
  }

  Widget _buildCampoSeleccion(Map<String, dynamic> campo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: campo['etiqueta'],
          border: const OutlineInputBorder(),
        ),
        items: (campo['opciones'] as List<String>).map((opcion) {
          return DropdownMenuItem(
            value: opcion,
            child: Text(opcion),
          );
        }).toList(),
        validator: (value) {
          if (campo['requerido'] && (value == null || value.isEmpty)) {
            return 'Este campo es requerido';
          }
          return null;
        },
        onChanged: (value) => _formData[campo['nombre']] = value,
        onSaved: (value) => _formData[campo['nombre']] = value,
      ),
    );
  }

  Widget _buildCampoFecha(Map<String, dynamic> campo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: campo['etiqueta'],
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        readOnly: true,
        onTap: () async {
          final fecha = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime(2100),
          );
          if (fecha != null) {
            _formData[campo['nombre']] = fecha.toIso8601String();
            setState(() {});
          }
        },
        validator: (value) {
          if (campo['requerido'] && (value == null || value.isEmpty)) {
            return 'Este campo es requerido';
          }
          return null;
        },
      ),
    );
  }

  void _enviarFormulario() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Aquí puedes manejar el envío del formulario
      print(_formData);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Formulario enviado con éxito')),
      );
    }
  }
}
