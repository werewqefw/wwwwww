// @dart=2.9
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:udp/udp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VIS-Door App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'VIS-Door App'),
    );
  }
}

void onLed() async {
  print("on command");
  var sender = await UDP.bind(Endpoint.any(port: Port(4210)));
  var dataLength =
      await sender.send('on'.codeUnits, Endpoint.broadcast(port: Port(4210)));

  stdout.write('$dataLength bytes sent.');
  sender.close();
}

void offLed() async {
  print("off command");
  var sender = await UDP.bind(Endpoint.any(port: Port(4210)));
  var dataLength =
      await sender.send('off'.codeUnits, Endpoint.broadcast(port: Port(4210)));

  stdout.write('$dataLength bytes sent.');
  sender.close();
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ToggleButton(),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class ToggleButton extends StatefulWidget {
  final IconData deviceIcon;
  final double scale;
  final Color activeColor;

  const ToggleButton({
    this.activeColor = Colors.blue,
    this.deviceIcon = Icons.lock_open,
    this.scale = 0.7,
  });
  @override
  _ToggleButtonState createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<ToggleButton>
    with TickerProviderStateMixin {
  bool pressed = false;
  bool deviceState = false;

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;
    return Center(
      // ignore: sized_box_for_whitespace
      child: Container(
        width: deviceWidth * widget.scale,
        height: deviceHeight * widget.scale,
        child: NeumorphicButton(
          // string to show when long press
          tooltip: deviceState ? "turn off device" : "open the lock",
          pressed: (deviceState) ? true : false,
          // ignore: sort_child_properties_last
          child: Icon(
            (!deviceState) ? Icons.lock : Icons.lock_open,
            size: deviceWidth * 0.2,
            color: deviceState ? widget.activeColor : Colors.grey,
          ),
          onPressed: () {
            (!deviceState) ? onLed() : offLed();
            setState(() {
              deviceState = !deviceState;
            });
            Future.delayed(Duration(seconds: 4), () {
              setState(() {
                deviceState = !deviceState;
              });
            });
          },
          style: NeumorphicStyle(
            color: Color(0XFFedf4fd),
            depth: deviceState ? -10 : 10,
            boxShape: NeumorphicBoxShape.circle(),
            intensity: 0.5,
            shadowLightColorEmboss: Colors.yellow,
          ),
        ),
      ),
    );
  }
}
