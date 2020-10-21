import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class Commands extends StatefulWidget{
  @override
  _CommandsViewState createState() => _CommandsViewState();
}

class _CommandsViewState extends State<Commands>{

  bool controllerIsOn = false;

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
        child: Text( controllerIsOn? "On" : "Off",
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
        title: Text(
          "Controller Commands"
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
          ),
          Center(
            child: powerButton,
          )
        ]
      ),
    );

  }
  
}