
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_tesis/screems/login.dart';
import 'package:proyecto_tesis/blocs/auth_bloc.dart';
import 'package:proyecto_tesis/screems/home.dart';
import 'package:proyecto_tesis/screems/Resultados.dart';
import 'package:proyecto_tesis/screems/Reporte.dart';
import 'package:proyecto_tesis/screems/Agregar_contacto.dart';
import 'package:proyecto_tesis/services/CitizenService.dart';
import 'package:proyecto_tesis/screems/Cuestionarios.dart';
import 'package:proyecto_tesis/screems/Comunidad.dart';

class Emergencia extends StatefulWidget {

  const Emergencia({Key? key}) : super(key: key);

  @override
  _EmergenciaState createState() => _EmergenciaState();
}

class _EmergenciaState extends State<Emergencia> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController imagenController = TextEditingController();
  final AuthBloc authBloc = AuthBloc();
  int _selectedIndex = 0;

  String? token;
  List<String>? contactosDeEmergencia;

  @override
  void initState() {
    super.initState();
    // Llamar al servicio para obtener la lista de contactos de emergencia
    _loadToken();
  }

    Future<void> _loadToken() async {
      String? storedToken = await authBloc.getStoredToken();
      setState(() {
        token = storedToken;
      });

      print("Hola soy el token estoy en mis contactos de emergencia: $token");
      await _getContactosEmergencia();
    }

  Future<void> _getContactosEmergencia() async {
    try {
      // Llamada al servicio desde CitizenService
      List<String>? contactos = await GetContactEmergencty(token);
      print("contactos: $contactos");

      setState(() {
        contactosDeEmergencia = contactos;
      });
    } catch (e) {
      print('Error al obtener contactos de emergencia: $e');
    }
  }

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: optionStyle,
    ),
    Text(
      'Index 1: Agregar',
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
              MaterialPageRoute(builder: (context)  => Cuestionario()));
          break;
        case 6:
          _signOut();
          break;
      }
    });
  }

  // Función para gestionar la salida de la sesión
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
          preferredSize: Size.fromHeight(10.0), // Ajusta la altura según tus necesidades
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
                'Mis contactos de emergencia',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 35.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5,),
              Form(

                child: Container(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[

                      Container(
                        width: 350, // Establece el mismo ancho que la imagen
                        child: Text(
                          'Agregar tus contactos de confianza en la lista para alertarlos cuando actives la alarma de emergencia',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                          ),
                        ),
                      ),

                      SizedBox(height: 25),

                      // Mostrar la lista de contactos estilizada
                      if (contactosDeEmergencia != null && contactosDeEmergencia!.isNotEmpty)
                        Column(
                          children: contactosDeEmergencia!
                              .map((nombre) => Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  nombre,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.check_box_rounded,
                                  color: Colors.blueAccent,
                                ),
                              ],
                            ),
                          ))
                              .toList(),
                        )
                      else
                        Text(
                        'No existen contactos agregados',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                          ),
                        ),

                      SizedBox(height: 25),


                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: RaisedButton(
                          onPressed: () async {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => Contacto()));
                          },
                          color: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.black12),
                          ),
                          child: Center(
                            child: Text(
                              'Agregar contacto',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                      ),

                      SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: RaisedButton(
                          onPressed: () async {

                          },
                          color: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.black12),
                          ),
                          child: Center(
                            child: Text(
                              'Resolver dudas con chatbot',
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