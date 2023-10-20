import 'package:flutter/material.dart';

class IconButtonWidget extends StatefulWidget {
  const IconButtonWidget({super.key});

  @override
  State<IconButtonWidget> createState() => _IconButtonWidgetState();
}

class _IconButtonWidgetState extends State<IconButtonWidget> {
  double _speakerVol = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text("Control de Volumen"),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Slider(
                value: _speakerVol,
                onChanged: (newValue) {
                  setState(() {
                    _speakerVol = newValue;
                  });
                },
                min: 0,
                max: 100,
                divisions: 10, // Puedes ajustar este valor
                label: "Volumen",
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_speakerVol < 100) {
                          _speakerVol += 10;
                        }
                      });
                    },
                    icon: Icon(Icons.volume_up),
                    iconSize: 50.0,
                    color: Colors.lightBlue,
                    tooltip: "Subir volumen de a 10",
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        if (_speakerVol > 0) {
                          _speakerVol -= 10;
                        }
                      });
                    },
                    icon: Icon(Icons.volume_down),
                    iconSize: 50.0,
                    color: Colors.lightBlue,
                    tooltip: "Bajar volumen de a 10",
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