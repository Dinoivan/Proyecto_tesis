import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto_tesis/enviorement/configuration.dart';

Future<String?> getReportPrediction(int? id, String? token) async {
  final String apiUrl = '${ApiConfig.baseUrl}/v1/pattern-recognition/getReportPrediction';

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