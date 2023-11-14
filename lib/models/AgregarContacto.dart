class ContactoEmergencia{
  final DateTime createdDate; // Nuevo campo
  final String fullname;
  final String phonenumber;
  final String relationship;

  ContactoEmergencia({
    required this.fullname,
    required this.phonenumber,
    required this.relationship,
  }): createdDate = DateTime.now(); // Inicializa registrationDate con la fecha y hora actuales;


  Map<String,dynamic> toJson(){
    return {
      'createdDate': createdDate.toIso8601String(),
      'fullname': fullname,
      'phonenumber': phonenumber,
      'relationship': relationship,
    };
  }
}
