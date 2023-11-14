import 'dart:async';

class RegisterBloc {
  final _fullnameController = StreamController<String>();
  final _lastNameController = StreamController<String>();

  Stream<String> get fullnameStream => _fullnameController.stream;
  Stream<String> get lastNameStream => _lastNameController.stream;

  String? _currentFullname; // Variable para retener el nombre actual
  String? _currentLastName; // Variable para retener el apellido actual

  void updateFullname(String fullname) {
    _currentFullname = fullname; // Actualiza el valor actual
    _fullnameController.sink.add(fullname);
  }

  void updateLastName(String lastName) {
    _currentLastName = lastName; // Actualiza el valor actual
    _lastNameController.sink.add(lastName);
  }

  String? getFullname() {
    return _currentFullname ?? ""; // Devuelve el valor actual
  }

  String? getLastName() {
    return _currentLastName ?? ""; // Devuelve el valor actual
  }

  void dispose() {
    _fullnameController.close();
    _lastNameController.close();
  }
}