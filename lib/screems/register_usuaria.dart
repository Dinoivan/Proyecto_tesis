import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:proyecto_tesis/blocs/register_bloc.dart';
import 'package:proyecto_tesis/blocs/usuaria_register_bloc.dart';
import 'package:proyecto_tesis/screems/login.dart';
import 'package:proyecto_tesis/blocs/auth_bloc.dart';
import 'package:proyecto_tesis/services/RegistroService.dart';
import 'package:proyecto_tesis/models/Registro_models.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController controller;
  final UsuariaRegisterBloc bloc;
  PasswordFormField({required this.controller, required this.bloc});

  @override
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      onChanged: (password) {
        widget.bloc.updatePassword(password);
      },
      obscureText: _obscureText,
      style: TextStyle( // Configura el estilo del texto aquí
        color: Colors.black, // Cambia el color del texto a negro u otro color visible
        fontSize: 20, // Puedes ajustar el tamaño de fuente según tus preferencias
      ),

      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey),
        ),
        hintText: "🔐 Contraseña",
        labelText: "Contraseña",
        labelStyle: TextStyle(fontSize: 18,color: Colors.black),
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),
        suffixIcon: GestureDetector(
          onTap: _togglePasswordVisibility,
          child: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 18.0), // Ajusta el espaciado vertical
      ),
      keyboardType: TextInputType.text,
    );
  }
}

class RegisterUsuaria extends StatefulWidget {

  final RegisterBloc bloc;// Importante: R
  final UsuariaRegisterBloc usuariaBloc; // Agrega UsuariaRegisterBloc// eemplaza UsuariaRegisterBloc con el nombre correcto de tu bloc

  RegisterUsuaria({required this.bloc,required this.usuariaBloc});

  @override
  _RegisterUsuariaState createState() => _RegisterUsuariaState();
}

class _RegisterUsuariaState extends State<RegisterUsuaria> {

  final TextEditingController _aliasController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _firstnameControler = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Nueva instancia de _DateWidget
  final _DateWidget dateWidget = _DateWidget();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Atras",
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
          icon: Icon(Icons.arrow_back,
            size: 20,
            color: Colors.blueAccent,),
        ),
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("Continuemos",
                    style: TextStyle(
                        fontSize: 35,
                        color:Colors.blueAccent),
                  ),
                ],
              ),

              Column(
                children: <Widget>[
                  SizedBox(
                    height: 5,
                  ),

                  DateWidget(),

                  SizedBox(
                    height: 40,
                  ),

                  TextField(
                    controller: _firstnameControler,
                    onChanged: (firstname) {
                      widget.usuariaBloc.updateFirstname(firstname);
                    },
                    decoration: InputDecoration(
                      hintText: "Primer nombre",
                      labelText: "Pirmer nombre de usuaria",
                      labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    obscureText: false,
                    maxLines: 1,
                  ),
                ],
              ),

              TextField(
                controller: _aliasController,
                onChanged: (alias) {
                  widget.usuariaBloc.updateAlias(alias);
                },
                decoration: InputDecoration(
                  hintText: "Alias",
                  labelText: "Alias",
                  labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: false,
                maxLines: 1,
              ),

              TextField(
                controller: _emailController,
                onChanged: (email) {
                  widget.usuariaBloc.updateEmail(email);
                },
                decoration: InputDecoration(
                  hintText: "dinosoft1120@gmail.com",
                  labelText: "Email",
                  labelStyle: TextStyle(fontSize: 18, color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                obscureText: false,
                maxLines: 1,
              ),
              PasswordFormField(controller: _passwordController,bloc: widget.usuariaBloc,),
              Container(
                padding: EdgeInsets.only(top: 3, left: 3),
                decoration:
                BoxDecoration(
                    borderRadius: BorderRadius.circular(10)
                ),

                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,

                  onPressed: () async {

                    try {
                      String firstname = _firstnameControler.text;
                      String alias = _aliasController.text;
                      String email = _emailController.text;
                      String password = _passwordController.text;
                      String birthdayDate = dateWidget.getSelectedDate();

                      String? fullname = widget.bloc.getFullname();
                      String? lastname = widget.bloc.getLastName();

                      // Almacena los valores antes de la llamada al constructor
                      String citizenFullname = fullname ??
                          ""; // Si fullname es null, asigna un valor por defecto (en este caso, una cadena vacía)
                      String citizenLastname = lastname ??
                          ""; // Lo mismo aplica a lastname

                      print("Este el cumpleaños: $birthdayDate");

                      // Crear instancia de Citizen con los datos recopilados
                      Citizen citizen = Citizen(
                        active: true,
                        alias: alias,
                        birthdayDate: birthdayDate,
                        email: email,
                        firstname: firstname,
                        fullname: citizenFullname,
                        lastname: citizenLastname,
                        password: password,
                        // Otros campos según la definición de tu modelo
                      );

                      // Llamar al servicio de registro
                      await saveCitizen(citizen);

                      final AuthBloc authBloc = AuthBloc();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            LoginPage(authBloc: authBloc,)),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Registro exitoso.'),
                          duration: Duration(seconds: 4),
                          backgroundColor: Colors.green,
                        ),
                      );

                    }catch(e){
                      print("Error: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Algo salio mal verifica.'),
                          duration: Duration(seconds: 4),
                          backgroundColor: Colors.red,
                        ),
                      );

                    }
                  },
                  color: Colors.blueAccent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),

                  child: Text(
                    "Siguiente", style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class DateWidget extends StatefulWidget{
  @override
  State<DateWidget> createState() {
    return _DateWidget();
  }
}

class _DateWidget extends State<DateWidget>{
  TextEditingController birthdayDate = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  String getSelectedDate() {
    print("Selected Date: ${birthdayDate.text}");
    return birthdayDate.text;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child:TextField(
          controller: birthdayDate,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.calendar_today,),
            labelText: "Selecciona tu fecha de nacimiento",
            labelStyle: TextStyle(fontSize: 18, color: Colors.black),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          readOnly: true,

          onTap: () async {
            DateTime initialDate = DateTime(2000);
            DateTime pickedDate = await showDatePicker(
                context: context,
                initialDate: initialDate,
                firstDate: DateTime(1942),
                lastDate: DateTime(2023)
            ) as DateTime;
            if(pickedDate != null ){
              print(pickedDate);
              String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
              print(formattedDate);
              setState(() {
                birthdayDate.text = formattedDate;
              });
            }else{
              print("No ha seleccionado una fecha");
            }
          },
        )
    );
  }
}

