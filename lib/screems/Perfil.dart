import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_tesis/screems/home.dart';
import 'dart:io';

class Perfil extends StatefulWidget {

  const Perfil({Key? key}) : super(key: key);

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  String? _emailError;
  bool _showSuccessMessage = false;

  // Variable para almacenar la ruta de la imagen seleccionada
  String? _selectedImagePath;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Atras",
            style: TextStyle(
              color: Colors.blueAccent,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back,
              size: 20,
              color: Colors.blueAccent,),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(70.0), // Ajusta la altura según tus necesidades
            child: Container(), // Agrega un contenedor vacío para ajustar la altura
          ),

        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            constraints: BoxConstraints(
              minHeight: screenHeight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Perfil',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // InkWell para manejar la carga de la foto
                InkWell(
                  onTap: () {
                    _pickImage();
                  },
                  child: ClipOval(
                    child: Container(
                      color: Colors.transparent, // Fondo transparente
                      child: _selectedImagePath != null
                          ? Image.file(
                        File(_selectedImagePath!),
                        width: 120, // Ajusta el ancho según tus necesidades
                        height: 120, // Ajusta la altura según tus necesidades
                        fit: BoxFit.cover, // Hace que la imagen cubra todo el contenedor
                      )
                          : Image.asset(
                        "assets/seguridad.png",
                        width: 120, // Ajusta el ancho según tus necesidades
                        height: 120, // Ajusta la altura según tus necesidades
                        fit: BoxFit.cover, // Hace que la imagen cubra todo el contenedor
                      ),
                    ),
                  ),
                ),
                Text(
                  'No estás sola',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Nombre:',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: _emailController,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              borderSide: BorderSide(color: Colors.black26),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              borderSide: BorderSide(color: Colors.black26),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            hintText: "Flor",
                            hintStyle: TextStyle(
                              color: Colors.black38,
                              fontSize: 15,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10.0,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese un correo electrónico';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Ingrese un correo eléctronico válido';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Apellido:',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: _emailController,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              borderSide: BorderSide(color: Colors.black26),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              borderSide: BorderSide(color: Colors.black26),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            hintText: "Vasquez Valderrama",
                            hintStyle: TextStyle(
                              color: Colors.black38,
                              fontSize: 15,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10.0,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese un correo electrónico';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Ingrese un correo eléctronico válido';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 10),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Correo electrónico:',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: _emailController,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              borderSide: BorderSide(color: Colors.black26),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              borderSide: BorderSide(color: Colors.black26),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            hintText: "Flor_1120@gmail.com",
                            hintStyle: TextStyle(
                              color: Colors.black38,
                              fontSize: 15,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10.0,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese un correo electrónico';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Ingrese un correo eléctronico válido';
                            }
                            return null;
                          },
                        ),

                        SizedBox(height: 10),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Celular:',
                            style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        TextFormField(
                          controller: _emailController,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              borderSide: BorderSide(color: Colors.black26),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              borderSide: BorderSide(color: Colors.black26),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            hintText: "951322558",
                            hintStyle: TextStyle(
                              color: Colors.black38,
                              fontSize: 15,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10.0,
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, ingrese un correo electrónico';
                            }
                            if (!value.contains('@') || !value.contains('.')) {
                              return 'Ingrese un correo eléctronico válido';
                            }
                            return null;
                          },
                        ),
                        if (_emailError != null)
                          Text(
                            _emailError!,
                            style: TextStyle(
                              color: Colors.red,
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 20,
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: RaisedButton(
                            onPressed: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Se guardo su palabra clave.'),
                                  duration: Duration(seconds: 4),
                                  backgroundColor: Colors.green,
                                ),
                              );

                            },
                            color: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.black12),
                            ),
                            child: Center(
                              child: Text(
                                'Editar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Mostrar el SnackBar cuando _showSuccessMessage sea verdadero
        floatingActionButton: _showSuccessMessage
            ? FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Se envió un código de verificación a su correo electrónico.',
                  textAlign: TextAlign.center,),
                backgroundColor: Colors.green, // Color de fondo para el mensaje exitoso
              ),
            );
          },
        )
            : null
    );
  }
  // Función para seleccionar la imagen desde la galería
  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    }
  }

}



