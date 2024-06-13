import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_tesis/main.dart';
import 'package:proyecto_tesis/services/sreems/emergency_contacts_service.dart';
import '../../models/screems/emergency_contacts_model.dart';

class EditContactModal extends StatefulWidget {
  final Map<String, dynamic> contact;

  EditContactModal({required this.contact});

  @override
  _EditContactModalState createState() => _EditContactModalState();
}

class _EditContactModalState extends State<EditContactModal> {
  late TextEditingController _fullnameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _relationshipController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _fullnameController = TextEditingController(text: widget.contact['fullname']);
    _phoneNumberController = TextEditingController(text: widget.contact['phonenumber']);
    _relationshipController = TextEditingController(text: widget.contact['relationship']);
  }

  Future<void> _loadToken() async{
    String? storedToken = await authBloc.getStoraredToken();
    setState(() {
      token = storedToken;
    });
  }

  String _removeAccents(String text) {
    final Map<String, String> accentMap = {
      'á': 'a', 'Á': 'A',
      'é': 'e', 'É': 'E',
      'í': 'i', 'Í': 'I',
      'ó': 'o', 'Ó': 'O',
      'ú': 'u', 'Ú': 'U',
      'à': 'a', 'À': 'A',
      'è': 'e', 'È': 'E',
      'ì': 'i', 'Ì': 'I',
      'ò': 'o', 'Ò': 'O',
      'ù': 'u', 'Ù': 'U',
      'ä': 'a', 'Ä': 'A',
      'ë': 'e', 'Ë': 'E',
      'ï': 'i', 'Ï': 'I',
      'ö': 'o', 'Ö': 'O',
      'ü': 'u', 'Ü': 'U',
    };

    return text.replaceAllMapped(RegExp('[${accentMap.keys.join()}]'), (match) => accentMap[match.group(0)]!);
  }

  String _accentuateCharacters(String text) {
    // Elimina los caracteres especiales y permite solo letras, espacios y dígitos
    String cleanText = _removeAccents(text); // Elimina los acentos primero
    return cleanText.replaceAll(RegExp(r'[^\w\s]'), '');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar Contacto de Emergencia',
        style: TextStyle(
            fontSize: 15.0,
            color: Colors.black,
            fontWeight: FontWeight.bold)
        ,
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _fullnameController,
              decoration: InputDecoration(labelText: 'Nombre completo', labelStyle: TextStyle(fontSize: 18.0),),
              style: TextStyle(fontSize: 14.0),
              keyboardType: TextInputType.text,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese un nombre';
                }
                final RegExp letterRegex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜ\s]+$');
                if (!letterRegex.hasMatch(value)) {
                  return 'Solo se permiten letras y espacios, sin caracteres especiales ni números';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Número de teléfono', labelStyle: TextStyle(fontSize: 18.0),),
              style: TextStyle(fontSize: 14.0),
              keyboardType: TextInputType.phone,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese un número telefónico';
                }
                // Verifica si el valor ingresado coincide con el formato esperado.
                final RegExp phoneRegex = RegExp(r'^\+51[0-9]{9}$');
                if (!phoneRegex.hasMatch(value)) {
                  return 'Formato correcto +51 más 9 díjitos.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _relationshipController,
              decoration: InputDecoration(labelText: 'Relación',labelStyle: TextStyle(fontSize: 18.0),),
              style: TextStyle(fontSize: 14.0),
              keyboardType: TextInputType.text,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese la relación familiar';
                }
                final RegExp letterRegex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚüÜ\s]+$');
                if (!letterRegex.hasMatch(value)) {
                  return 'Solo se permiten letras y espacios, sin caracteres especiales ni números';
                }
                return null;
              },
            ),
          ],
        ),
      )
      ),
      actions: <Widget>[

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el modal sin guardar cambios
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Verifica la validez del formulario antes de intentar guardar
                if (_formKey.currentState?.validate() ?? false) {
                  // El formulario es válido, procede a actualizar el contacto
                  _updateContact();
                } else {
                  // El formulario no es válido, muestra un mensaje de advertencia
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Por favor, complete el formulario correctamente.'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: Text('Guardar'),
            )

          ],
        )
      ],
    );
  }

  void _updateContact() async {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      // Obtén los nuevos valores de los campos
      String fullname = _accentuateCharacters(_fullnameController.text);
      String phoneNumber = _phoneNumberController.text;
      String relationship = _accentuateCharacters(_relationshipController.text);

      // Imprime los datos que estás enviando al servicio de actualización
      print('Datos a enviar para actualizar:');
      print('Nombre completo: $fullname');
      print('Número de teléfono: $phoneNumber');
      print('Relación: $relationship');

      // Llama al servicio de actualización
      try {
        print('Datos a enviar para actualizar en el try:');
        print('Nombre completo: $fullname');
        print('Número de teléfono: $phoneNumber');
        print('Relación: $relationship');
        print("Id del contacto: ${widget.contact['id']}");
        print("Token: $token");
        final updatedContact = await updateEmergencyContacts(
          EmergencyContacts(
            fullname: fullname,
            phonenumber: phoneNumber,
            relationship: relationship,
          ),
          token,
          widget.contact['id'],
        );

        Navigator.of(context).pop(updatedContact);
      } catch (e) {
        print('Error al actualizar el contacto: $e');
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, complete el formulario correctamente.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _phoneNumberController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }
}