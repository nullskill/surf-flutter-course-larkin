import 'package:flutter/material.dart';
import 'package:places/data/storage/app_storage.dart';
import 'package:places/env/build_config.dart';
import 'package:places/env/env.dart';
import 'package:places/ui/app/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStorage.init();

  defineEnvironment(_setUpConfig());

  debugPrint = (message, {wrapWidth}) {};

  runApp(const App());
}

void defineEnvironment(BuildConfig buildConfig) {
  Environment.init(BuildType.prod, buildConfig);
}

BuildConfig _setUpConfig() {
  return BuildConfig(envString: '');
}
