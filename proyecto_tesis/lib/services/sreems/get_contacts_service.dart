import 'package:http/http.dart' as http;
import 'package:proyecto_tesis/environment/configuration.dart';
import 'dart:convert';

Future<List<String>?> GetContactEmergencty(String? token) async{
  try{
    final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/v1/emergencyContacts/getAllEmergencyContactsByCitizenId'),
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