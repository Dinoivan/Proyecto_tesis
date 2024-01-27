import 'dart:async';
import 'package:proyecto_tesis/services/LoginService.dart';
import 'package:proyecto_tesis/services/RecuperarService.dart';
import 'package:proyecto_tesis/services/CambiarService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc {

  final _authFieldController = StreamController<String>();

  Stream<String?> get authFieldStream => _authFieldController.stream;

  void updateAuthField(String value) => _authFieldController.sink.add(value);

  //Logica para manejar el inicio de sesión
  Future<String?> login(String email, String password) async {
    String? token = await loginService(email, password);

    print("Token inicial: $token");

    if(token!=null){
      await _saveTokenToShareddPreferences(token);
      // Guarda el token en Shared Preference
    }
    else{
      print('Hola soy el token del else: $token');
      _authFieldController.sink.addError('Error en el inicio de sesión');
    }
    return token;
  }

  Future<void> _saveTokenToShareddPreferences(String token) async {
    //Obtiene una instancia de SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //Guarda el token en SharedPreferences
    await prefs.setString('token', token);

    print('Token guardado en SharedPreferences: $token');
  }

  // Agrega este método
  Future<String?> getStoredToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> sendRecoveryEmail(String email) async {    // Aquí debes implementar la lógica real para enviar el correo de recuperación.
    // Puedes hacer una solicitud HTTP, enviar un correo electrónico, etc.
    String? result = await recuperarContrasena(email);

    if(result!=null){
      print("Codigo de recuperacion enviado a: $email");
    }else{
      print("Error al enviar codigo de verificación al correo: $email");
    }
    return email;
  }

  Future<String?> changePassword(String email,int verificationCode, String newPassword) async {
    // Aquí debes implementar la lógica para cambiar la contraseña utilizando el código de verificación.
    // Puedes hacer una solicitud HTTP para validar el código y actualizar la contraseña.
    String? result = await Cambiar(email, newPassword, verificationCode);
    if (result!=null){
      print("Contraseña cambiada con éxito: $verificationCode");
      print("Resultado: $result");
    }else{
      print("Error al cambiar la contraseña: $newPassword");
    }
    return result;
  }

  void dispose(){
    _authFieldController.close();
  }
}