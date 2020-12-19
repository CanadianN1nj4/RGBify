import 'package:flutter/material.dart';
import 'package:rgbify/model/Controller.dart';
import 'package:rgbify/theme/routes.dart';
import 'package:provider/provider.dart';
import 'package:rgbify/model/AuthenticationService.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'dart:async';
import './BluetoothDeviceListEntry.dart';
import 'package:rgbify/views/ChatPage.dart';
import 'package:rgbify/Widgets/ControllerScreenElement.dart';

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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            actions: <Widget>[
              IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: "Sign Out",
                  onPressed: () {
                    context.read<AuthenticationService>().signOut();
                  }),
            ],
            expandedHeight: 220.0,
            floating: true,
            pinned: true,
            snap: true,
            elevation: 50,
            backgroundColor: Colors.green,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.2, 0.5, 0.8],
                    colors: [Colors.green, Colors.blue, Colors.red]),
              ),
              child: FlexibleSpaceBar(
                centerTitle: true,
                title: Text('RGBify',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    )),
              ),
            ),
          ),
          new SliverPadding(
              padding: EdgeInsets.all(30),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200.0,
                  mainAxisSpacing: 10.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 0.9,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return ControllerScreenElement(
                      device: devices[index].device,
                      onTap: () {
                        _startChat(context, devices[index].device);
                      },
                      onLongPress: () {
                        setState(() {
                          devices.removeAt(index);
                        });
                      },
                      imagePath: "assets/Images/led_strip.svg",
                    );
                  },
                  childCount: devices.length,
                ),
              )),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: new BoxDecoration(
            color: Colors.green[300],
            borderRadius: new BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        height: 60,
        child: FlatButton(
          onPressed: () {
            setState(() {
              //controllers.add(new Controller("Living Room", "192.168.37.4"));
              Navigator.of(context).pushNamed(AppRoutes.addController);
            });
          },
          child: Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
