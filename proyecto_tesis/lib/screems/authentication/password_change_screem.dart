import 'package:flutter/material.dart';
import 'package:proyecto_tesis/models/autentication/password_change_model.dart';
import 'package:proyecto_tesis/screems/authentication/login_screems.dart';
import 'package:proyecto_tesis/blocs/autentication/auth_bloc.dart';

class PasswordChange extends StatefulWidget {

  final AuthBloc authBloc;
  String email;

  PasswordChange({required this.authBloc,required this.email});

  @override
  _PasswordChangeState createState() => _PasswordChangeState();
}

class _PasswordChangeState extends State<PasswordChange> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();
  bool _isLoading = false;

  String? _nuevoError;


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
                  'Cambiar contraseña',
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
                        controller: _codigoController,
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
                          labelText: _codigoController.text.isEmpty ? "Código": "",
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          hintText:  _codigoController.text.isEmpty ? "": "657890",
                          hintStyle: const TextStyle(
                            color: Colors.black38,
                            fontSize: 15,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
                        ),
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese codigo de verificación';
                          }
                          final RegExp numericRegex = RegExp(r'^[0-9]+$');
                          if (!numericRegex.hasMatch(value)) {
                            return 'Ingrese sólo números';
                          }
                          if(value.length != 6){
                            return 'El código debe tener exactamente 6 números';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 20),

                      Container(
                        alignment: Alignment.centerLeft,
                      ),

                      TextFormField(
                        controller: _passwordController,
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
                          labelText: _passwordController.text.isEmpty ? "Contraseña": "",
                          labelStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          hintText: _passwordController.text.isEmpty ? "": "..........",
                          hintStyle: const TextStyle(
                            color: Colors.black38,
                            fontSize: 15,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
                        ),
                        keyboardType: TextInputType.text,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese su nueva contraseña';
                          }
                          final RegExp specialCharacterRegex = RegExp(r'[!@#\$%^&*(),.?":{}|<>_-]');
                          final RegExp uppercaseLetterRegex = RegExp(r'[A-Z]');
                          final RegExp lowercaseLetterRegex = RegExp(r'[a-z]');
                          final RegExp numberRegex = RegExp(r'[0-9]');

                          if(value.length < 8){
                            return 'La contraseña debe contener al menos 8 caracteres';
                          }
                          if (!specialCharacterRegex.hasMatch(value)) {
                            return 'La contraseña debe contener al menos un caracter especial';
                          }
                          if(!uppercaseLetterRegex.hasMatch(value)){
                            return 'La contraseña debe contener al menos una letra en mayúscula';
                          }
                          if(!lowercaseLetterRegex.hasMatch(value)){
                            return 'La contraseña debe contener al menos una letra en minuscula';
                          }
                          if(!numberRegex.hasMatch(value)){
                            return 'La contraseña debe contener al menos un número';
                          }
                          return null;
                        },
                      ),

                      if (_nuevoError != null)
                        Text(
                          _nuevoError!,
                          style: const TextStyle(
                            color: Colors.red,
                          ),
                        ),


                      Column(
                        children: <Widget>[

                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          ),

                          SizedBox(
                            width: double.infinity,
                            height: 55,

                            child: ElevatedButton(
                              onPressed: () async {
                                if(_formKey.currentState != null && _formKey.currentState!.validate()){
                                  final token = int.parse(_codigoController.text);
                                  final nuevo = _passwordController.text;

                                  setState(() {
                                    _isLoading = true;
                                  });

                                  try{
                                    PasswordChangeResponse response = await widget.authBloc.passwordChange(widget.email,nuevo,token);

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
                                    if(response.statusCode == 200){
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text('Se cambio correctamente la contraseña'),
                                        duration: Duration(seconds: 4),
                                        backgroundColor: Colors.green,
                                      ),
                                      );
                                    }
                                  }catch(e){
                                    print("Error al cambiar la contraseña: $e");
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

                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Por favor, complete el formulario correctamente.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
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
                                'Cambiar',
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
                                  pageBuilder: (context, animation, secondaryAnimation) => LoginPage(authBloc: authBloc,),
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