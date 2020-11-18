import 'package:flutter/material.dart';
import 'package:rgbify/model/Controller.dart';
import 'package:rgbify/theme/routes.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';
import './BluetoothDeviceListEntry.dart';
import 'package:rgbify/views/ChatPage.dart';

class Controllers extends StatefulWidget {

  final bool checkAvailability;

  const Controllers({this.checkAvailability = true});

  @override
  ControllersViewState createState() => ControllersViewState();
}

enum _DeviceAvailability {
    no,
    maybe,
    yes,
}

class _DeviceWithAvailability extends BluetoothDevice {
  BluetoothDevice device;
  _DeviceAvailability availability;
  int rssi;

  _DeviceWithAvailability(this.device, this.availability, [this.rssi]);
}

class ControllersViewState extends State<Controllers> {

  List<_DeviceWithAvailability> devices = List<_DeviceWithAvailability>();

    // Availability
  StreamSubscription<BluetoothDiscoveryResult> _discoveryStreamSubscription;
  bool _isDiscovering;

  ControllersViewState();

  //Stores the controllers under the users account for displaying on list
  List<Controller> controllers = <Controller>[];



  @override
  void initState() {
    super.initState();

    _isDiscovering = widget.checkAvailability;

    if (_isDiscovering) {
      _startDiscovery();
    }

    // Setup a list of the bonded devices
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        devices = bondedDevices
            .map(
              (device) => _DeviceWithAvailability(
                device,
                widget.checkAvailability
                    ? _DeviceAvailability.maybe
                    : _DeviceAvailability.yes,
              ),
            )
            .toList();
      });
    });
  }

  



  void _restartDiscovery() {
    setState(() {
      _isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _discoveryStreamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        Iterator i = devices.iterator;
        while (i.moveNext()) {
          var _device = i.current;
          if (_device.device == r.device) {
            _device.availability = _DeviceAvailability.yes;
            _device.rssi = r.rssi;
          }
        }
      });
    });

    _discoveryStreamSubscription.onDone(() {
      setState(() {
        _isDiscovering = false;
      });
    });

  }

  void _startChat(BuildContext context, BluetoothDevice server) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return ChatPage(server: server);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text(
            "My Controllers",
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(20),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        //TODO: Open websocket connection and communicate with ESP32 to change light color
                        //Navigator.of(context).pushNamed(AppRoutes.commands);
                        //Navigator.of(context).pop(devices[index].device);
                        _startChat(context, devices[index].device);
                      },
                      title: Text(devices[index].device.name),
                      leading: CircleAvatar(
                        child: Image.asset('assets/controller.png'),
                        backgroundColor: Colors.white,
                      ),
                      subtitle: Text(
                        "devices[index].address.toString()",
                      ),
                      trailing: Icon(
                        Icons.delete,
                      ),
                      onLongPress: () {
                        setState(() {
                          //TODO:Delete the currently long pressed item instead of the last one
                          //TODO: find a better way to remove items
                          devices.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(300, 0, 0, 20),
                  child: FloatingActionButton(
                    onPressed: () {
                      setState(() {
                        //controllers.add(new Controller("Living Room", "192.168.37.4"));
                        Navigator.of(context).pushNamed(AppRoutes.addController);
                      });
                    },
                    child: Icon(Icons.add),
                    backgroundColor: Colors.orange,
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}


/*
import 'package:flutter/material.dart';
import 'package:rgbify/model/Controller.dart';
import 'package:rgbify/theme/routes.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';
import './BluetoothDeviceListEntry.dart';


class Controllers extends StatefulWidget {

  final bool checkAvailability;

  const Controllers({this.checkAvailability = true});

  @override
  ControllersViewState createState() => ControllersViewState();
}

enum _DeviceAvailability {
    no,
    maybe,
    yes,
}

class _DeviceWithAvailability extends BluetoothDevice {
  BluetoothDevice device;
  _DeviceAvailability availability;
  int rssi;

  _DeviceWithAvailability(this.device, this.availability, [this.rssi]);
}

class ControllersViewState extends State<Controllers> {

  List<_DeviceWithAvailability> devices = List<_DeviceWithAvailability>();

    // Availability
  StreamSubscription<BluetoothDiscoveryResult> _discoveryStreamSubscription;
  bool _isDiscovering;

  ControllersViewState();

  //Stores the controllers under the users account for displaying on list
  List<Controller> controllers = <Controller>[];



  @override
  void initState() {
    super.initState();

    _isDiscovering = widget.checkAvailability;

    if (_isDiscovering) {
      _startDiscovery();
    }

    // Setup a list of the bonded devices
    FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        devices = bondedDevices
            .map(
              (device) => _DeviceWithAvailability(
                device,
                widget.checkAvailability
                    ? _DeviceAvailability.maybe
                    : _DeviceAvailability.yes,
              ),
            )
            .toList();
      });
    });
  }

  



  void _restartDiscovery() {
    setState(() {
      _isDiscovering = true;
    });

    _startDiscovery();
  }

  void _startDiscovery() {
    _discoveryStreamSubscription =
        FlutterBluetoothSerial.instance.startDiscovery().listen((r) {
      setState(() {
        Iterator i = devices.iterator;
        while (i.moveNext()) {
          var _device = i.current;
          if (_device.device == r.device) {
            _device.availability = _DeviceAvailability.yes;
            _device.rssi = r.rssi;
          }
        }
      });
    });

    _discoveryStreamSubscription.onDone(() {
      setState(() {
        _isDiscovering = false;
      });
    });








  }

  @override
  Widget build(BuildContext context) {
    List<BluetoothDeviceListEntry> list = devices
        .map((_device) => BluetoothDeviceListEntry(
              device: _device.device,
              rssi: _device.rssi,
              enabled: _device.availability == _DeviceAvailability.yes,
              onTap: () {
                Navigator.of(context).pop(_device.device);
              },
            ))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Select device'),
        actions: <Widget>[
          false
              ? FittedBox(
                  child: Container(
                    margin: new EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white,
                      ),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.replay),
                  onPressed: _restartDiscovery,
                )
        ],
      ),
      body: ListView(children: list),
    );
  }
}

*/