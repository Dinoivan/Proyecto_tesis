import 'package:flutter/material.dart';
import 'package:proyecto_tesis/blocs/register/register_bloc.dart';
import 'package:proyecto_tesis/screems/authentication/login_screems.dart';
import 'package:proyecto_tesis/blocs/autentication/auth_bloc.dart';
import 'package:proyecto_tesis/screems/main_screems/emergency_contacts.dart';
import 'package:proyecto_tesis/screems/main_screems/home.dart';
import 'package:proyecto_tesis/screems/main_screems/profile.dart';
import 'package:proyecto_tesis/screems/main_screems/report.dart';
import 'package:proyecto_tesis/screems/main_screems/result.dart';

import '../../models/screems/questionaire_model.dart';
import '../../services/sreems/questionaire_service.dart';

class Questionnaire extends StatefulWidget {
  const Questionnaire({Key? key}) : super(key: key);

  @override
  _QuestionaireState createState() => _QuestionaireState();
}

class _QuestionaireState extends State<Questionnaire> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController fechaSucesoController = TextEditingController();
  TextEditingController respuestaAbiertaController = TextEditingController();
  final AuthBloc authBloc = AuthBloc();
  int _selectedIndex = 0;
  bool _isLoading = true; // Agrega esta variable de estado

  String? token;
  List<String>? Cuestionarios;

  List<Question>? preguntas;
  int preguntaActualIndex = 0;
  int? selectedOptionIndex;
  String respuestaAbierta = '';

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {

    setState(() {
      _isLoading = true; // Indica que la información está siendo cargada
    });

    try {
      String? storedToken = await authBloc.getStoraredToken();
      setState(() {
        token = storedToken;
      });

      print("Token: $token");
      await _getCuestionarios();
    }catch(e){
      print("Error al cargar el token: $e");
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _getCuestionarios() async {
    try {
      List<Question>? cuestionarios = await getAllQuestions(token);
      print("Preguntas: $cuestionarios");

      setState(() {
        preguntas = cuestionarios;
      });
    } catch (e) {
      print('Error al obtener cuestionarios: $e');
    }
  }

  void handleOptionSelected(int? index) {
    setState(() {
      selectedOptionIndex = index;
    });
  }

  void handleNextQuestion() async {
    print('selectedOptionIndex: $selectedOptionIndex');
    print('respuestaAbiertaController.text: ${respuestaAbiertaController.text}');
    // Realizar trabajo asíncrono fuera del setState

    if (preguntaActualIndex < preguntas!.length) {
      if (preguntaActualIndex == 1 || preguntaActualIndex == 2) {
        await _guardarRespuesta(
          preguntas![preguntaActualIndex].id, 0, respuestaAbiertaController.text,
        );
      } else {
        // Lógica para la pregunta 4
        if (preguntaActualIndex == 3 && selectedOptionIndex == 1) {
          preguntaActualIndex = 4;
          await _guardarRespuesta(
            preguntas![preguntaActualIndex].id,
            preguntas![preguntaActualIndex].options[selectedOptionIndex!].id,
            "",
          );
        } else {
          await _guardarRespuesta(
            preguntas![preguntaActualIndex].id,
            preguntas![preguntaActualIndex].options[selectedOptionIndex!].id,
            "",
          );
        }
      }
      // Verificar si se debe navegar a la pantalla Resultado
      if (preguntaActualIndex == 6) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => Result(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: Duration(milliseconds: 5),
          ),
        );
        print("Fin del cuestionario");
      }else{
        preguntaActualIndex++;
        print("Contador: $preguntaActualIndex");
        print("Total: ${preguntas!.length}");
        print("Hola");
        print("Hola como estas");
        selectedOptionIndex = null;
        respuestaAbiertaController.clear();
      }
    }

    // Actualizar el estado sin código asíncrono
    setState(() {
      // No es necesario realizar ninguna actualización de estado aquí
    });
  }
  Future<void>_guardarRespuesta(int questionId,int optionId, String answerText) async{
    try{
      //Llamo al servicio de guardar
      String? result = await Guardar(CuestionarioModel(
        answerText: answerText,
        optionId: optionId,
        questionId: questionId,
      ), token,
      );
      print(result);
    }catch(e){
      print("Error al guardar respuesta: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    if(_isLoading){
      return Center(child: CircularProgressIndicator(),
      );
    }

    if (preguntas == null || preguntas!.isEmpty) {
      return Text('No hay preguntas disponibles');
    }

    Question preguntaActual = preguntas![preguntaActualIndex];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200.0), // Altura personalizada para el AppBar
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Identificación de Patrones',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 5,),
            Text(
              "${preguntaActualIndex + 1}. ${preguntaActual.questionText}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (int i = 0; i < preguntaActual.options.length; i++)
                  InkWell(
                    onTap: () {
                      handleOptionSelected(i);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: selectedOptionIndex == i
                            ? Colors.blueAccent.withOpacity(0.2)
                            : Colors.transparent,
                        border: Border.all(
                          color: selectedOptionIndex == i
                              ? Colors.blueAccent
                              : Colors.grey,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${String.fromCharCode(i + 65)}. ${preguntaActual.options[i].optionText}",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          selectedOptionIndex == i
                              ? Icon(
                            Icons.check,
                            color: Colors.blueAccent,
                          )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            // Mostrar input de texto para preguntas sin opciones
            if (preguntaActual.options.isEmpty)
              TextFormField(
                controller: respuestaAbiertaController,
                onChanged: (text) {
                  setState(() {
                    // Actualizar el estado con el texto ingresado por el usuario
                    respuestaAbierta = text;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Ingresa tu respuesta (solo números)',
                ),
                keyboardType: TextInputType.number,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese información';
                  }
                  final RegExp numericRegex = RegExp(r'^[0-9]+$');
                  if (!numericRegex.hasMatch(value)) {
                    return 'Ingrese sólo números';
                  }
                  return null;
                },
                // ... Otros atributos para personalizar tu TextField
              ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: (preguntaActualIndex > 0) ? () {
                        setState(() {
                          preguntaActualIndex--;
                          selectedOptionIndex = null;
                          respuestaAbiertaController.clear();
                        });
                      } : null,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: (preguntaActualIndex > 0) ? Colors.grey : Colors.grey), // Borde con color purple si está activado, blanco si no lo está
                        backgroundColor: (preguntaActualIndex > 0) ? Colors.white : Colors.white, // Fondo purple si está activado, blanco si no lo está
                        minimumSize: Size(double.infinity, 50), // Tamaño mínimo del botón
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Bordes cuadrados
                      ),
                      child: Text('Anterior', style: TextStyle(color: (preguntaActualIndex > 0) ? Colors.black : Colors.black)), // Texto blanco si está activado, negro si no lo está
                    ),
                  ),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: handleNextQuestion,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.deepPurpleAccent), // Borde purple
                          backgroundColor:  Color(0xFFF7A72DE), // Fondo blanco
                          minimumSize: Size(double.infinity, 50), // Tamaño mínimo del botón
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Bordes cuadrados
                        ),
                        child: Text('Siguiente', style: TextStyle(color: Colors.white)), // Texto purple
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}