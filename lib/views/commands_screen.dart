import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


class Commands extends StatefulWidget{
  @override
  _CommandsViewState createState() => _CommandsViewState();
}

class _CommandsViewState extends State<Commands>{

  bool controllerIsOn = true;

  // create some values
  Color pickerColor = Color(0xff443a49);
  Color currentColor = Color(0xff443a49);

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
        'Content-Type' : 'application/json; charset=UFT-8',
      },
    );
    //https.ok code
    if(response.statusCode == 200){
      controllerIsOn = !controllerIsOn;
    } else {
      throw Exception ('Failed to comunicate with server.');
    }

  }

  @override
  Widget build(BuildContext context) {

    final mq = MediaQuery.of(context);

    final powerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25),
      color: controllerIsOn? Colors.green : Colors.red,
      child: MaterialButton(
        //Button will always appear the same regardless of device
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text( controllerIsOn? "Power: On" : "Power: Off",
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

    final rainbowButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25),
      color: Colors.blueAccent,
      child: MaterialButton(
        //Button will always appear the same regardless of device
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text( "Rainbow Animation",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        onPressed: () {
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
        child: Text( "Color Picker",
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

    final blinkButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25),
      color: Colors.blueAccent,
      child: MaterialButton(
        //Button will always appear the same regardless of device
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text( "Blink Rate",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 30.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        onPressed: () {
        },
      ),
    );


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          "Quick Commands"
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                rainbowButton,
                SizedBox(height: 30),
                blinkButton,
                SizedBox(height: 30),
                setColorButton,
                SizedBox(height: 100),
                powerButton,
              ],
            )
          )
        ],
      ),
    );

  }
  
}