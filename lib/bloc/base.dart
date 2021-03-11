import 'package:flutter/foundation.dart';

// ignore: one_member_abstracts
abstract class Bloc {
  void dispose();
}

abstract class BlocEvent<E, T> {
  @required
  E event;

  T data;
}
