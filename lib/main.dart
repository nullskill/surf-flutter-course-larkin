import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:places/data/storage/app_storage.dart';
import 'package:places/ui/app/app.dart';
import 'package:places/util/consts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStorage.init();

  if (isReleaseMode) {
    debugPrint = (message, {wrapWidth}) {};
  }

  runApp(
    DevicePreview(
      enabled: !isReleaseMode,
      builder: (_) => const App(),
    ),
  );
}
