import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:google_fonts/google_fonts.dart';


class PairWifi extends StatefulWidget {
  final BluetoothDevice server;

  const PairWifi({this.server});

  @override
  _PairWifi createState() => new _PairWifi();
}

class _Message {
  int whom;
  String text;

  _Message(this.whom, this.text);
}

class _PairWifi extends State<PairWifi> {
  static final clientID = 0;
  BluetoothConnection connection;

  List<_Message> messages = List<_Message>();
  String _messageBuffer = '';

  final TextEditingController textEditingController =
      new TextEditingController();
  final ScrollController listScrollController = new ScrollController();

  bool isConnecting = true;
  bool get isConnected => connection != null && connection.isConnected;

  bool isDisconnecting = false;

  @override
  void initState() {
    super.initState();

    BluetoothConnection.toAddress(widget.server.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;
      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });

      connection.input.listen(_onDataReceived).onDone(() {
        // Example: Detect which side closed the connection
        // There should be `isDisconnecting` flag to show are we are (locally)
        // in middle of disconnecting process, should be set before calling
        // `dispose`, `finish` or `close`, which all causes to disconnect.
        // If we except the disconnection, `onDone` should be fired as result.
        // If we didn't except this (no flag set), it means closing by remote.
        if (isDisconnecting) {
          print('Disconnecting locally!');
        } else {
          print('Disconnected remotely!');
        }
        if (this.mounted) {
          setState(() {});
        }
      });
    }).catchError((error) {
      print('Cannot connect, exception occured');
      print(error);
    });
  }

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and disconnect
    if (isConnected) {
      isDisconnecting = true;
      connection.dispose();
      connection = null;
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding( padding: EdgeInsets.all(50),
              child:
        Column(
          children: <Widget>[
            Text(
              "Enter Wi-Fi",
              style:( GoogleFonts.alata( fontSize: 35,)
              )
            ),
            Text(
              "Information",
              style:( GoogleFonts.alata( fontSize: 35,))
            ),
            const Divider(
              color: Colors.grey,
              height: 30,
              thickness: 1,
              indent: 0,
              endIndent: 0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 50.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("SSID: ", textAlign: TextAlign.left,),
              )
            ),
            TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Network SSID'
              ),
            ),
            Padding(
            padding: EdgeInsets.only(top: 50.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("PASSWORD: ", textAlign: TextAlign.left,),
              )
            ),
            TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Enter Network Password'
              ),
            ),
          ]
        )
        )
      ),
      bottomNavigationBar: Row(
        children: <Widget>[
          Expanded(
            child:
            Container(
              decoration: new BoxDecoration(
                color: Colors.grey,
                borderRadius: new BorderRadius.only(topLeft: Radius.circular(10))
              ),
              height: 60,
              child: FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("SKIP", style: TextStyle(color: Colors.white)),
              ),
          ),
          ),
          Expanded(child:
            Container(
              decoration: new BoxDecoration(
                color: Colors.green[300],
                borderRadius: new BorderRadius.only(topRight: Radius.circular(10))
              ),
              height: 60,
              child: FlatButton(
                onPressed: () {
                  _sendMessage("text");
                  Navigator.pop(context);
                },
                child: Text("CONNECT", style: TextStyle(color: Colors.white)),
              ),
          ),
          )
        ]
      )
    );
  }

  void _onDataReceived(Uint8List data) {
    // Allocate buffer for parsed data
    int backspacesCounter = 0;
    data.forEach((byte) {
      if (byte == 8 || byte == 127) {
        backspacesCounter++;
      }
    });
    Uint8List buffer = Uint8List(data.length - backspacesCounter);
    int bufferIndex = buffer.length;

    // Apply backspace control character
    backspacesCounter = 0;
    for (int i = data.length - 1; i >= 0; i--) {
      if (data[i] == 8 || data[i] == 127) {
        backspacesCounter++;
      } else {
        if (backspacesCounter > 0) {
          backspacesCounter--;
        } else {
          buffer[--bufferIndex] = data[i];
        }
      }
    }

    // Create message if there is new line character
    String dataString = String.fromCharCodes(buffer);
    int index = buffer.indexOf(13);
    if (~index != 0) {
      setState(() {
        messages.add(
          _Message(
            1,
            backspacesCounter > 0
                ? _messageBuffer.substring(
                    0, _messageBuffer.length - backspacesCounter)
                : _messageBuffer + dataString.substring(0, index),
          ),
        );
        _messageBuffer = dataString.substring(index);
      });
    } else {
      _messageBuffer = (backspacesCounter > 0
          ? _messageBuffer.substring(
              0, _messageBuffer.length - backspacesCounter)
          : _messageBuffer + dataString);
    }
  }

  void _sendMessage(String text) async {
    text = text.trim();
    textEditingController.clear();

    if (text.length > 0) {
      try {
        connection.output.add(utf8.encode(text + "\r\n"));
        await connection.output.allSent;

        setState(() {
          messages.add(_Message(clientID, text));
        });

        Future.delayed(Duration(milliseconds: 333)).then((_) {
          listScrollController.animateTo(
              listScrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 333),
              curve: Curves.easeOut);
        });
      } catch (e) {
        // Ignore error, but notify state
        setState(() {});
      }
    }
  }
}