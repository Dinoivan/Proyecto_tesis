import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_tesis/screems/home.dart';
import 'package:proyecto_tesis/screems/login.dart';
import 'package:proyecto_tesis/blocs/auth_bloc.dart';
import 'package:proyecto_tesis/screems/Reporte.dart';
import 'package:proyecto_tesis/screems/Resultados.dart';
import 'package:proyecto_tesis/screems/Agregar_contacto.dart';
import 'package:proyecto_tesis/screems/Contacto_emergencia.dart';
import 'package:proyecto_tesis/screems/Comunidad.dart';
import 'package:proyecto_tesis/screems/Compartir-ubicación.dart';

class Enviar extends StatefulWidget {

  @override
  _EnviarState createState() => _EnviarState();
}

class _EnviarState extends State<Enviar> {
  final AuthBloc authBloc = AuthBloc();
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
    Text(
      'Index 3: Settings',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    print("Index seleccionado: $index"); // Agrega esta línea para imprimir el índice
    setState(() {
      _selectedIndex = index;
      switch (_selectedIndex) {
        case 0:
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomePage()));
          break;
        case 1:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Contacto()));
          break;
        case 2:
          Navigator.push(context,
              MaterialPageRoute(builder: (context)  => Comunidad()));
          break;
        case 3:
          Navigator.push(context,
              MaterialPageRoute(builder: (context)  => Reporte()));
          break;
        case 4:
          Navigator.push(context,
              MaterialPageRoute(builder: (context)  => Resultado()));
          break;
        case 5:
          Navigator.push(context,
              MaterialPageRoute(builder: (context)  => Resultado()));
          break;
        case 6:
          _signOut();
          break;
      }
    });
  }

  void _signOut() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(authBloc: authBloc))); // Reemplaza la pantalla actual con la de inicio de sesión
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
          preferredSize: Size.fromHeight(40.0), // Ajusta la altura según tus necesidades
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 10.0,),
                Text(
                  'Ubicación',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0), // Espacio entre la imagen y el subtítulo

                Image(
                  image: AssetImage("assets/Ubicación.png"),
                  width: 300,
                ),

                SizedBox(height: 20.0), // Espacio entre la imagen y el subtítulo
                Text(
                  'SOS',
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 10.0), // Espacio entre el subtítulo y el texto
                Container(
                  width: 370, // Establece el mismo ancho que la imagen
                  child: Text(
                    '¡Necesito ayuda! Esta es mi ubicación en tiempo real',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                ),

                SizedBox(height: 30.0),

                Container(
                  width: 370, // Establece el mismo ancho que la imagen
                  child: Text(
                    'https://savelife.com?param=sdLJKHZXjhmNjkiLCjhcmVhlj.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25.0,
                    ),
                  ),
                ),

                SizedBox(height: 30,),
                Container(
                  width: 370, // Establece el mismo ancho que la imagen
                  child: Text(
                    '¡Enviado a todos los contactos de emergencia seleccionados!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),

                SizedBox(height: 30),
                SizedBox(
                  width:300,
                  height: 50,
                  child: RaisedButton(
                    onPressed: () async {

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)  => Compartir_Ubicacion()));

                    },
                    color: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.black12),
                    ),
                    child: const Center(
                      child: Text(
                        'Ver contactos compartidos',
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


      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Colors.blueAccent,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_ind_rounded),
            label: 'Agregar',
            backgroundColor: Colors.blueAccent,

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Contactos',
            backgroundColor: Colors.blueAccent,

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Emergencia',
            backgroundColor: Colors.blueAccent,

          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            label: 'Reporte',
            backgroundColor: Colors.blueAccent,

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Resultados',
            backgroundColor: Colors.blueAccent,

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exit_to_app),
            label: 'Cerrar',
            backgroundColor: Colors.blueAccent,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey[700],
        onTap: _onItemTapped,
      ),
        // Mostrar el SnackBar cuando _showSuccessMessage sea verdadero
    );
  }
}