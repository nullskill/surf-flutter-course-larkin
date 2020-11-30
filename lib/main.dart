import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyFirstStatefulWidget(),
    );
  }
}

// int callsCount = 0;

// class MyFirstStatelessWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     callsCount++;

//     print("build called: $callsCount");

//     return Container(
//       child: Center(
//         child: Text("Hello!"),
//       ),
//     );
//   }
// }

class MyFirstStatefulWidget extends StatefulWidget {
  @override
  _MyFirstStatefulWidgetState createState() => _MyFirstStatefulWidgetState();
}

class _MyFirstStatefulWidgetState extends State<MyFirstStatefulWidget> {
  int callsCount = 0;

  @override
  Widget build(BuildContext context) {
    callsCount++;

    print("build called: $callsCount");

    return Container(
      child: Center(
        child: Text("Hello!"),
      ),
    );
  }
}
