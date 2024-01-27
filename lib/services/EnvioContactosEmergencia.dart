import 'package:http/http.dart' as http;
import 'package:proyecto_tesis/enviorement/configuration.dart';

Future<String?> EnviarEnlace(int? userId,String? token) async {
  final String apiUrl = '${ApiConfig.baseUrl}/v1/citizen/activateEmergencyBtn/$userId';
  try {
    final response = await http.get(Uri.parse(apiUrl),
      headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      return "Activación de botón de emergencia exitosa.";
    }
  } catch (e) {
    return "Error al activar boton de emergencia: $e";
  }
}