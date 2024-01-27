import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto_tesis/models/GuardarModel.dart';
import 'package:proyecto_tesis/enviorement/configuration.dart';

Future<String?> Guardar(CuestionarioModel cuestionarioModel,String? token) async {
  final String apiUrl = '${ApiConfig.baseUrl}/v1/questionnaire/saveUserAnswer';
  final Map<String, dynamic>requestBody = cuestionarioModel.toJson();

  try {
    final response = await http.post(Uri.parse(apiUrl),
      headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );
    if (response.statusCode == 200) {
      return "Se agrego la respuesta correctamente.";
    } else {
      final responseBody = json.decode(response.body);
      final errorMessage = responseBody['mensaje'];
      return "Error al agregar una respuesta: $errorMessage";
    }
  } catch (e) {
    return "Error al agregar una respeusta: $e";
  }
}
