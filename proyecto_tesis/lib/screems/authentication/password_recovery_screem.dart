import 'package:flutter/material.dart';
import 'package:proyecto_tesis/models/autentication/password_recovery_model.dart';
import 'package:proyecto_tesis/screems/authentication/login_screems.dart';
import 'package:proyecto_tesis/screems/register/register.dart';
import 'package:proyecto_tesis/screems/main_screems/home.dart';
import 'package:proyecto_tesis/blocs/autentication/auth_bloc.dart';
import 'package:proyecto_tesis/blocs/register/register_bloc.dart';
import 'package:proyecto_tesis/services/autentication/password_recovery_service.dart';
import 'package:proyecto_tesis/screems/authentication/password_change_screem.dart';

class PasswordRecovery extends StatefulWidget {

  final AuthBloc authBloc;

  PasswordRecovery({required this.authBloc});

  @override
  _PasswordRecoveryState createState() => _PasswordRecoveryState();
}

class _PasswordRecoveryState extends State<PasswordRecovery> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;


  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Image(
                      image: AssetImage("assets/principal_.png"),
                      fit: BoxFit.cover, // Para que la imagen ocupe todo el espacio disponible


                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 38.0,top: 20), // Agrega un margen a la izquierda
                alignment: Alignment.centerLeft, // Alinea el texto a la izquierda
                child: Text(
                  'Recuperar contraseña',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 27.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40), // Solo el padding vertical es 40
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailController,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.black26,width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.black26, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                          labelText:  _emailController.text.isEmpty ? "Correo": "",
                          hintText: _emailController.text.isEmpty ? "": "Correo",
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          hintStyle: const TextStyle(
                            color: Colors.black38,
                            fontSize: 15,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese un correo electrónico';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'Ingrese un correo eléctrónico válido';
                          }
                          return null;
                        },
                      ),

                      Container(
                        alignment: Alignment.centerLeft,
                      ),

                      Column(
                        children: <Widget>[

                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                          ),

                          SizedBox(
                            width: double.infinity,
                            height: 55,

                            child: ElevatedButton(
                              onPressed: () async {
                                if(_formKey.currentState != null && _formKey.currentState!.validate()){
                                  final email = _emailController.text;

                                  setState(() {
                                    _isLoading = true;
                                  });

                                  try{
                                    PasswordRecoveryResponse response = await widget.authBloc.passwordRecovery(email);
                                    final message = response.message;
                                    final AuthBloc authBloc = AuthBloc();

                                    Navigator.pushReplacement(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) => PasswordChange(authBloc: authBloc, email: email),
                                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                        transitionDuration: Duration(milliseconds: 5),
                                      ),
                                    );

                                    if(response.statusCode == 200){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text('$message'),
                                        duration: Duration(seconds: 4),
                                        backgroundColor: Colors.green,
                                      ),
                                      );
                                    }
                                    }catch(e){
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Error intente nuevamente'),
                                      duration: Duration(seconds: 4),
                                      backgroundColor: Colors.red,)
                                    );

                                  }finally{
                                    setState(() {
                                      _isLoading = false;
                                    });

                                  }

                                }
                                // lógica para recuperar contraseña
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF7A72DE)), //
                                shape: MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40.0),

                                  ),
                                ),
                              ) ,
                              child: _isLoading ? CircularProgressIndicator() : Text(
                                'Enviar',
                                style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                ),
                                ),
                            ),

                          ),
                          const SizedBox(height: 20),

                          MaterialButton(
                            minWidth: double.infinity,
                            onPressed: () {
                              final AuthBloc authBloc = AuthBloc();

                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => LoginPage(authBloc: authBloc),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                  transitionDuration: Duration(milliseconds: 5),
                                ),
                              );
                            },
                            child: Text(
                              "Acceder cuenta",
                              style: TextStyle(
                                color: Color(0xFF938CDF),
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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