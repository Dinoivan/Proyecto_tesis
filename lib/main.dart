import 'package:flutter/material.dart';

void main() {

  runApp(const MyApp());
}

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
        ),
        home: const ProviderDemoScreen(),

      );
  }
}

class ProviderDemoScreen extends StatefulWidget {
  const ProviderDemoScreen({Key? key}) : super(key: key);

  @override
  _ProviderDemoScreenState createState() => _ProviderDemoScreenState();
}

class _ProviderDemoScreenState extends State<ProviderDemoScreen> {

  @override
  Widget build(BuildContext context) {

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
                label: Text('Empezar'),
                backgroundColor: Colors.blueAccent,
                splashColor: Colors.greenAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                onPressed: () {

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
                label: Text('Iniciar Sesión'),
                backgroundColor: Colors.blueAccent,
                splashColor: Colors.greenAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                ),
                onPressed: () {

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


