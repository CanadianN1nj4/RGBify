import 'package:flutter/material.dart';
import 'package:rgbify/model/Controller.dart';

class Controllers extends StatefulWidget {
  Controllers();

  @override
  ControllersViewState createState() => ControllersViewState();
}

class ControllersViewState extends State<Controllers> {
  ControllersViewState();

  //Stores the controllers under the users account for displaying on list
  List<Controller> controllers = <Controller>[];

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
                itemCount: controllers.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        //TODO: Open websocket connection and communicate with ESP32 to change light color
                      },
                      title: Text(controllers[index].location),
                      leading: CircleAvatar(
                        child: Image.asset('assets/rgbifylogo.png'),
                        backgroundColor: Colors.black,
                      ),
                      subtitle: Text(
                        controllers[index].IPAddress,
                      ),
                      trailing: Icon(
                        Icons.delete,
                      ),
                      onLongPress: () {
                        setState(() {
                          controllers.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                setState(() {
                  controllers
                      .add(new Controller("Living Room", "192.168.37.4"));
                });
              },
              tooltip: 'Increment',
              child: Icon(Icons.add),
            )
          ],
        ));
  }
}
