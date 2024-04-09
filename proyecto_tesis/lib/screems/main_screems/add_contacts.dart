import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_tesis/blocs/register/register_bloc.dart';
import 'package:proyecto_tesis/screems/main_screems/emergency_contacts.dart';
import 'package:proyecto_tesis/blocs/autentication/auth_bloc.dart';
import 'package:proyecto_tesis/models/screems/add_contacts_model.dart';
import 'package:proyecto_tesis/screems/main_screems/profile.dart';
import 'package:proyecto_tesis/screems/main_screems/report.dart';
import 'package:proyecto_tesis/services/sreems/add_contacts_service.dart';

import 'home.dart';

class AddContacts extends StatefulWidget{

  @override
  _AddContactsState createState() => _AddContactsState();

}

class _AddContactsState extends State<AddContacts>{
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _relacionController = TextEditingController();

  final AuthBloc authBloc = AuthBloc();

  String? token;

  @override
  void initState(){
    _loadToken();
  }

  Future<void> _loadToken() async {
    String? storedToken = await authBloc.getStoraredToken();
    setState(() {
      token = storedToken;
    });

  }

  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      _updateIconColors();

      switch (_selectedIndex) {
        case 0:
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => Home(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: Duration(milliseconds: 5),
            ),
          );
          break;
        case 1:
          final AuthBloc authBloc = AuthBloc();
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => Profile(authBloc: authBloc),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: Duration(milliseconds: 5),
            ),
          );
          break;
        case 2:
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => EmergencyContacts(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: Duration(milliseconds: 5),
            ),
          );
          break;
        case 3:

          final RegisterBloc registerBloc = RegisterBloc();
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => Report(registerBloc: registerBloc),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              transitionDuration: Duration(milliseconds: 5),
            ),
          );
          break;
      }
    });
  }

  // Actualizar los colores de los íconos basados en el índice seleccionado
  void _updateIconColors() {
    setState(() {
      // Restaurar el color predeterminado para todos los íconos
      _iconColors = List<Color>.filled(5, Colors.grey[700]!);
      // Actualizar el color del ícono seleccionado
      _iconColors[_selectedIndex] = Colors.blue;
    });
  }

  List<Color?> _iconColors = [
    Colors.grey[700], // Home
    Colors.grey[700], // Mi perfil
    Colors.grey[700], // Contactos
    Colors.grey[700], // Reportes
    Colors.grey[700], // Configura
  ];

  @override
  Widget build(BuildContext context){
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(

      appBar: AppBar(
        title: Text(""),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => EmergencyContacts(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          },
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),


      body: SingleChildScrollView(

        child: Container(
          alignment: Alignment.topCenter,
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[

                Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 10, 30),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Agregar contactos',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Form(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: <Widget>[

                        TextFormField(
                          controller: _nameController,
                          style: TextStyle(
                            color:Colors.black,
                            fontSize:15,
                          ),
                          decoration: InputDecoration(
                            border:OutlineInputBorder(
                              borderRadius:BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Colors.black26, width: 2.0),
                            ),
                            enabledBorder:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Colors.black26,width: 2.0),
                            ),
                            focusedBorder:OutlineInputBorder(
                              borderRadius:BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Colors.black26,width: 2.0),
                            ),
                            hintText: " Nombre",
                            helperStyle: const TextStyle(
                              color: Colors.black12,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        SizedBox(height: 20,),
                        TextFormField(
                          controller: _celularController,
                          style: TextStyle(
                            color:Colors.black,
                            fontSize:15,
                          ),
                          decoration: InputDecoration(
                            border:OutlineInputBorder(
                              borderRadius:BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Colors.black26, width: 2.0),
                            ),
                            enabledBorder:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Colors.black26,width: 2.0),
                            ),
                            focusedBorder:OutlineInputBorder(
                              borderRadius:BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Colors.black26,width: 2.0),
                            ),
                            hintText: " Celular",
                            helperStyle: const TextStyle(
                              color: Colors.black12,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        SizedBox(height: 20,),
                        TextFormField(
                          controller: _relacionController,
                          style: TextStyle(
                            color:Colors.black,
                            fontSize:15,
                          ),
                          decoration: InputDecoration(
                            border:OutlineInputBorder(
                              borderRadius:BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Colors.black26, width: 2.0),
                            ),
                            enabledBorder:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Colors.black26,width: 2.0),
                            ),
                            focusedBorder:OutlineInputBorder(
                              borderRadius:BorderRadius.circular(5.0),
                              borderSide: BorderSide(color: Colors.black26,width: 2.0),
                            ),
                            hintText: " Relación familiar",
                            helperStyle: const TextStyle(
                              color: Colors.black12,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 130),
                        ),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () async {

                              try {
                                // Llama al servicio para agregar el contacto
                                ContactoEmergencia nuevoContacto = ContactoEmergencia(
                                  fullname: _nameController.text,
                                  phonenumber: _celularController.text,
                                  relationship: _relacionController.text,
                                );

                                AddContactsResponse response = await Agregar(nuevoContacto, token);
                                final message = response.message;
                                print("Hola soy nuevamente el token, $token");

                                if(response.statusCode == 200 && token!=null){

                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => EmergencyContacts(),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                      transitionDuration: Duration(milliseconds: 5),
                                    ),
                                  );

                                  print("Hola soy nuevamente el token de agregar contacto, $token");
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Contacto agregado correctamente.'),
                                      duration: Duration(seconds: 4),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error al guardar contacto vuelve a intentarlo'),
                                      duration: Duration(seconds: 4),
                                      backgroundColor: Colors.red,
                                    ),
                                  );

                                }

                              }catch(e){
                                print("Hola soy nuevamente el token, $token");
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('No se pudo agregar contacto vuelve a intentarlo.'),
                                    duration: Duration(seconds: 4),
                                    backgroundColor: Colors.red,
                                  ),
                                );

                              }

                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF7A72DE)),
                              overlayColor: MaterialStateProperty.resolveWith<Color>((states){
                                if(states.contains(MaterialState.disabled)){
                                  return Colors.grey.withOpacity(0.5);
                                }
                                return Colors.transparent;
                              }),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0))
                              ),


                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.symmetric(vertical:10.0),
                              ),

                            ),

                            child: const Center(
                              child: Text(
                                'Guardar',
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

              ]

          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        iconSize: 35,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon:Icon(Icons.home_filled),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Mi perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Contactos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.insert_comment_outlined),
            label: 'Reportes',

          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configura',
          ),

        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey[700],
        onTap: _onItemTapped,
      ),
    );
  }
}