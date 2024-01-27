import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:proyecto_tesis/enviorement/configuration.dart';

Future<String?> recuperarContrasena(String email) async {
  try {
    final response = await http.post(
      Uri.parse('${ApiConfig.baseUrl}/v1/auth/requestPasswordChange/$email'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      // Si el servidor devuelve un código 200, significa que la solicitud fue exitosa.
      return "Se ha enviado un enlace de recuperación de contraseña a $email.";
    } else {
      // Si el servidor devuelve un código diferente de 200, puedes manejar los errores de manera adecuada.
      final responseBody = json.decode(response.body);
      final errorMessage = responseBody['message']; // Esto puede variar según tu API
      return "Error al solicitar la recuperación de contraseña: $errorMessage";
    }
  } catch (e) {
    // En caso de error de red u otros errores, puedes manejarlos aquí.
    return "Error al solicitar la recuperación de contraseña: $e";
  }
}