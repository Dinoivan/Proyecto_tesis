import 'package:flutter/material.dart';
import 'package:proyecto_tesis/main.dart';
import 'package:proyecto_tesis/models/screems/keyword_model.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:proyecto_tesis/services/sreems/keyword_service.dart';


class EditKeywordModal extends StatefulWidget {
  String? palabraClave;

  EditKeywordModal({required this.palabraClave});

  @override
  _EditKeywordModalState createState() => _EditKeywordModalState();
}

class  _EditKeywordModalState  extends State<EditKeywordModal> {

  late TextEditingController _keywordController;

  String? token;
  String? keyword;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int? userId;
  int? id;

  @override
  void initState() {
    super.initState();
    _loadToken();
    _keywordController = TextEditingController(text: widget.palabraClave);
  }

  Future<void> _loadToken() async{
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

    await _getKeyword();
  }

  Future<void> _getKeyword() async{
    try{
      getKeywordCitizen? palabraClave = await getKeyWordService(token);
      setState(() {
        keyword = palabraClave?.keyword;
        id = palabraClave?.id;
        _keywordController.text = keyword ?? "";
      });
    }catch(e){
      print("Error al obtener palabra clave: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Editar palabra clave', style: TextStyle(fontSize: 15.0, color: Colors.black,fontWeight: FontWeight.bold),),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _keywordController,
                decoration: InputDecoration(labelText: 'Palabra clave'),
                keyboardType: TextInputType.text,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese la palabra clave';
                  }
                  final RegExp letterRegex = RegExp(r'^[a-zA-Z]+$');
                  if (!letterRegex.hasMatch(value)) {
                    return 'Solo se permiten letras sin caracteres especiales ni números';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      actions: <Widget>[

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el modal sin guardar cambios
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Guarda los cambios y llama al servicio para actualizar el contacto
                _updateContact();
              },
              child: Text('Guardar'),
              style: ButtonStyle(
                overlayColor: MaterialStateProperty.resolveWith<Color?>(
                      (states) {
                    if (states.contains(MaterialState.disabled)) {
                      return null; // Permite que el botón esté desactivado visualmente
                    }
                    return Colors.transparent;
                  },
                ),
              ),
            ),
          ],
        )
      ],
    );
  }

  void _updateContact() async {

    // Obtén los nuevos valores de los campos
    String keyword = _keywordController.text;
    // Imprime los datos que estás enviando al servicio de actualización
    print('Datos a enviar para actualizar:');
    print('Palabra clave: $keyword');


    // Llama al servicio de actualización
    try {

      print('Datos a enviar para actualizar:');
      print('Palabra clave: $keyword');
      print("Id de la usuaria: $id");
      print("Token: $token");

      final updateKeyword_ = await updateKeyword(keyword, token, id);

      Navigator.of(context).pop(updateKeyword_);
    } catch (e) {
      print('Error al actualizar el contacto: $e');
    }
  }

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }
}
