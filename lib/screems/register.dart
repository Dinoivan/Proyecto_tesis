import 'package:flutter/material.dart';
import 'package:proyecto_tesis/blocs/register_bloc.dart';
import 'package:proyecto_tesis/screems/register_usuaria.dart';
import 'package:proyecto_tesis/blocs/usuaria_register_bloc.dart';


class Register extends StatefulWidget {

  final RegisterBloc bloc;
  final String? fullname; // Añade un campo para el nombre
  final String? lastname; // Añade un campo para el apellido

  Register({required this.bloc,this.fullname,this.lastname});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(

        title: const Text("Atras",
          style: TextStyle(
            color: Colors.blueAccent,
          ),
        ),

        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back,
            size: 20,
            color: Colors.blueAccent,),
        ),
      ),
      body: Form(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Text("Registremos tus datos",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text("Para empezar, cuéntanos...",
                    style: TextStyle(
                        fontSize: 20,
                        color:Colors.grey[700]),
                  ),
                ],
              ),
              Column(
                children: <Widget>[

                  StreamBuilder<String>(
                    stream: widget.bloc.fullnameStream,
                    builder: (context, snapshot) {
                      return TextField(
                        decoration: InputDecoration(
                          hintText: "Nombre",
                          labelText: "¿Cuál es tu nombre?",
                          labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorText: snapshot.error != null ? snapshot.error.toString() : null,
                        ),
                        onChanged: widget.bloc.updateFullname, // Actualizar el valor en el BLoC
                        obscureText: false,
                        maxLines: 1,
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),

                  StreamBuilder<String>(
                    stream: widget.bloc.lastNameStream,
                    builder: (context, snapshot) {
                      return TextField(
                        decoration: InputDecoration(
                          hintText: "Apellido",
                          labelText: "¿Y tu apellido?",
                          labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorText: snapshot.error != null ? snapshot.error.toString() : null,
                        ),
                        onChanged: widget.bloc.updateLastName, // Actualizar el valor en el BLoC
                        obscureText: false,
                        maxLines: 1,
                      );
                    },
                  ),
                ],
              ),

              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 80, // Ancho igual al formulario
                        child: MaterialButton(
                          height: 50,
                          onPressed: (){
                            //Actualizar el nombre y apellido en el bloc
                            widget.bloc.updateFullname(widget.fullname ?? '');
                            widget.bloc.updateLastName(widget.lastname ?? '');
                            final UsuariaRegisterBloc usuariaBloc = UsuariaRegisterBloc();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterUsuaria(bloc: widget.bloc, usuariaBloc: usuariaBloc,)));
                          },
                          color: Colors.blueAccent, // Color de fondo
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: const Center(
                            child: Text(
                              "Siguiente",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
