import 'package:proyecto_tesis/models/Citizen_models.dart';
import 'package:http/http.dart' as http;
import'dart:convert';

Future<String?> fecthCitizenFirsName(String? token,int? id) async {
  final response = await http
      .get(Uri.parse('http://localhost:8080/api/v1/citizen/getCitizenById/$id'),
      headers: {
        'Authorization': '$token',
      });
  if (response.statusCode == 200) {
    var responseData = json.decode(response.body);
    if(responseData is Map<String,dynamic>){
      return responseData['firstname'];
    }
  }
  return null;
}


