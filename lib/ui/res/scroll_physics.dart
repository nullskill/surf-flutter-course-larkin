import 'dart:io';

import 'package:flutter/widgets.dart';

final physics =
    Platform.isAndroid ? ClampingScrollPhysics() : BouncingScrollPhysics();
