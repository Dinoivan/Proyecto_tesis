import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:proyecto_tesis/main.dart';
import 'package:proyecto_tesis/screems/authentication/login_screems.dart';
import 'package:proyecto_tesis/screems/main_screems/keyword.dart';
import 'package:proyecto_tesis/screems/main_screems/profile.dart';
import 'package:proyecto_tesis/blocs/autentication/auth_bloc.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:proyecto_tesis/screems/main_screems/send_location.dart';
import 'package:proyecto_tesis/screems/main_screems/report.dart';
import 'package:proyecto_tesis/screems/main_screems/emergency_contacts.dart';
import 'package:geolocator/geolocator.dart';
import '../../blocs/register/register_bloc.dart';
import '../../models/screems/ubicacation_model.dart';
import '../../services/sreems/send_emergency_contact_service.dart';
import 'package:flutter_speech/flutter_speech.dart' as speech;
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget{

  @override
  _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home>{

  //Activación de reconocimeinto de voz (palabra clav)
  late final speech.SpeechRecognition _speech;
  bool _isListening = false;
  final List<String> _keywords = ['ayuda'];
  late Timer _timer;
  bool _shouldStopListening = false;


  double? latitude;
  double? longitud;

  bool isAlertButtonPressed = false;
  String statusText = 'Apagado';

  void _toggleAlertButton(){
    setState(() {
      isAlertButtonPressed = !isAlertButtonPressed;
      statusText = isAlertButtonPressed ? 'SOS' : 'SOS';
    });
  }

  int? userId;
  String? token;

  @override
  void initState(){
    _loadToken();
    checkAndRequestMicrophonePermission();
    _speech = speech.SpeechRecognition();
    _initializeSpeechRecognition();
    getLocation();
  }

  Future<void>getLocation() async{
    try{
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        latitude = position.latitude;
        longitud = position.longitude;
      });

    }catch(e){
      print("Error al obtener la ubicación: $e");

    }
  }

  String getGoogleMapsLink(){
    if(latitude!=null && longitud!=null){
      return 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitud';
    }else{
      return '';
    }
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
      }
    }
  }

  void _resetToken(){
    setState(() {
      token = null;
    });
  }

  //Permisos para activar el microfono de celular para escuchar voz
  Future<void> checkAndRequestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (status.isDenied) {
        // El usuario negó el permiso, puedes mostrar un mensaje para solicitarlo nuevamente.
        // Por ejemplo: ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Por favor, habilite el permiso de micrófono.')));
      }
    }
  }

  void _initializeSpeechRecognition() {
    _speech.setAvailabilityHandler((bool result) {
      setState(() {
        _isListening = result;
        print('Reconocimiento de voz disponible: $_isListening');
      });
    });

    _speech.setRecognitionStartedHandler(() {
      setState(() {
        _startTimer();
        _isListening = true;
        print('Reconocimiento de voz disponible: $_isListening');
      });
      _startTimer();
      //Inicia el temporizador cuando se inicia el reconocimiento de voz
    });

    _speech.setRecognitionResultHandler((String? speechText) async {
      if (speechText != null) {
        print("Hola");
        final String spokenText = speechText.toLowerCase();
        if (_keywords.contains(spokenText)) {
          // Llama al servicio
          String googleMapsLink = getGoogleMapsLink();
          UbicationURL ubicationURL = UbicationURL(
              url: googleMapsLink
            // Otros campos según la definición de tu modelo
          );
          Emergency resultado = await EnviarEnlace(userId, ubicationURL, token);

          print('prueba numero 1 de reconocimiento de voz: ${resultado.statusCode}');
          print('enlace generado desde reonocimiento de voz inicialmente: $googleMapsLink');

          // Verifica el resultado del servicio
          if (resultado.statusCode == 200) {
            // Activa el botón SOS
            _toggleAlertButton();
            // Navega a la pantalla de envío de ubicación
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => SendLocation(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
            // Muestra un mensaje de éxito
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Se envió el enlace exitosamente.'),
                duration: Duration(seconds: 4),
                backgroundColor: Colors.green,
              ),
            );
          }else{
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Estado diferente a 200.'),
                duration: Duration(seconds: 4),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
        _startTimer();
      }
    });

    if(!_shouldStopListening){
      _speech.listen();
    }

  }



  void _startTimer() {
    // Inicia un temporizador de 60 segundos
    _timer = Timer(Duration(seconds: 3600), () {
      // Detiene la escucha de voz después de 60 segundos
      _stopListening();
    });
  }

  void _stopListening() {
    _shouldStopListening = true;
    _speech.stop().then((_) {
      if(mounted) {
        setState(() {
          _isListening = false;
        });
      }
    });
    // Cancela el temporizador si se detiene la escucha antes de los 60 segundos
    _timer.cancel();
  }

  @override
  void dispose() {
    _stopListening();
    super.dispose();
  }

  int   _selectedIndex = 0;
static const TextStyle optionStyle = TextStyle(fontSize: 30,fontWeight: FontWeight.bold);

static const List<Widget> widgetOptions = <Widget>[

  Text(
    'Index 0: Home',
    style: optionStyle,
  ),
  Text(
    'Index 1: Mi perfil',
    style: optionStyle,
  ),
  Text(
    'Index 2: Contactos',
    style: optionStyle,
  ),
  Text(
    'Index 3: Reportes',
    style: optionStyle,
  ),
  Text(
    'Index 4: Configura'
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
              transitionDuration: Duration(milliseconds: 40),
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
              pageBuilder: (context, animation, secondaryAnimation) => Report(registerBloc: registerBloc,),
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
      _iconColors[_selectedIndex] = Colors.deepPurple;
    });
  }

  List<Color?> _iconColors = [
    Colors.deepPurple, // Home
    Colors.grey[700], // Mi perfil
    Colors.grey[700], // Contactos
    Colors.grey[700], // Reportes
    Colors.grey[700], // Configura
  ];

  @override
  Widget build(BuildContext context){
    Color buttonColor = isAlertButtonPressed ? Colors.blueAccent: Colors.black12;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(

      appBar: AppBar(
        title: Text(""),
        leading: IconButton(
          onPressed: () {
            _resetToken();
            final AuthBloc authBloc = AuthBloc();
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => LoginPage(authBloc: authBloc),
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
          icon: Icon(Icons.logout, color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[

                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '¿Estas en peligro?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(10.0, 10, 10, 0),
                  alignment: Alignment.center,
                  child: Text(
                    'Haz click sobre el boton para pedir ayuda',
                    style: TextStyle(
                      color: Color.fromRGBO(164, 164, 164, 1.0),
                      fontSize: 17.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 30.0),
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () async {

                      String googleMpasLink = getGoogleMapsLink();

                      print("Enlace generado presionado el boton: $googleMpasLink");

                        UbicationURL ubicationURL = UbicationURL(
                            url: googleMpasLink
                          // Otros campos según la definición de tu modelo
                        );

                        Emergency resultado = await EnviarEnlace(userId, ubicationURL,token);

                        print('prueba del boton 1: ,${resultado.statusCode}');

                        if(resultado.statusCode == 200) {

                          _toggleAlertButton();
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation) => SendLocation(),
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          ); // Reemplaza la pantalla actual co

                          print("Hola soy nuevamente el token, $token");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Se envio el enlace exitosamente.'),
                              duration: Duration(seconds: 4),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }else{
                          print("Hola soy nuevamente el token del else, $token");
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Estado diferente de 200.'),
                                duration: Duration(seconds: 4),
                                backgroundColor: Colors.red,
                              ),
                          );

                        }

                    },
                    child: Container(
                      width: 320, // Aumentamos el tamaño del contenedor para incluir el borde
                      height: 320, // Aumentamos el tamaño del contenedor para incluir el borde
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.transparent, // Hacemos el color del contenedor transparente
                        border: Border.all(
                          color: Color(0xFFE9E8FF), // Color del borde E9E8FF
                          width: 30, // Grosor del borde
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 340,
                          height: 340,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isAlertButtonPressed ? Color(0xFF77A72DE):  Color(0xFFCCC8FF),
                          ),
                          child: Center(
                            child: Text(
                              'SOS',
                              style: TextStyle(
                                fontSize: 40,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 25.0),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text(
                        'Presione el boton para',
                        style: TextStyle(
                          color: Color.fromRGBO(164, 164, 164, 1.0),
                          fontSize: 17.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                     RichText(
                         text: TextSpan(
                           children: [
                             TextSpan(
                               text: 'prender o apagar ',
                               style: TextStyle(
                                 color: Colors.grey,
                                 fontSize: 20.0,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),

                             TextSpan(
                               text: 'la alerta',
                               style: TextStyle(
                                 color: Color.fromRGBO(164, 164, 164, 1.0),
                                 fontSize: 20.0,
                                 fontWeight: FontWeight.bold,
                               ),
                             ),
                           ]
                         ),
                     ),
                    ],
                  ),

                ),

                Form(
                  child: Container(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        ),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: ()  {
                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) => KeyWord(),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF7A72DE)),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.0))
                              ),

                              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                                EdgeInsets.symmetric(vertical:5.0),
                              ),

                            ),

                            child: const Center(
                              child: Text(
                                'Agregar palabra clave',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.0,
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