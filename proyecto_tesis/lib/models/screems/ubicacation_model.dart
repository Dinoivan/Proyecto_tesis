class UbicationURL {
  final String url;

  UbicationURL({required this.url});

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}

class Emergency{
  final int statusCode;

  Emergency({required this.statusCode});

  factory Emergency.fromJson(Map<String,dynamic>json){
    return Emergency(
      statusCode: json['statusCode'],
    );
  }
}