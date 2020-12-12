import 'package:flutter/material.dart';
import 'package:rgbify/theme/routes.dart';

class WelcomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //For crating dynamic page layout
    final mq = MediaQuery.of(context);
    final logo = Image.asset(
      "assets/rgbifylogo.png",
      fit: BoxFit.contain,
    );

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25),
      color: Colors.white,
      child: MaterialButton(
        //Button will always appear the same regardless of device
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text("Login",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
        onPressed: () {

        },
      ),
    );

    final registerButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25),
      color: Colors.white,
      child: MaterialButton(
        //Button will always appear the same regardless of device
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        child: Text("Register",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            )),
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.authRegister);
        },
      ),
    );

    final bluetoothButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(25),
      color: Colors.white,
      child: MaterialButton(
        minWidth: mq.size.width / 1.2,
        padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
        child: Text(
          "Bluetooth",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          Navigator.of(context).pushNamed(AppRoutes.controllers);
        },
      ),
    );

    final buttons = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        loginButton,
        Padding(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: registerButton,
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 70),
          child: bluetoothButton,
        )
      ],
    );

    return Scaffold(
      backgroundColor: Colors.orange,
      body: Padding(
        padding: EdgeInsets.all(36),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            logo,
            buttons,
          ],
        ),
      ),
    );
  }
}
