import 'dart:async';

class RecuperarContraBloc {
  final _emailController = StreamController<String>();

  // Stream para transmitir el valor del correo electrónico
  Stream<String> get emailStream => _emailController.stream;

  // Función para cambiar el valor del correo electrónico
  void updateEmail(String email) => _emailController.sink.add(email);

  // Método para enviar un correo de recuperación de contraseña
  Future<void> sendRecoveryEmail(String email) async {
    // Aquí debes implementar la lógica real para enviar el correo de recuperación.
    // Puedes hacer una solicitud HTTP, enviar un correo electrónico, etc.
    print('Enviar correo de recuperación a: $email');
  }

  // Cerrar el controlador cuando ya no se necesite
  void dispose() {
    _emailController.close();
  }
}