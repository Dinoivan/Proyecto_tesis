import 'package:flutter/material.dart';
import 'package:proyecto_tesis/models/GuardarModel.dart';
import 'package:proyecto_tesis/screems/login.dart';
import 'package:proyecto_tesis/blocs/auth_bloc.dart';
import 'package:proyecto_tesis/screems/home.dart';
import 'package:proyecto_tesis/services/CuestionarioService.dart';
import 'package:proyecto_tesis/models/ModelCuestionarios.dart';
import 'package:proyecto_tesis/services/GuardarRespuestas.dart';
import 'package:proyecto_tesis/screems/Resultados.dart';
import 'package:proyecto_tesis/screems/Contacto_emergencia.dart';
import 'package:proyecto_tesis/screems/Agregar_contacto.dart';
import 'package:proyecto_tesis/screems/Reporte.dart';
import 'package:proyecto_tesis/screems/Comunidad.dart';

class Cuestionario extends StatefulWidget {
  const Cuestionario({Key? key}) : super(key: key);

  @override
  _CuestionarioState createState() => _CuestionarioState();
}

class _CuestionarioState extends State<Cuestionario> {
  TextEditingController nombreController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController fechaSucesoController = TextEditingController();
  TextEditingController respuestaAbiertaController = TextEditingController();
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
      String? storedToken = await authBloc.getStoredToken();
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
    //0 < 7
    //0 1 2 3 4 5 6
    if (preguntaActualIndex < preguntas!.length - 1) {
      if (preguntaActualIndex == 1 || preguntaActualIndex == 2) {
        await _guardarRespuesta(
          preguntas![preguntaActualIndex].id, 0, respuestaAbiertaController.text,
        );
      } else {

        //Lógica para la pregunta 4
        if(preguntaActualIndex == 3 && selectedOptionIndex == 1){
          preguntaActualIndex = 4;
          await _guardarRespuesta(
            preguntas![preguntaActualIndex].id,
            preguntas![preguntaActualIndex].options[selectedOptionIndex!].id,
            "",
          );
        } else{

          await _guardarRespuesta(
            preguntas![preguntaActualIndex].id,
            preguntas![preguntaActualIndex].options[selectedOptionIndex!].id,
            "",
          );
        }
      }
      preguntaActualIndex++;
        print("Contador: $preguntaActualIndex");
        print("Total: ${preguntas!.length}");
        print("Hola");
      selectedOptionIndex = null;
      respuestaAbiertaController.clear();
      }else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Resultado()),
      );
      print("Fin del cuestionario");
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
      appBar: AppBar(
        title: Text('Cuestionario'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Identificación de Patrones',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5,),
            Image(
              image: AssetImage("assets/seguridad.png"),
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
              TextField(
                controller: respuestaAbiertaController,
                onChanged: (text) {
                  setState(() {
                    // Actualizar el estado con el texto ingresado por el usuario
                    respuestaAbierta = text;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Ingresa tu respuesta (solo números)',
                ),
                // ... Otros atributos para personalizar tu TextField
              ),
            SizedBox(height: 5),
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: Wrap(
                  spacing: 20, // Espaciado entre los botones
                  children: [
                    ElevatedButton(
                      onPressed: (preguntaActualIndex > 0)
                          ? () {
                        setState(() {
                          preguntaActualIndex--;
                          selectedOptionIndex = null;
                          respuestaAbiertaController.clear();
                        });
                      }
                          : null,
                      child: Text('Anterior'),
                    ),
                    ElevatedButton(
                      onPressed: handleNextQuestion,
                      child: Text('Siguiente'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}