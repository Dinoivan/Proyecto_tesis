import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:proyecto_tesis/services/CitizenService.dart';
import 'package:proyecto_tesis/blocs/auth_bloc.dart';
import 'dart:async';
import 'package:proyecto_tesis/screems/Perfil.dart';

class Navbar extends StatefulWidget {
  final AuthBloc authBloc; // Agrega una propiedad para el AuthBloc

  Navbar({required this.authBloc});

  @override
  State<StatefulWidget> createState() => _NavBarState();
}

class _NavBarState extends State<Navbar> {

  int? userId;
  String? token;
  String? firstNameD;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

    Future<void> _loadToken() async {
    String? storedToken = await widget.authBloc.getStoredToken();
    setState(() {
      token = storedToken;

    });

    if(token!=null){
      Map<String,dynamic> decodedToken = Jwt.parseJwt(token!);
      print("Token decodificado: $decodedToken");

      if(decodedToken.containsKey("user_id")){
        userId = decodedToken["user_id"];
        _fetchCitizenFirstNameAsync();
      }
    }

    print("Hola soy el token del navbar: $token");
    print("Hola soy el id: $userId");

  }

  Future<void> _fetchCitizenFirstNameAsync() async {
    String? fetchedFirstName = await fecthCitizenFirsName(token, userId);
    if (fetchedFirstName != null) {
      setState(() {
        firstNameD = fetchedFirstName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<String?>(
        // En este punto, la solicitud ya debería haberse realizado si el token y el userId están disponibles
        future: Future.value(firstNameD),
        builder: (BuildContext ctx, AsyncSnapshot<String?> snapshot) {
          if (snapshot.data == null) {
            return Container();
          } else {
            return Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Perfil()));
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      'assets/seguridad.png',
                      width: 60,
                      height: 70,
                    ),
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Hola, ',
                          style: TextStyle(fontSize: 24),
                        ),
                        Text(
                          '$firstNameD', // Cambia esto según tus necesidades
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Usuaria',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          ' | ',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          'Bienvenida',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Align(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 80),
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.notifications),
                          iconSize: 32,
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}


