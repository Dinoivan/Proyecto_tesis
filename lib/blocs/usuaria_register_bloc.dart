import 'dart:async';

class UsuariaRegisterBloc {

  final _aliasController = StreamController<String>();
  final _birthdayDateController = StreamController<String>();
  final _emailController = StreamController<String>();
  final _firstnameController = StreamController<String>();
  final _passwordController = StreamController<String>();

  // Streams para transmitir los valores de los campos
  Stream<String> get aliasStream => _aliasController.stream;
  Stream<String> get birthdayStream => _birthdayDateController.stream;
  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get firstnameStream => _firstnameController.stream;
  Stream<String> get passwordStream => _passwordController.stream;

  // Variables para retener los valores actuales
  String? _currentAlias;
  String? _currentBirthdayDate;
  String? _currentEmail;
  String? _currentFirstname;
  String? _currentPassword;

  // Métodos para actualizar los valores y transmitirlos a los streams
  void updateAlias(String alias) {
    _currentAlias = alias;
    _aliasController.sink.add(alias);
  }

  void updateBirthdayDate(String birthdayDate) {
    _currentBirthdayDate = birthdayDate;
    _birthdayDateController.sink.add(birthdayDate);
  }

  void updateEmail(String email) {
    _currentEmail = email;
    _emailController.sink.add(email);
  }

  void updateFirstname(String firstname) {
    _currentFirstname = firstname;
    _firstnameController.sink.add(firstname);
  }

  void updatePassword(String password) {
    _currentPassword = password;
    _passwordController.sink.add(password);
  }

  // Métodos para obtener los valores actuales
  String? getCurrentAlias() {
    return _currentAlias ?? "";
  }

  String? getCurrentBirthdayDate() {
    return _currentBirthdayDate ?? "";
  }

  String? getCurrentEmail() {
    return _currentEmail ?? "";
  }

  String? getCurrentFirstname() {
    return _currentFirstname ?? "";
  }

  String? getCurrentPassword() {
    return _currentPassword ?? "";
  }

  // Cerrar los controladores cuando ya no se necesiten
  void dispose() {
    _aliasController.close();
    _birthdayDateController.close();
    _emailController.close();
    _firstnameController.close();
    _passwordController.close();
  }
}