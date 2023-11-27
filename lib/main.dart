/*Se importa el paquete 'flutter/material.dart', que proporciona widgets y
herramientas para crear interfaces de usuario en Flutter
 */
import 'package:flutter/material.dart';
import 'package:proyecto_tesis/screems/register.dart';
import 'package:proyecto_tesis/blocs/register_bloc.dart';
import 'package:proyecto_tesis/screems/login.dart';
import 'package:proyecto_tesis/blocs/auth_bloc.dart';

/*
Esta función es el punto de entrada de la aplicación. Llama a 'runApp()' con
una instancia de 'MyApp', que es el widget raíz de la aplicación
 */

final registerBloc = RegisterBloc();
final authBloc = AuthBloc();


void main() {

  runApp(const MyApp());
}

/*
MyApp es un widget que configura y define la estructura general de la aplicación
. En su método buil(), se creará una instancia de 'MaterialApp', que es
un widget que configura la apariencia  y el comportamiento de la aplicación.
Estable el título de la aplicación, el tema(en este caso, el color principal es azul)
y define la pantalla inicial como 'ProviderDemoScreem
 */

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return
      MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
            bodyText2: TextStyle(fontFamily: 'Roboto'),
          ),
        ),
        home: const ProviderDemoScreen(),

      );
  }
}

/*
 ProviderDemoScreen es otro widgetque representa la pantalla de
 bienenida de la aplicación. Esta clase extiende 'StatefulWidget, lo que
 significa que su estado puede cambiar con el tiempo. El estado esta definido
 en _ProviderDemoScreemState
 */

class ProviderDemoScreen extends StatefulWidget {
  const ProviderDemoScreen({Key? key}) : super(key: key);

  @override
  _ProviderDemoScreenState createState() => _ProviderDemoScreenState();
}

/*
En esta clase se construye la interfaz de usuario de la pantalla de bienvenida.
En su método 'build()', se crea un widget 'Scaffold, que proporciona la
estructura básica de una pantalla de la aplicación. Dentero del 'Scaffold, se
encuentra varios widget, como texto, imágenes y botones, que se organizan
en un columna vertical utilizando el widget 'Column'
 */

class _ProviderDemoScreenState extends State<ProviderDemoScreen> {

  @override
  Widget build(BuildContext context) {
    print("AuthBloc hashCode: ${authBloc.hashCode}");
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget> [
            const Text(
              'Bienvenida',
              style: TextStyle(color: Colors.blueAccent,fontSize: 40.0,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10),
            const Image(
              image: AssetImage("assets/seguridad.png"),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300, // Ancho igual al ancho de la pantalla
              child: FloatingActionButton.extended(
                label: const Text('Empezar'),
                backgroundColor: Colors.blueAccent,
                splashColor: Colors.greenAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Register(bloc: registerBloc),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            RichText(text: const TextSpan(
              children: [
                TextSpan(
                  text: '¿Ya tienes una cuenta?',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontFamily: 'Karla',
                    color: Colors.blueAccent,
                  ),
                ),
              ],
            ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 300, // Ancho igual al ancho de la pantalla
              child: FloatingActionButton.extended(
                label: const Text('Iniciar Sesión'),
                backgroundColor: Colors.blueAccent,
                splashColor: Colors.greenAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginPage(authBloc: authBloc,),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


