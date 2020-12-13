import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class ControllerScreenElement extends ListTile {
  BluetoothDevice device;
  String imagePath;

  GestureTapCallback onTap;
  GestureLongPressCallback onLongPress;

  ControllerScreenElement({
    this.device,
    this.onTap,
    this.onLongPress,
    this.imagePath,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        //margin: const EdgeInsets.all(5.0),
        color: Colors.transparent,
        alignment: Alignment.center,
        child: Container(
            constraints: BoxConstraints.expand(),
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 0,
                  blurRadius: 2,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            ),
            child: Container(
                margin: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: device.isConnected
                          ? Icon(Icons.bluetooth_connected,
                              color: Colors.greenAccent, size: 20)
                          : Icon(Icons.bluetooth_disabled,
                              color: Colors.red, size: 20),
                    ),
                    Container(
                      height: 30,
                    ),
                    Opacity(
                      opacity: 0.5,
                      child: Icon(
                        Icons.wb_incandescent,
                        color: Colors.blueGrey,
                        size: 40,
                      ),
                    ),
                    Container(
                      height: 10,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text("RGBify",
                          style: GoogleFonts.alata(
                            fontSize: 15,
                          )),
                    ),
                  ],
                ))),
      ),
    );
  }

  static TextStyle _computeTextStyle(int rssi) {
    return TextStyle(color: Colors.greenAccent[700]);
  }

  static TextStyle _titleStyle() {
    return TextStyle(fontSize: 25, fontWeight: FontWeight.bold);
  }
}
