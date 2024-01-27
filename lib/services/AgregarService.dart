import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyecto_tesis/models/AgregarContacto.dart';
import 'package:proyecto_tesis/enviorement/configuration.dart';

//Servicio para agregar contactos de emergencia
Future<String?> Agregar(ContactoEmergencia contactoEmergencia,String? token) async {
  final String apiUrl = '${ApiConfig.baseUrl}/v1/emergencyContacts/saveEmergencyContacts';
  final Map<String, dynamic>requestBody = contactoEmergencia.toJson();

  try {
    final response = await http.post(Uri.parse(apiUrl),
      headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );
    if (response.statusCode == 200) {
      return "Se agrego contacto de emergencia exitosamente.";
    } else {
      final responseBody = json.decode(response.body);
      final errorMessage = responseBody['mensaje'];
      return "Error al agregar contacto de emergencia: $errorMessage";
    }
  } catch (e) {
    return "Error al agregar contacto: $e";
  }
}
