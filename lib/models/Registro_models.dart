import 'package:intl/intl.dart';

class Citizen{
  final bool active;
  final String alias;
  final String birthdayDate;
  final String email;
  final String firstname;
  final String? fullname;
  final String? lastname;
  final String password;
  final DateTime registrationDate; // Nuevo campo

  Citizen(
      {
        required this.active,
        required this.alias,
        required this.birthdayDate,
        required this.email,
        required this.firstname,
        required this.fullname,
        required this.lastname,
        required this.password,}): registrationDate = DateTime.now(); // Inicializa registrationDate con la fecha y hora actuales;

  Map<String, dynamic> toJson() {
    return {
      'active': active,
      'alias': alias,
      'birthdayDate': birthdayDate,
      'email': email,
      'firstname': firstname,
      'fullname': fullname,
      'lastname': lastname,
      'password': password,
      'registrationDate': registrationDate.toIso8601String(),

    };
  }
}