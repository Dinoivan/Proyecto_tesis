import 'package:flutter/material.dart';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _fullnameController,
              decoration: InputDecoration(labelText: 'Nombre completo'),
            ),
            TextFormField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Número de teléfono'),
            ),
            TextFormField(
              controller: _relationshipController,
              decoration: InputDecoration(labelText: 'Relación'),
            ),
          ],
        ),
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
                // Guarda los cambios y llama al servicio para actualizar el contacto
                _updateContact();
              },
              child: Text('Guardar'),
            ),

          ],
        )
      ],
    );
  }

  void _updateContact() async {
    // Obtén los nuevos valores de los campos
    String fullname = _fullnameController.text;
    String phoneNumber = _phoneNumberController.text;
    String relationship = _relationshipController.text;

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
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _phoneNumberController.dispose();
    _relationshipController.dispose();
    super.dispose();
  }
}