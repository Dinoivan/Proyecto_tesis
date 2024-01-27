import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyecto_tesis/enviorement/configuration.dart';

Future<String?> Cambiar(String email,String newPassword,int token) async {
  final String apiUrl = '${ApiConfig.baseUrl}/v1/auth/changePassword';

  final Map<String, dynamic>requestBody = {
    "email": email,
    "newPassword": newPassword,
    "token": token,
  };

  try {
    final response = await http.post(Uri.parse(apiUrl),
      headers: {
         'Authorization': '$token',
         'Content-Type': 'application/json',
      },
      body: json.encode(requestBody),
    );
    if (response.statusCode == 200) {
      return "Contraseña cambiada con exito.";
    } else {
      final responseBody = json.decode(response.body);
      final errorMessage = responseBody['mensaje'];
      return "Error al cambiar la contraseña: $errorMessage";
    }
  } catch (e) {
    return "Error al cambiar contraseña: $e";
  }
}
