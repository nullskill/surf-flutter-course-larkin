import 'package:flutter/material.dart';
import 'package:places/bloc/base.dart';

class BlocProvider<T extends Bloc> extends StatefulWidget {
  const BlocProvider({
    @required this.bloc,
    @required this.child,
    Key key,
  }) : super(key: key);

  final Widget child;
  final T bloc;

  static T of<T extends Bloc>(BuildContext context) {
    final BlocProvider<T> provider =
        context.findAncestorWidgetOfExactType<BlocProvider<T>>();
    return provider.bloc;
  }

  @override
  State createState() => _BlocProviderState();
}

class _BlocProviderState extends State<BlocProvider> {
  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    widget?.bloc?.dispose();
    super.dispose();
  }
}
