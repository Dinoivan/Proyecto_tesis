class Cambiar{
  final String email;
  final String password;
  final String token;

  Cambiar({
    required this.email,
    required this.password,
    required this.token,
  });

  Map<String,dynamic> toJson(){
    return {
      'email': email,
      'password': password,
      'token': token
    };
  }
}
