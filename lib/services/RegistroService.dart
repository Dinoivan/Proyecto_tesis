import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyecto_tesis/models/Registro_models.dart';

Future<void> saveCitizen(Citizen citizen) async {
  final url = Uri.parse('http://10.0.2.2:8080/api/v1/citizen/saveCitizen');

  try{
    final response = await  http.post(url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(citizen.toJson()),
  );

    if(response.statusCode == 200){
      print("Ciudadana registrada con exito");
    }else{
      print("Error al guardar");
      print("Respuesta: ${response.body}");
  }
  }catch(e){
    print("Excepción durante la solicitud: $e");
  }

}