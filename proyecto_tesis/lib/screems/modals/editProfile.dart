import 'package:flutter/material.dart';
import 'package:proyecto_tesis/main.dart';
import 'package:proyecto_tesis/models/register/register_model.dart';
import 'package:proyecto_tesis/services/sreems/citizen_service.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:intl/intl.dart';


class EditCitizenModal extends StatefulWidget {
  final CitizenUpdate citizen;

  EditCitizenModal({required this.citizen});

  @override
  _EditCitizenModalState createState() => _EditCitizenModalState();
}

class _EditCitizenModalState extends State<EditCitizenModal> {
  late TextEditingController _birthdayDateController;
  late TextEditingController _emailController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;

  String? token;
  int? userId;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _birthdayDateController = TextEditingController(text: widget.citizen.birthdayDate);
    _emailController = TextEditingController(text: widget.citizen.email);
    _firstNameController = TextEditingController(text: widget.citizen.firstname);
    _lastNameController = TextEditingController(text: widget.citizen.lastname);
  }

  Future<void> _loadToken() async{
    String? storedToken = await authBloc.getStoraredToken();
    setState(() {
      token = storedToken;
    });
    if(token!=null){
      Map<String,dynamic> decodedToken = Jwt.parseJwt(token!);
      if(decodedToken.containsKey('user_id')){
        userId = decodedToken["user_id"];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar información de usuario',
        style: TextStyle(fontSize: 15.0, color: Colors.black,fontWeight: FontWeight.bold),),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'Nombre'),
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Apellidos'),
            ),
            TextFormField(
              controller: _birthdayDateController,
              decoration: InputDecoration(
                labelText: 'Fecha de nacimiento',
                suffixIcon: InkWell(
                  onTap: () {
                    _selectDate(context, _birthdayDateController);
                  },
                  child: Icon(Icons.calendar_today),
                ),
              ),
            ),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Correo'),
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
    String firtsName = _firstNameController.text;
    String lastName = _lastNameController.text;
    //Formatear la fecha de nacimiento al formato deseado
    DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(_birthdayDateController.text);
    String birthdayDate = DateFormat('yyyy-MM-dd').format(parsedDate);
    String email = _emailController.text;

    // Imprime los datos que estás enviando al servicio de actualización
    print('Datos a enviar para actualizar:');
    print('Nombre: $firtsName');
    print('Apellidos: $lastName');
    print('Fecha de nacimiento: $birthdayDate');
    print("Correo: $email");

    // Llama al servicio de actualización
    try {

      print('Datos a enviar para actualizar:');
      print('Nombre: $firtsName');
      print('Apellidos: $lastName');
      print('Fecha de nacimiento: $birthdayDate');
      print("Correo: $email");
      print("Id de la usuaria: $userId");
      print("Token: $token");

      final updatedCitizen = await updateCitizen(
        CitizenUpdate(
          firstname: firtsName,
          lastname: lastName,
          birthdayDate: birthdayDate,
          email: email
        ),
        token,
        userId
      );

      // Si la actualización fue exitosa, muestra el SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Información de perfil guardada exitosamente'),
          duration: Duration(seconds: 4),
          backgroundColor: Colors.green, // Color de fondo del SnackBar
        ),
      );

      Navigator.of(context).pop(updatedCitizen);
    } catch (e) {
      print('Error al actualizar el contacto: $e');
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _birthdayDateController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}

Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime.now(), // Fecha inicial
    firstDate: DateTime(1900), // Fecha mínima permitida
    lastDate: DateTime.now(), // Fecha máxima permitida (hoy)
  );
  if (pickedDate != null) {
    controller.text = DateFormat('dd/MM/yyyy').format(pickedDate); // Actualiza el valor del campo de entrada
  }
}