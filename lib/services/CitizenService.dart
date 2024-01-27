import 'package:proyecto_tesis/models/Citizen_models.dart';
import 'package:http/http.dart' as http;
import'dart:convert';
import 'package:proyecto_tesis/enviorement/configuration.dart';

Future<String?> fecthCitizenFirsName(String? token,int? id) async {
  final response = await http
      .get(Uri.parse('${ApiConfig.baseUrl}/v1/citizen/getCitizenById/$id'),
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


Future<List<String>?> GetContactEmergencty(String? token) async{
try{
  final response = await http.get(Uri.parse('http://10.0.2.2:8080/api/v1/emergencyContacts/getAllEmergencyContactsByCitizenId'),
      headers: {
        'Authorization': '$token',
      });
  if(response.statusCode == 200){
    var responseData = json.decode(response.body);
    if(responseData is List && responseData.isNotEmpty){
      var fullname = responseData.map((contact) => contact['fullname']).toList();
      print("Datos: $fullname");
      return fullname.cast<String>();
    }
  }
  }catch(e){
    return null;
  }
}


