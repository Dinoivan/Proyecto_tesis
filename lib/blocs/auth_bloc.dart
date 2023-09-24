import 'dart:async';

class AuthBloc{
  final _authFieldController = StreamController<String>();

  Stream<String> get authFieldStream => _authFieldController.stream;

  void updateAuthField(String value) => _authFieldController.sink.add(value);

  Future<void> login(String email, String password) async {
    // Aquí debes implementar la lógica real de inicio de sesión,
    // como hacer una solicitud HTTP o verificar las credenciales.
    // Por ejemplo, puedes imprimir los valores aquí:
    print('Email: $email');
    print('Password: $password');
  }

  Future<void> sendRecoveryEmail(String email) async {
    // Aquí debes implementar la lógica real para enviar el correo de recuperación.
    // Puedes hacer una solicitud HTTP, enviar un correo electrónico, etc.
    print('Enviar correo de recuperación a: $email');
  }

  Future<void> changePassword(String verificationCode, String newPassword) async {
    // Aquí debes implementar la lógica para cambiar la contraseña utilizando el código de verificación.
    // Puedes hacer una solicitud HTTP para validar el código y actualizar la contraseña.
    print('Código de verificación: $verificationCode');
    print('Nueva contraseña: $newPassword');
  }

  void dispose(){
    _authFieldController.close();
  }
}