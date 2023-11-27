import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_tesis/screems/login.dart';
import 'package:proyecto_tesis/blocs/auth_bloc.dart';
import 'package:proyecto_tesis/screems/cambiar-contraseña.dart';
import 'package:proyecto_tesis/screems/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_tesis/screems/Resultados.dart';
import 'package:proyecto_tesis/models/ReporteUsuaria.dart';
import 'package:proyecto_tesis/services/ReporteService.dart';
import 'package:proyecto_tesis/screems/Cuestionarios.dart';
import 'package:proyecto_tesis/screems/Agregar_contacto.dart';
import 'package:proyecto_tesis/screems/Contacto_emergencia.dart';
import 'package:proyecto_tesis/screems/Comunidad.dart';

class Reporte extends StatefulWidget {

  const Reporte({Key? key}) : super(key: key);

  @override
  _ReporteState createState() => _ReporteState();
}

class _ReporteState extends State<Reporte> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController fechaSucesoController = TextEditingController();
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


  String? token;

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

  }


  Future<void> _submitReport() async {
    try {
      // Crear un objeto Report con los datos del formulario
      Report report = Report(
        createdDate: DateTime.now().toIso8601String(),
        description: descripcionController.text,
        name: nombreController.text,
        reportStatus: 'Archivado',
        reportingDate: fechaSucesoController.text,
      );

      // Obtener el token del AuthBloc o de donde lo estés almacenand

      // Llamar al servicio para guardar el reporte
      await saveReport(report, token);

      // Mostrar un mensaje de éxito (puedes usar un SnackBar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reporte guardado exitosamente.'),
          duration: Duration(seconds: 2),
        ),
      );
    } catch (e) {
      // Manejar errores aquí
      print("Error al guardar el reporte: $e");
    }
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
                  'Generar Reporte',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Form(

                  child: Container(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Nombre:',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: nombreController,
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
                            hintText: "Ingrese Nombre",
                            hintStyle: TextStyle(
                              color: Colors.black38,
                              fontSize: 15,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Descripción de los hechos:',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: descripcionController,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                          maxLines: 5, // Esto permite un número ilimitado de líneas
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
                            hintText: "Ingrese la descripción",
                            hintStyle: TextStyle(
                              color: Colors.black38,
                              fontSize: 15,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10.0,
                            ),
                          ),
                        ),

                        SizedBox(height: 20),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Fecha del suceso:',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: fechaSucesoController,
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
                            hintText: "2023-11-17",
                            hintStyle: TextStyle(
                              color: Colors.black38,
                              fontSize: 15,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 10.0,
                            ),
                          ),
                        ),

                        SizedBox(height: 40),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: RaisedButton(
                            onPressed: () async {
                              _submitReport();

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Cuestionario()),
                              );
                            },
                            color: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: BorderSide(color: Colors.black12),
                            ),
                            child: Center(
                              child: Text(
                                'Siguiente',
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
                          padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 20),
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