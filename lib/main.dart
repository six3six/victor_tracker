import 'dart:math';
import 'package:flutter/material.dart';
import 'package:tcp_scanner/tcp_scanner.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VictorTracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  final String addr = "cloud.huger.company";
  final int minecraftPort = 25565;

  bool searching = false;
  bool open = false;

  Image victorFace = Image.asset(
    "victor.png",
    fit: BoxFit.fitWidth,
  );

  void searchForMinecraftServer() async {
    print("refresh");
    setState(() {
      searching = true;
    });
    final result = await TCPScanner(addr, [minecraftPort]).scan();
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      searching = false;
      open = result.open.contains(minecraftPort);
    });
  }

  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this)
          ..repeat();
    searchForMinecraftServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("VictorTracker"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            searching
                ? AnimatedBuilder(
                    animation: _controller,
                    builder: (_, child) {
                      return Transform.rotate(
                        angle: _controller.value * 2 * pi,
                        child: child,
                      );
                    },
                    child: Image.asset(
                      "victor.png",
                      fit: BoxFit.fitWidth,
                    ),
                  )
                : victorFace,
            SizedBox(
              height: 40,
            ),
            Text("Victor est :", style: Theme.of(context).textTheme.headline4,),
            open ? Text("EN LIGNE") : Text("HORS LIGNE", style: Theme.of(context).textTheme.headline2),
            ElevatedButton(
              onPressed: () => searchForMinecraftServer(),
              child: Text("Rafraichir"),
            )
          ],
        ),
      ),
    );
  }
}
