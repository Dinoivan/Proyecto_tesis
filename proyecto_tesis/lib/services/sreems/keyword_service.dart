import 'package:proyecto_tesis/environment/configuration.dart';
import 'package:proyecto_tesis/models/screems/keyword_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<KeywordResponse> keywordService(String keyword, String? token) async{

  final keywordModel_ = KeywordModel(keyword: keyword);

  try{
    final response = await http.post(Uri.parse('${ApiConfig.baseUrl}/v1/keywordAudio/saveKeywordAudio'),
    headers: {
      'Authorization': '$token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(keywordModel_),
    );

    if(response.statusCode == 200){
      return KeywordResponse(statusCode: response.statusCode);
    }else{
      return KeywordResponse(statusCode: response.statusCode);
    }

  }catch(e){
    throw Exception('Error al agregar palabra clave');
  }
}

Future<String?>getKeyWordService(String? token) async{
  final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/v1/keywordAudio/getKeywordAudioByCitizen'),
  headers: {
    'Authorization': '$token',
  });
  if(response.statusCode == 200){
    var responseData = json.decode(response.body);
    if(responseData is Map<String,dynamic>){
      return responseData['keyword'];
    }
  }
  return 'Desconocido';
}
