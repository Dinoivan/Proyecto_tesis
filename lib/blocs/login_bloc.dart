import 'dart:async';

class LoginBloc {

  final _emailController = StreamController<String>();
  final _passwordController = StreamController<String>();

  // Streams para transmitir los valores de los campos
  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;

  // Método para realizar la lógica de inicio de sesión
  Future<void> login(String email, String password) async {
    // Aquí debes implementar la lógica real de inicio de sesión,
    // como hacer una solicitud HTTP o verificar las credenciales.

    // Por ejemplo, puedes imprimir los valores aquí:
    print('Email: $email');
    print('Password: $password');
  }

  // Funciones para cambiar los valores de los campos
  void updateEmail(String email) => _emailController.sink.add(email);
  void updatePassword(String password) => _passwordController.sink.add(password);

  // Cerrar los controladores cuando ya no se necesiten
  void dispose() {
    _emailController.close();
    _passwordController.close();
  }
}