import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_tesis/screems/login.dart';
import 'package:proyecto_tesis/blocs/auth_bloc.dart';
import 'package:proyecto_tesis/screems/cambiar-contraseña.dart';
import 'package:proyecto_tesis/screems/home.dart';
import 'package:image_picker/image_picker.dart';
import 'package:proyecto_tesis/screems/Reporte.dart';
import 'package:proyecto_tesis/blocs/auth_bloc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:proyecto_tesis/services/PatronesIdentificacion.dart';
import 'package:proyecto_tesis/screems/Agregar_contacto.dart';
import 'package:proyecto_tesis/screems/Contacto_emergencia.dart';
import 'package:proyecto_tesis/screems/Cuestionarios.dart';
import 'package:proyecto_tesis/screems/Comunidad.dart';

class Resultado extends StatefulWidget {

  const Resultado({Key? key}) : super(key: key);

  @override
  _ResultadoState createState() => _ResultadoState();
}

class _ResultadoState extends State<Resultado> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController imagenController = TextEditingController();
  final AuthBloc authBloc = AuthBloc();
  int _selectedIndex = 0;
  bool _isLoading = true; // Agrega esta variable de estado
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


  int? userId;
  String? token;
  String? resultadoP;

  @override
  void initState() {
    _loadToken();
  }

  Future<void> _loadToken() async {

    setState(() {
      _isLoading = true; // Indica que la información está siendo cargada
    });

    try{

    String? storedToken = await authBloc.getStoredToken();
    setState(() {
      token = storedToken;

    });

    if(token!=null){
      Map<String,dynamic> decodedToken = Jwt.parseJwt(token!);
      print("Token decodificado: $decodedToken");

      if(decodedToken.containsKey("user_id")){
        userId = decodedToken["user_id"];
      }
    }

    String? resultado = await getReportPrediction(userId, token);

    print("Hola soy el token del navbar: $token");
    print("Hola soy el id: $userId");

    setState(() {
      // Puedes guardar el resultado en una variable de estado si quieres utilizarlo en tu interfaz
      // Por ejemplo:
      resultadoP = resultado;
    });
    }catch(e){
      print("Error al cargar el token: $e");
    } finally{
      setState(() {
        // Puedes guardar el resultado en una variable de estado si quieres utilizarlo en tu interfaz
        // Por ejemplo:
        _isLoading = false;
      });
    }
    // Actualiza el estado para que Flutter repinte la interfaz
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Nivel de Riesgo',
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
                          'Resultados de identificación de patrones:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Image(
                        image: AssetImage("assets/Estadistica.png"),
                      ),

                      SizedBox(height: 10,),

                      Text(
                        'Datos estadisticos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize:20.0,
                        ),
                      ),

                      // Muestra el indicador de carga o los resultados según el estado de _isLoading
                      _isLoading
                          ? CircularProgressIndicator()
                          : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '$resultadoP',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),

                      SizedBox(height: 40,),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: RaisedButton(
                          onPressed: () async {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => Reporte()));
                          },
                          color: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.black12),
                          ),
                          child: Center(
                            child: Text(
                              'Ir a Reporte',
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