import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_tesis/screems/main_screems/emergency_contacts.dart';

import '../../blocs/autentication/auth_bloc.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> _messages = [];

  

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