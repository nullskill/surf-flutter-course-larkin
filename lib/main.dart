import 'package:flutter/material.dart';

import 'package:places/ui/screens/sight_list_screen.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My first App",
      home: SightListScreen(),
    );
  }
}

// class MyFirstStatelessWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Type getContextType() => context.runtimeType;
//
//     print(getContextType());
//
//     return Container(
//       child: Center(
//         child: Text("Hello!"),
//       ),
//     );
//   }
// }

// class MyFirstStatefulWidget extends StatefulWidget {
//   // Type getContextType() => context.runtimeType;
//
//   @override
//   _MyFirstStatefulWidgetState createState() => _MyFirstStatefulWidgetState();
// }
//
// class _MyFirstStatefulWidgetState extends State<MyFirstStatefulWidget> {
//   @override
//   Widget build(BuildContext context) {
//     Type getContextType() => context.runtimeType;
//
//     print(getContextType());
//
//     return Container(
//       child: Center(
//         child: Text("Hello!"),
//       ),
//     );
//   }
// }
