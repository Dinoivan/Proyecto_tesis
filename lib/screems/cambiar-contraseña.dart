import 'package:flutter/material.dart';
import 'package:proyecto_tesis/screems/login.dart';
import 'package:proyecto_tesis/blocs/auth_bloc.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController controller;

  PasswordFormField({required this.controller});

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
      obscureText: _obscureText,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2.0),
          borderSide: const BorderSide(color: Colors.black26),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2.0),
          borderSide: const BorderSide(color: Colors.black26),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2.0),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        hintText: "🔐 Contraseña",
        hintStyle: const TextStyle(
          color: Colors.black38,
          fontSize: 15,
        ),
        suffixIcon: GestureDetector(
          onTap: _togglePasswordVisibility,
          child: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
      ),
      keyboardType: TextInputType.text,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese una contraseña';
        }
        if (value.length > 20) {
          return 'La contraseña debe tener como máximo 20 caracteres';
        }
        if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(value)) {
          return 'La contraseña debe ser alfanumérica';
        }
        return null;
      },
    );
  }
}

class CambiarContra extends StatefulWidget {

  final AuthBloc authBloc;

  CambiarContra({required this.authBloc});

  @override
  _CambiarContraState createState() => _CambiarContraState();
}

class _CambiarContraState extends State<CambiarContra> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _verificationCodeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _verificationCodeError;
  String? _passwordError;
  String? _email;


  @override
  void dispose() {
    widget.authBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0), // Ajusta la altura según tus necesidades
          child: Container(), // Agrega un contenedor vacío para ajustar la altura
        ),

      ),

      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Cambiar Contraseña',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 30.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Image(
                image: AssetImage("assets/seguridad.png"),
              ),
              Text(
                'No estás sola',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Codigo de verficación:',
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: _verificationCodeController,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            borderSide: BorderSide(color: Colors.black26),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          hintText: "87655",
                          hintStyle: const TextStyle(
                            color: Colors.black38,
                            fontSize: 15,
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, ingrese el código de verificación';
                          }
                          if(value.length>6){
                            return 'solo se permite ingresar 6 numeros';
                          }
                          // Puedes agregar otras validaciones específicas aquí.
                          return null;
                        },
                      ),
                      if (_verificationCodeError != null)
                        Text(
                          _verificationCodeError!,
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      const SizedBox(height: 20),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Contraseña:',
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      PasswordFormField(controller: _passwordController),
                      if (_passwordError != null)
                        Text(
                          _passwordError!,
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      const Padding(
                        padding: EdgeInsets.only(top: 40),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: RaisedButton(
                          onPressed: () async {
                            if (_formKey.currentState != null && _formKey.currentState!.validate()) {
                              final verificationCode = _verificationCodeController.text;
                              final password = _passwordController.text;

                              String? email = "dinosoft1120@gmail.com";
                              print("email: $email");
                              if (email != null) { // Comprobar que no sea nulo
                                final verificationCodeInt = int.tryParse(verificationCode);
                                if (verificationCodeInt != null) { // Comprobar que se pueda convertir a entero
                                  String? result = await widget.authBloc.changePassword(email, verificationCodeInt, password);
                                  if (result != null) {
                                    final AuthBloc authBloc = AuthBloc();
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(authBloc: authBloc)));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Contraseña cambiada con éxito.'),
                                        duration: Duration(seconds: 4),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('El código de verificación debe ser un número válido.'),
                                      duration: Duration(seconds: 4),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error en la recuperación de datos.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                            else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Por favor, complete el formulario correctamente.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          color: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(color: Colors.black12),
                          ),
                          child: const Center(
                            child: Text(
                              'Cambiar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      ),
                      Column(
                        children: <Widget>[
                          MaterialButton(
                            minWidth: double.infinity,
                            onPressed: () {
                              final AuthBloc autoBloc = AuthBloc();
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage(authBloc: autoBloc,)));
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const <Widget>[
                                Text(
                                  "Acceder cuenta",
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
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