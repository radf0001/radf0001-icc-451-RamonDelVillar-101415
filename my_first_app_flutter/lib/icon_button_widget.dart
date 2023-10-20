import 'package:flutter/material.dart';

class IconButtonWidget extends StatefulWidget {
  const IconButtonWidget({super.key});

  @override
  State<IconButtonWidget> createState() => _IconButtonWidgetState();
}

class _IconButtonWidgetState extends State<IconButtonWidget> {
  double _speakerVol = 0.0;
  Color _backgroundColor = Colors.red; // Color de fondo azul inicial

  void _updateBackgroundColor() {
    // Ajustar la opacidad del color de fondo según el valor de _speakerVol
    double opacity = (_speakerVol / 100).clamp(0.0, 1.0); // Asegurarse de que esté en el rango 0-1
    _backgroundColor = Colors.red.withOpacity(opacity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Control de Volumen"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(50.0),
          color: _backgroundColor, // Color de fondo con opacidad dinámica
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Slider(
                value: _speakerVol,
                onChanged: (newValue) {
                  setState(() {
                    _speakerVol = newValue;
                    _updateBackgroundColor(); // Actualizar el color de fondo
                  });
                },
                min: 0,
                max: 100,
                divisions: 10,
                label: "Volumen",
                activeColor: Colors.green,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_speakerVol > 0) {
                          _speakerVol -= 10;
                          _updateBackgroundColor(); // Actualizar el color de fondo
                        }
                      });
                    },
                    icon: Icon(Icons.volume_down),
                    iconSize: 50.0,
                    color: Colors.green,
                    tooltip: "Bajar volumen de a 10",
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_speakerVol < 100) {
                          _speakerVol += 10;
                          _updateBackgroundColor(); // Actualizar el color de fondo
                        }
                      });
                    },
                    icon: Icon(Icons.volume_up),
                    iconSize: 50.0,
                    color: Colors.green,
                    tooltip: "Subir volumen de a 10",
                  ),
                ],
              ),
              Text("Volumen de Audio: ${_speakerVol.toStringAsFixed(1)}", style: TextStyle(fontSize: 20.0),),
            ],
          ),
        ),
      ),
    );
  }
}
