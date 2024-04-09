import 'dart:async';
import 'package:proyecto_tesis/models/autentication/login_model.dart';
import 'package:proyecto_tesis/models/autentication/password_change_model.dart';
import 'package:proyecto_tesis/models/autentication/password_recovery_model.dart';
import 'package:proyecto_tesis/services/autentication/login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:proyecto_tesis/services/autentication/password_recovery_service.dart';
import '../../services/autentication/password_change_service.dart';

class AuthBloc {


  Future<int?> login(String email, String password) async {
    LoginResponse response = await loginService(email, password);
    if (response.statusCode == 200 && response.token != null) {
      await _saveTokenToShareddPreferences(response.token!);
    }
    return response.statusCode;
  }

  Future<void> _saveTokenToShareddPreferences(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  Future<String?> getStoraredToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<PasswordRecoveryResponse> passwordRecovery(String email) async{

    PasswordRecoveryResponse response = await passwordRecoveryService(email);

    if(response.statusCode == 200){
      return response;
    }else{
      throw Exception("Error");
    }
  }

  Future<PasswordChangeResponse> passwordChange(String email,String newPassword, int token) async{
    PasswordChangeResponse response =  await passwordChangeService(email, newPassword, token);

    if(response.statusCode == 200){
      return response;
    }else{
      throw Exception("Error");
    }
  }

}