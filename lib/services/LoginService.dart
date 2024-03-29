import 'package:proyecto_tesis/models/Login_models.dart';
import 'package:http/http.dart' as http;
import'dart:convert';
import 'package:proyecto_tesis/enviorement/configuration.dart';

Future<String?> loginService(String email, String password) async {

  final loginRequest = LoginRequest(email: email, password: password);

  try {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/v1/auth/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(loginRequest.toJson()),
    );

    if (response.statusCode == 200) {
      final token = json.decode(response.body)['token'];
      return token;
    }
  }catch(e){
    return "Error al iniciar sesión: $e";
  }

}

