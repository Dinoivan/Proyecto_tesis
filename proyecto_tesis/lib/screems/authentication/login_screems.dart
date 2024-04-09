import 'package:flutter/material.dart';
import 'package:proyecto_tesis/screems/register/register.dart';
import 'package:proyecto_tesis/screems/main_screems/home.dart';
import 'package:proyecto_tesis/blocs/autentication/auth_bloc.dart';
import 'package:proyecto_tesis/blocs/register/register_bloc.dart';
import 'package:proyecto_tesis/screems/authentication/password_recovery_screem.dart';

class PasswordFormField extends StatefulWidget {
  final TextEditingController passwordControler;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PasswordFormField({required this.passwordControler});

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
      controller: widget.passwordControler,
      obscureText: _obscureText,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2.0),
          borderSide: const BorderSide(color: Colors.black26, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2.0),
          borderSide: const BorderSide(color: Colors.black26, width: 2.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2.0),
          borderSide: const BorderSide(color: Colors.blue, width: 2.0),
        ),
        labelText: widget.passwordControler.text.isEmpty ? "Contraseña": "",
        labelStyle: const TextStyle(
          color: Colors.black,
        ),
        hintText:  widget.passwordControler.text.isEmpty ? "" : "**********",
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
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
      ),
      keyboardType: TextInputType.text,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, ingrese contraseña';
        }

        if(value.length>20){
          return 'La contraseña debe contener como maximo 20 caracteres';
        }

        return null;
      },
    );
  }
}

class LoginPage extends StatefulWidget {

  final AuthBloc authBloc;

  LoginPage({required this.authBloc});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: Image(
                      image: AssetImage("assets/principal_.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.only(left: 40.0,top: 10),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

                SizedBox(height: 10,),
                Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 40), // Solo
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
                          borderRadius: BorderRadius.circular(2.0),
                          borderSide: BorderSide(color: Colors.black26,width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2.0),
                        borderSide: BorderSide(color: Colors.black26, width: 2.0),
                      ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.0),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                    ),
                    labelText: _emailController.text.isEmpty ? "Correo": "",
                    labelStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    hintText:  _emailController.text.isEmpty ? "": "Correo",
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

                    const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.centerLeft,
                    ),
                    PasswordFormField(passwordControler: _passwordController),

                    Column(
                      children: <Widget>[
                        MaterialButton(
                          minWidth: double.infinity,
                          onPressed: ()  {
                            final AuthBloc authBloc = AuthBloc();

                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) => PasswordRecovery(authBloc: authBloc),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                                transitionDuration: Duration(milliseconds: 5), // Duración de la transición
                              ),
                            );

                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text(
                          "¿Olvidaste tu contraseña?",
                          style: TextStyle(
                            color: Color(0xFF938CDF),
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30,),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () async {
                        if(_formKey.currentState != null && _formKey.currentState!.validate()){
                          final email = _emailController.text;
                          final password = _passwordController.text;

                          setState(() {
                            _isLoading = true;
                          });

                          try{
                            int? resultado = await widget.authBloc.login(email, password);

                            print("Resultado: $resultado");

                            if(resultado == 200){
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => Home(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    );
                                  },
                                  transitionDuration: Duration(milliseconds: 5),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Su inicio de sesión fue exitoso'),
                                  duration: Duration(seconds: 4),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            }else{
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error al iniciar sesión verifica sus credenciales o correo electronico'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }catch(e){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error de servicio'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          } finally{
                            setState(() {
                              _isLoading = false;
                            });
                          }

                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF7A72DE)), //
                        shape: MaterialStateProperty.all<OutlinedBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40.0),

                          ),
                        ),

                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(vertical: 10.0), // Espacio interno arriba y abajo
                        ),
                      ) ,

                      child: _isLoading ? CircularProgressIndicator() :  Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0,
                        ),
                      ),

                    ),

                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  ),
                  MaterialButton(
                    minWidth: double.infinity,
                    onPressed: () {
                      final RegisterBloc registerBloc = RegisterBloc();
                      Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => Register(registerBloc: registerBloc,),
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

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: '¿Aún no tienes una cuenta? ',
                            style: TextStyle(
                              color: Colors.black, // Texto "¿Aún no tienes una cuenta?" de color negro
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Crear cuenta',
                                style: TextStyle(
                                  color: Color(0xFF938CDF), // Texto "Crear cuenta" de color morado
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.0,
                                  decoration: TextDecoration.underline, // Subrayado para indicar que es un enlace
                                ),
                              ),
                            ],
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