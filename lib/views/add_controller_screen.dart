import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rgbify/model/Controller.dart';
import 'package:rgbify/theme/routes.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import './BluetoothDeviceListEntry.dart';
import './pair_wifi_screen.dart';

class AddController extends StatefulWidget {
  @override 
  _AddControllerViewState createState() => _AddControllerViewState();
}

class _AddControllerViewState extends State<AddController> {

   StreamSubscription<BluetoothDiscoveryResult> _streamSubscription;
  List<BluetoothDiscoveryResult> results = List<BluetoothDiscoveryResult>();
  bool isDiscovering;

  _AddControllerViewState();

  @override
  void initState() {
    super.initState();

    isDiscovering = true;
    if (isDiscovering) {
      _startDiscovery();
    }
  }

  void _restartDiscovery() {
    setState(() {
      results.clear();
      isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _streamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        results.add(r);
      });
    });

    _streamSubscription.onDone(() {
      setState(() {
        isDiscovering = false;
      });
    });
  }

  // @TODO . One day there should be `_pairDevice` on long tap on something... ;)

  @override
  void dispose() {
    // Avoid memory leak (`setState` after dispose) and cancel discovery
    _streamSubscription?.cancel();

    super.dispose();
  }
  void _startChat(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return PairWifi(server:server);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isDiscovering
            ? Text('Discovering devices')
            : Text('Discovered devices'),
        actions: <Widget>[
          isDiscovering
              ? FittedBox(
                  child: Container(
                    margin: new EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.replay),
                  onPressed: _restartDiscovery,
                )
        ],
      ),
      body: ListView.builder(
        itemCount: results.length,
        itemBuilder: (BuildContext context, index) {
          BluetoothDiscoveryResult result = results[index];
          return BluetoothDeviceListEntry(
            device: result.device,
            rssi: result.rssi,
            onTap:  () async {
              bool bonded = false;
              bonded = await FlutterBluetoothSerial.instance.bondDeviceAtAddress(result.device.address);
              print('Bonding with ${result.device.address} has ${bonded ? 'succed' : 'failed'}.');
              //return Navigator.of(context).pop();
              //return Navigator.pushReplacementNamed(context, AppRoutes.pairWifi);
              return _startChat(context, results[index].device);


            },
          );
        },
      ),
    );
  }
}
