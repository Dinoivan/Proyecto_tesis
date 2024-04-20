import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_tesis/screems/main_screems/emergency_contacts.dart';
import '../../blocs/autentication/auth_bloc.dart';
import 'package:fuzzy/fuzzy.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = [];

  Map<String, String> predefinedResponses = {
    '¿Cómo puedo usar esta aplicación?': 'Para usar esta aplicación, primero debes registrarte e iniciar sesión. Luego puedes explorar las diferentes funcionalidades y características desde el menú principal.',
    '¿Cómo encuentro mis contactos?': 'Primero inicia sesión, luego selecciona la opción mis contactos en la barra de navegación.',
    '¿Cómo enviar una alerta de emergencia?': 'Primero debes iniciar sesión, luego debes agregar como mínimo un contacto de emergencia par enviar tu ubicación en tiempo real. Asimismo, tienes tres alternativas par enviar tu alerta 1. presionar el boton en la aplicación, 2. Agregando una palabra clave para activar mediante voz, 3. Puedes presionar el anillo para activar el boton en el celular',
    '¿Donde puedo encontrar los números de ayuda de instituciones públicas?': 'Los números de instituciones publicas lo puede encontrar en la sección de configuraciones, presiona "Número de ayuda" y sera redirigido a la sección esperada',
    '¿Cómo puedo recuperar mi contraseña en caso de haberla olvidado?': 'Esta en la pantalla de iniciar sesión, debes presionar en enlace que dice "¿Olvidaste tú contraseña?", luego sera redirigido a la pantalla de recuperación de contraseña donde tendras que ingresar tu contraseña y luego recibaras un código de verificación a tu correo electrónico para que puedas cambiar tu contraseña y volver a iniciar sesión',
    '¿Cómo funciona la sección de reportes en la aplicación?': 'La sesión de reportes sirve para que puedes dejar constancia si has sufrido algun tipo de violencia por parte de tu pareja',
    '¿Como funciona el reconocimiento de patrones en casos de feminicidio?': 'En este caso, primero debes completas el reporte luego seras redirigido a la sección de empezar test de idetinficación de patrones, una vez presionado deberas responder una serie de preguntas que te ayudaran a reconocer el nivel de riesgo de feminicio',
    '¿Cómo agregar palabra clave?': 'Primero inicia sesión, luego deberas hacer clic en el boton agregar palabra clave y seras redirigido para guardar tu palabra clave',
    '¿De que trata la aplicación?': 'La aplicación sirve para identificar patrones en caso de femincidio a traves de Big Data. Asimismo, permite enviar tu ubicación en tiempo real a tu constactos de emergencia cuando te encuentras en peligro lo que permitira que puedan sabr en que parte estas y asi poder ayudarte',
    '¿Para que sirve la aplicación?': 'La aplicación sirve para identificar patrones en caso de femincidio a traves de Big Data. Asimismo, permite enviar tu ubicación en tiempo real a tu constactos de emergencia cuando te encuentras en peligro lo que permitira que puedan sabr en que parte estas y asi poder ayudarte',
    // Agrega más preguntas y respuestas aquí según tus necesidades
  };
  // Función para realizar la búsqueda fuzzy
  // Función para realizar la búsqueda fuzzy
  int levenshteinDistance(String a, String b) {
    int n = a.length;
    int m = b.length;
    List<List<int>> dp = List.generate(n + 1, (_) => List<int>.filled(m + 1, 0));

    for (int i = 0; i <= n; i++) {
      for (int j = 0; j <= m; j++) {
        if (i == 0) {
          dp[i][j] = j;
        } else if (j == 0) {
          dp[i][j] = i;
        } else if (a[i - 1] == b[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] = 1 + [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]].reduce((value, element) => value > element ? element : value);
        }
      }
    }

    return dp[n][m];
  }

