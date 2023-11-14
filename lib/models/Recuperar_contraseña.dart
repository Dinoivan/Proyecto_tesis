class Recuperar{
  final String email;

  Recuperar({
    required this.email,
  });

  Map<String,dynamic> toJson(){
    return {
      'email': email,
    };
  }
}
