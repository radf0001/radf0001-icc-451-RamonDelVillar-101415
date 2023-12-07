import 'package:flutter/material.dart';
import 'package:personalizado/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 1500), () {}); // Espera 1.5 segundos
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage())); // Cambia a la pantalla principal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('lib/images/logo.png'), // Reemplaza con el logo de tu aplicación
      ),
    );
  }
}