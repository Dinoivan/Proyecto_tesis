import 'package:proyecto_tesis/environment/configuration.dart';
import 'package:proyecto_tesis/models/screems/add_contacts_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//Servicio para agregar contactos de emergencia
Future<AddContactsResponse> Agregar(ContactoEmergencia contactoEmergencia,String? token) async {

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

    final String message = response.body;

    if (response.statusCode == 200) {
      return AddContactsResponse(statusCode: response.statusCode, message: message);
    } else {
      return AddContactsResponse(statusCode: response.statusCode, message: message);
    }
  } catch (e) {
    throw Exception("Error al agregar contactos: $e");
  }
}