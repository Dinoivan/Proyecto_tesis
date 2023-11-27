import 'package:http/http.dart' as http;

Future<String?> EnviarEnlace(int? userId,String? token) async {
  final String apiUrl = 'http://10.0.2.2:8080/api/v1/citizen/activateEmergencyBtn/$userId';
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