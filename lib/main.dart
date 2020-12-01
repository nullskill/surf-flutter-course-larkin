import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My first App",
      home: MyFirstStatefulWidget(),
    );
  }
}

class MyFirstStatelessWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Type getContextType() => context.runtimeType;

    print(getContextType());

    return Container(
      child: Center(
        child: Text("Hello!"),
      ),
    );
  }
}

class MyFirstStatefulWidget extends StatefulWidget {
  // Type getContextType() => context.runtimeType;

  @override
  _MyFirstStatefulWidgetState createState() => _MyFirstStatefulWidgetState();
}

class _MyFirstStatefulWidgetState extends State<MyFirstStatefulWidget> {
  @override
  Widget build(BuildContext context) {
    Type getContextType() => context.runtimeType;

    print(getContextType());

    return Container(
      child: Center(
        child: Text("Hello!"),
      ),
    );
  }
}
