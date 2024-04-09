import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_tesis/blocs/autentication/auth_bloc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:proyecto_tesis/main.dart';
import 'package:proyecto_tesis/models/register/register_model.dart';
import 'package:proyecto_tesis/screems/main_screems/home.dart';
import 'package:proyecto_tesis/screems/main_screems/emergency_contacts.dart';
import 'package:proyecto_tesis/screems/main_screems/report.dart';
import 'package:proyecto_tesis/services/sreems/citizen_service.dart';
import '../../blocs/register/register_bloc.dart';

class Profile extends StatefulWidget{

  final AuthBloc authBloc;

  Profile({required this.authBloc});

  @override
  _ProfileState createState() => _ProfileState();

}

class _ProfileState extends State<Profile>{
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthdayDateController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  int _selectedIndex = 1;
  static const TextStyle optionStyle = TextStyle(fontSize: 30,fontWeight: FontWeight.bold);

  static const List<Widget> widgetOptions = <Widget>[

    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Profile',
      style: optionStyle,
    ),
    Text(
      'Index 2: Contacts',
      style: optionStyle,
    ),
    Text(
      'Index 3: Reports',
      style: optionStyle,
    ),
    Text(
        'Index 4: Settings'
    )

  ];

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
          _selectedIndex = index;
          _updateIconColors();
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
    Colors.blue, // Mi perfil
    Colors.grey[700], // Contactos
    Colors.grey[700], // Reportes
    Colors.grey[700], // Configura
  ];


  int? userId;
  String? token;
  late Future<Citizen> _citizenFuture;

  @override
  void initState(){
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    String? storedToken = await authBloc.getStoraredToken();
    setState(() {
      token = storedToken;
    });

    if(token!=null){
      Map<String,dynamic> decodedToken = Jwt.parseJwt(token!);
      if(decodedToken.containsKey('user_id')){
        userId = decodedToken["user_id"];
        _loadCitizen();
      }
    }
  }

  Future<void> _loadCitizen() async{
    _citizenFuture = citizenById(token!, userId!);
  }

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
                  margin: EdgeInsets.only(left: 30.0,top: 10.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Mi perfil',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(left: 30.0,top: 10.0),
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    children: [
                      Image(
                        image: AssetImage("assets/Perfil.png"),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            // Aquí puedes implementar la lógica para cargar imágenes desde la galería o la cámara
                          },
                          icon: Icon(Icons.camera_alt),
                        ),
                      ),
                    ],
                  ),
                ),

                FutureBuilder<Citizen>(
                  future: _citizenFuture,
                  builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return CircularProgressIndicator();
                    }else if(snapshot.hasError){
                      return Text('Error: ${snapshot.error}');
                    }else if(snapshot.hasData){
                      final Citizen citizen = snapshot.data!;
                      _fullnameController.text = citizen.firstname;
                      _lastNameController.text = citizen.lastname;
                      String cumple = citizen.birthdayDate;

                      // Convierte el valor de milisegundos a un objeto DateTime
                      DateTime birthdayDateTime = DateTime.fromMillisecondsSinceEpoch(int.tryParse(cumple) ?? 0);

                      birthdayDateTime = birthdayDateTime.add(Duration(days: 1));

                    // Formatea el objeto DateTime en el formato de fecha deseado
                      _birthdayDateController.text = DateFormat('dd/MM/yyyy').format(birthdayDateTime);

                      _emailController.text = citizen.email;

               return Form(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30), // Solo
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: _fullnameController,
                          readOnly: true,
                          style: TextStyle(
                            color:Colors.black,
                            fontSize:15,
                          ),
                          decoration: InputDecoration(
                            border:OutlineInputBorder(
                              borderRadius:BorderRadius.circular(2.0),
                              borderSide: BorderSide(color: Colors.black26, width: 2.0),
                            ),
                            enabledBorder:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              borderSide: BorderSide(color: Colors.black26,width: 2.0),
                            ),
                            focusedBorder:OutlineInputBorder(
                              borderRadius:BorderRadius.circular(2.0),
                              borderSide: BorderSide(color: Colors.black26,width: 2.0),
                            ),
                            labelText: "Nombre",
                            hintText: " Nombre",
                            helperStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        TextFormField(
                          controller: _lastNameController,
                          readOnly: true,
                          style: TextStyle(
                            color:Colors.black,
                            fontSize:15,
                          ),
                          decoration: InputDecoration(
                            border:OutlineInputBorder(
                              borderRadius:BorderRadius.circular(2.0),
                              borderSide: BorderSide(color: Colors.black26, width: 2.0),
                            ),
                            enabledBorder:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              borderSide: BorderSide(color: Colors.black26,width: 2.0),
                            ),
                            focusedBorder:OutlineInputBorder(
                              borderRadius:BorderRadius.circular(2.0),
                              borderSide: BorderSide(color: Colors.black26,width: 2.0),
                            ),
                            labelText: "Apellidos",
                            hintText: " Apellidos",
                            helperStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        SizedBox(height: 20,),
                        TextFormField(
                          controller: _birthdayDateController,
                          readOnly: true,
                          style: TextStyle(
                            color:Colors.black,
                            fontSize:15,
                          ),
                          decoration: InputDecoration(
                            border:OutlineInputBorder(
                              borderRadius:BorderRadius.circular(2.0),
                              borderSide: BorderSide(color: Colors.black26, width: 2.0),
                            ),
                            enabledBorder:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(2.0),
                              borderSide: BorderSide(color: Colors.black26,width: 2.0),
                            ),
                            focusedBorder:OutlineInputBorder(
                              borderRadius:BorderRadius.circular(2.0),
                              borderSide: BorderSide(color: Colors.black26,width: 2.0),
                            ),
                            labelText: "Fecha de nacimiento",
                            hintText: " Fecha de nacimiento",
                            helperStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        SizedBox(height: 20,),
                        TextFormField(
                          controller: _emailController,
                          readOnly: true,
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
                            labelText: "Correo",
                            hintText: " Correo",
                            helperStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                        ),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {

                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF7A72DE)),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0))
                              ),

                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.symmetric(vertical:10.0),
                              ),

                            ),

                            child: const Center(
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
                  );

                    }
                    return SizedBox();
                  },
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
        onTap: _onItemTapped,
      ),
    );

  }
}