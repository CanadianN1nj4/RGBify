import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class Commands extends StatefulWidget {
  @override
  _CommandsViewState createState() => _CommandsViewState();
}

class _CommandsViewState extends State<Commands> {
  bool controllerIsOn = true;

  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

  //Animation States
  bool isRainbowOn = false;
  bool isBlinkOn = false;
  bool isRainOn = false;

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }


  //Function to call API and toggle controller power
  Future<http.Response> togglePower(String setting) async {
    final http.Response response = await http.post(
      //TODO: update this with the url for server
      'https://localhost.com',
      headers: <String, String>{
        //TODO: configure this if needed
        'Content-Type': 'application/json; charset=UFT-8',
      },
    );
    //https.ok code
    if (response.statusCode == 200) {
      controllerIsOn = !controllerIsOn;
    } else {
      throw Exception('Failed to comunicate with server.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    final rainbowButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25),
      color: Colors.blueAccent,
      child: MaterialButton(
        //Button will always appear the same regardless of device
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text(isRainbowOn ? "On" : "Off",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        onPressed: () {
          setState(() {
            print("Rainbow Animation");
            isRainbowOn = !isRainbowOn;
            if (isRainbowOn) {
              isBlinkOn = false;
              isRainOn = false;
            }
          });
        },
      ),
    );

    final blinkButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25),
      color: Colors.blueAccent,
      child: MaterialButton(
        //Button will always appear the same regardless of device
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text(isBlinkOn ? "On" : "Off",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        onPressed: () {
          setState(() {
            print("Blink Animation");
            //Update states
            isBlinkOn = !isBlinkOn;
            if (isBlinkOn) {
              isRainbowOn = false;
              isRainOn = false;
            }
          });
        },
      ),
    );

    final rainButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25),
      color: Colors.blueAccent,
      child: MaterialButton(
        //Button will always appear the same regardless of device
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text(isRainOn ? "On" : "Off",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        onPressed: () {
          setState(() {
            print("Rain Animation");
            isRainOn = !isRainOn;
            if (isRainOn) {
              isBlinkOn = false;
              isRainbowOn = false;
            }
          });
        },
      ),
    );

    final setColorButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25),
      color: currentColor,
      child: MaterialButton(
        //Button will always appear the same regardless of device
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text("",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        onPressed: () {
          // raise the [showDialog] widget
          showDialog(
            context: context,
            child: AlertDialog(
              title: const Text('Pick a color!'),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: pickerColor,
                  onColorChanged: changeColor,
                  showLabel: true,
                  pickerAreaHeightPercent: 0.8,
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: const Text('Okay'),
                  onPressed: () {
                    print("New Color");
                    setState(() => currentColor = pickerColor);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        },
      ),
    );

    final powerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25),
      color: controllerIsOn ? Colors.green : Colors.red,
      child: MaterialButton(
        //Button will always appear the same regardless of device
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text(controllerIsOn ? "Power: On" : "Power: Off",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
        onPressed: () {
          setState(() {
            //update button state
            //TODO: Configure togglePower() and enable it here
            //togglePower("message");
            controllerIsOn = !controllerIsOn;
          });
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Quick Commands"),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
              padding: EdgeInsets.all(36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Rainbow Animation",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  rainbowButton,
                  SizedBox(height: 20),
                  Text("Blink Animation",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  blinkButton,
                  SizedBox(height: 20,),
                  Text("Rain Animation",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  rainButton,
                  SizedBox(height: 20),
                  Text("Current Color",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                  setColorButton,
                  SizedBox(height: 20),
                  powerButton,
                ],
              ))
        ],
      ),
    );
  }
}
