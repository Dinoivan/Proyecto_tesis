import 'dart:async';

class UsuariaRegisterBloc {
  final _phoneController = StreamController<String>();
  final _aliasController = StreamController<String>();
  final _emailController = StreamController<String>();
  final _passwordController = StreamController<String>();

  // Streams para transmitir los valores de los campos
  Stream<String> get phoneStream => _phoneController.stream;
  Stream<String> get aliasStream => _aliasController.stream;
  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;

  // Funciones para cambiar los valores de los campos
  void updatePhone(String phone) => _phoneController.sink.add(phone);
  void updateAlias(String alias) => _aliasController.sink.add(alias);
  void updateEmail(String email) => _emailController.sink.add(email);
  void updatePassword(String password) => _passwordController.sink.add(password);

  // Cerrar los controladores cuando ya no se necesiten
  void dispose() {
    _phoneController.close();
    _aliasController.close();
    _emailController.close();
    _passwordController.close();
  }
}