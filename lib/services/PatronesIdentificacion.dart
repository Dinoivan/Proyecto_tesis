import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> getReportPrediction(int? id, String? token) async {
  final String apiUrl = 'http://10.0.2.2:8080/api/v1/pattern-recognition/getReportPrediction';

  try {
    final response = await http.post(Uri.parse(apiUrl),
      headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'id': id.toString(),
      }),
    );

    if (response.statusCode == 200) {
      final responseBody = response.body;
      return "$responseBody";
    }

  } catch (e) {
    return "Error al obtener el informe de predicción: $e";
  }
}