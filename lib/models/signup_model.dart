class SignUpBody{
  String name;
  String phone;
  String email;
  String password;
  String address;
  String birthday;
  String lastname;
  String linkedin;
  String username;
  int roleId;

  SignUpBody({
    required this.name,
    required this.phone,
    required this.email,
    required this.password,
    required this.address,
    required this.birthday,
    required this.lastname,
    required this.linkedin,
    required this.username,
    required this.roleId
  });

  Map<String, dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["phone"] = phone;
    data["email"] = email;
    data["password"] = password;
    data["address"] = address;
    data["birthday"] = birthday;
    data["lastname"] = lastname;
    data["linkedin"] = linkedin;
    data["username"] = username;
    data["roleId"] = roleId;
    return data;
  }
}