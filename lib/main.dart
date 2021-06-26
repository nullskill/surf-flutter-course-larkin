import 'package:flutter/material.dart';
import 'package:places/data/storage/app_storage.dart';
import 'package:places/env/build_config.dart';
import 'package:places/env/env.dart';
import 'package:places/ui/app/app.dart';
import 'package:places/util/consts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStorage.init();

  defineEnvironment(_setUpConfig());

  if (isReleaseMode) {
    debugPrint = (message, {wrapWidth}) {};
  }

  runApp(const App());
}

void defineEnvironment(BuildConfig buildConfig) {
  Environment.init(BuildType.dev, buildConfig);
}

BuildConfig _setUpConfig() {
  return BuildConfig(envString: 'Debug-mode');
}
