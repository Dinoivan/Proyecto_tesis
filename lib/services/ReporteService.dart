import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto_tesis/models/ReporteUsuaria.dart';

Future<void> saveReport(Report report, String? token) async {
  final String apiUrl = 'http://10.0.2.2:8080/api/v1/report/saveReport';

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': '$token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(report.toJson()),
    );
    if (response.statusCode == 200) {
      print('Report saved successfully');
    } else {
      print('Failed to save report. Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  }catch(e){
    print("Error: $e");
  }
}
