import 'package:flutter/material.dart';
import 'package:proyecto_tesis/customwidget/nabvarWidget.dart';
import 'package:proyecto_tesis/blocs/auth_bloc.dart';
import 'package:proyecto_tesis/screems/login.dart';
import 'package:proyecto_tesis/screems/Envio_mensaje.dart';
import 'package:proyecto_tesis/screems/Reporte.dart';
import 'package:proyecto_tesis/screems/Resultados.dart';
import 'package:proyecto_tesis/screems/Agregar_contacto.dart';
import 'package:proyecto_tesis/screems/Contacto_emergencia.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:proyecto_tesis/services/EnvioContactosEmergencia.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthBloc authBloc = AuthBloc();
  bool isAlertButtonPressed = false;
  String statusText = 'Apagado';

  void _toggleAlertButton() {
    setState(() {
      isAlertButtonPressed = !isAlertButtonPressed;
      statusText = isAlertButtonPressed? 'Encendido': 'Apagado';
    });
  }

  int? userId;
  String? token;


  @override
  void initState() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    String? storedToken = await authBloc.getStoredToken();
    setState(() {
      token = storedToken;
    });

    print("Hola soy nuevamente el token, $token");

    if(token!=null){
      Map<String,dynamic> decodedToken = Jwt.parseJwt(token!);
      print("Token decodificado: $decodedToken");

      if(decodedToken.containsKey("user_id")){
        userId = decodedToken["user_id"];
      }
    }
    print("Hola soy el token del navbar: $token");
    print("Hola soy el id: $userId");

  }

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
      'Index 2: Chat',
      style: optionStyle,
    ),
    Text(
      'Index 3: Settings',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
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
              MaterialPageRoute(builder: (context)  => Emergencia()));
          break;
        case 3:
          Navigator.push(context,
              MaterialPageRoute(builder: (context)  => Resultado()));
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
    Color buttonColor = isAlertButtonPressed ? Colors.blueAccent : Colors.black12;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 42.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: Navbar(authBloc: authBloc,),

              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'TIP DEL DÍA',
                      style: TextStyle(fontSize: 24),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Las cosas que te dices a ti misma desempeñan un rol muy importante en cómo te sientes sobre tí',
                      style:
                      TextStyle(fontSize: 13, fontWeight: FontWeight.w400),textAlign: TextAlign.justify,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: InkWell(
                  onTap: () async {

                    try{

                      if(token!=null){

                        _toggleAlertButton();

                        String? resultado = await EnviarEnlace(userId, token);
                        print("Hola soy el resultado del home, $resultado");
                        if(resultado!=null){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Enviar())); // Reemplaza la pantalla actual co

                          print("Hola soy nuevamente el token, $token");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Se envio el mensaje exitosamente.'),
                              duration: Duration(seconds: 4),
                              backgroundColor: Colors.green,
                            ),
                          );

                        }
                      }
                    }catch(e){
                      print("Error algo hiciste mal: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('No se pudo enviar el mensaje.'),
                          duration: Duration(seconds: 4),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  child: Ink(
                    width: 400, // Ancho del botón circular
                    height: 400, // Alto del botón circular
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Establece la forma como círculo
                      color: buttonColor, // Color de fondo del círculo
                    ),
                    child: Center(
                      child: Text(
                        'ALERTA',
                        style: TextStyle(
                          fontSize: 70,
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),

                ),

              ),

              Container(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statusText,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w400,color:Colors.black38),
                        ),

                      ],
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
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Reserva',
            backgroundColor: Colors.blueAccent,

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Comunidad',

          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.help_outline),
            label: 'Numero de ayuda',

          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ajustes',

          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.exit_to_app),
              label: 'Cerrar'
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.grey[700],
        onTap: _onItemTapped,
      ),
    );
  }
}
