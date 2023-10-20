import 'package:flutter/material.dart';
import 'icon_button_widget.dart';


void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IconButtonWidget(),
      // theme: ThemeData(
      //   colorScheme: ColorScheme.dark()
      // ),
    );
  }
}

