import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyecto_tesis/environment/configuration.dart';
import 'package:proyecto_tesis/models/register/register_model.dart';

Future<Citizen> citizenById(String token, int id) async{

  try {
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/v1/citizen/getCitizenById/$id'),
      headers: {
        'Authorization': '$token',
      });

    if(response.statusCode == 200){

      final Map<String, dynamic> responseData = jsonDecode(response.body);

      Citizen citizen = Citizen(
          active: responseData['true'] ?? true,
          alias: responseData['alias'] ?? '',
          birthdayDate: responseData['birthdayDate'].toString(),
          email: responseData['email'] ?? '',
          firstname: responseData['firstname'] ?? '',
          fullname: responseData['fullname'] ?? '',
          lastname: responseData['lastname'] ?? '',
          password: responseData['password'] ?? '',
      );
      return citizen;
    }else{
      throw Exception('Failed to load citizen');
    }

}catch(e){
    throw Exception('Failed to load citizen: $e');
  }

}