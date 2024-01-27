import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto_tesis/models/ModelCuestionarios.dart';
import 'package:proyecto_tesis/enviorement/configuration.dart';

Future<List<String>?> GetCuestionarios(String? token) async {
  try {
    final response = await http.
    get(Uri.parse('${ApiConfig.baseUrl}/v1/questionnaire/getAllQuestions'),
        headers: {
          'Authorization': '$token',
        });
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      if (responseData is List && responseData.isNotEmpty) {
        var questionText = responseData.map((
            cuestionario) => cuestionario['questionText']).toList();
        print("Datos: $questionText");
        return questionText.cast<String>();
      }
    }
  } catch (e) {
    return null;
  }
}

Future<List<Question>?> getAllQuestions(String? token) async {
  try {
    final response = await http.get(
      Uri.parse('${ApiConfig.baseUrl}/v1/questionnaire/getAllQuestions'),
      headers: {
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      var responseBody = utf8.decode(response.bodyBytes); // Utilizar utf8.decode
      var responseData = json.decode(responseBody);

      if (responseData is List && responseData.isNotEmpty) {
        var questions = responseData.map((jsonQuestion) {
          var optionsJson = jsonQuestion['options'] as List<dynamic>;
          var options = optionsJson.map((jsonOption) {
            return Option(
              jsonOption['id'],
              jsonOption['optionText'],
              jsonOption['order'],
            );
          }).toList();

          return Question(
            jsonQuestion['id'],
            jsonQuestion['questionText'],
            jsonQuestion['order'],
            options,
          );
        }).toList();

        return questions;
      }
    }
  } catch (e) {
    print('Error: $e');
    return null;
  }
}