// Función para realizar la búsqueda fuzzy
  Future<void> _sendMessage(String text) async {
    try {

      setState(() {
        _messages.insert(0, {'sender':'ChatGPT', 'message': 'Cargando...'});
        _messages.insert(1, {'sender': 'User','message': text});
        _controller.clear();
      });


      double bestSimilarity = 0.0;
      // Verifica si el texto del usuario coincide con alguna pregunta predefinida
      String? predefinedQuestion;
      for (final key in predefinedResponses.keys) {
        // Calcula la distancia de Levenshtein entre el texto del usuario y la pregunta predefinida
        final distance = levenshteinDistance(key.toLowerCase(), text.toLowerCase());
        final maxLength = key.length > text.length ? key.length : text.length;
        final similarity = 1 - (distance / maxLength); // Calcula una medida de similitud basada en la distancia de Levenshtein
        if (similarity > bestSimilarity && similarity >= 0.6) {
          bestSimilarity = similarity;
          predefinedQuestion = key;
          break;
        }
      }

      if (predefinedQuestion != null) {
        // Si se encuentra una pregunta predefinida similar, responde con la respuesta correspondiente
        setState(() {
          // Limpia el texto del TextField después de enviar el mensaj
          _messages.removeAt(0); // Elimina el mensaje "Cargando..."
          _messages.insert(0, {'sender': 'ChatGPT', 'message': predefinedResponses[predefinedQuestion]!});
        });
      } else {
        // Si no se encuentra una pregunta predefinida similar, realiza la solicitud al servicio de ChatGPT
        final response = await http.post(
          Uri.parse('https://api.openai.com/v1/chat/completions'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer', // Reemplaza con tu clave de API
          },
          body: jsonEncode({
            'model': 'gpt-3.5-turbo-0125', // Modelo de ChatGPT
            'messages': [
              {'role': 'user', 'content': text}, // El mensaje del usuario
            ],
            'max_tokens': 150,
            'temperature': 0.7,
            'top_p': 1,
            'frequency_penalty': 0,
            'presence_penalty': 0,
          }),
        );

        if (response.statusCode == 200) {
          // Extrae el texto generado por ChatGPT de la respuesta y decodifica los caracteres especiales
          final data = jsonDecode(response.body);
          final generatedText = utf8.decode(data['choices'][0]['message']['content'].codeUnits);

          // Agrega el mensaje del usuario al principio de la lista
          setState(() {
            // Limpia el texto del TextField después de enviar el mensaje
            _messages.removeAt(0); // Elimina el mensaje "Cargando..."
            _messages.insert(0, {'sender': 'ChatGPT', 'message': generatedText});
          });
        } else {
          throw Exception('Failed to load response');
        }
      }
    } catch (e) {
      print('Error en la solicitud: $e');
      // Maneja el error, por ejemplo, mostrando un mensaje al usuario
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0), // Altura personalizada para el AppBar
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/imagen.png'), // Ruta de la imagen de fondo
              fit: BoxFit.cover, // Ajusta la imagen para cubrir el área del Container
            ),
          ),
          child: AppBar(
            title: Text(''),
            backgroundColor: Colors.transparent, // Fondo del AppBar transparente para mostrar el Container detrás
            elevation: 0, // Sin sombra
            centerTitle: true,
            automaticallyImplyLeading: false,// Centra el título del AppBar
            actions: [
              Container(
                margin: EdgeInsets.only(top: 10,right: 10.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20.0),
                        color: Colors.white,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Salir', style: TextStyle(color: Colors.black)), // Espacio entre el texto y el icono "x"
                          IconButton(
                            onPressed: () {
                              final AuthBloc authBloc = AuthBloc();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EmergencyContacts()));
                            },
                            icon: Icon(Icons.close, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
            // Puedes añadir más opciones de configuración del AppBar aquí
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8),
              color: Colors.white,
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final message = _messages[index];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    title: Align(
                      alignment: message['sender'] == 'User' ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          color: message['sender'] == 'User' ? Color(0xFF7A72DE) : Colors.grey[200],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(message['sender'] == 'User' ? 24 : 4),
                            topRight: Radius.circular(message['sender'] == 'User' ? 4 : 24),
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                        ),
                        child: Text(
                          message['message']!,
                          style: TextStyle(
                            color: message['sender'] == 'User' ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[300], // Color de fondo para el área de entrada de texto y botones
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white, // Color de fondo del campo de texto
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: () async {
                    if (_controller.text.isNotEmpty) {
                      await _sendMessage(_controller.text);
                      _controller.clear(); // Limpiar el texto del TextField después de enviar el mensaje
                    }
                  },
                  icon: Icon(Icons.send),
                  color: Color(0xFF7A72DE), // Color del botón de envío
                  iconSize: 32,
                ),
              ],
            ),
          ),
        ],
      ),


    );
  }
}