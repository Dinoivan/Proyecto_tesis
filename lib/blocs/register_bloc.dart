import 'dart:async';

class RegisterBloc {
  final _nameController = StreamController<String>();
  final _lastNameController = StreamController<String>();

  // Streams para transmitir los valores de los campos
  Stream<String> get nameStream => _nameController.stream;
  Stream<String> get lastNameStream => _lastNameController.stream;

  // Funciones para cambiar los valores de los campos
  void updateName(String name) => _nameController.sink.add(name);
  void updateLastName(String lastName) => _lastNameController.sink.add(lastName);

  // Cerrar los controladores cuando ya no se necesiten
  void dispose() {
    _nameController.close();
    _lastNameController.close();
  }
}