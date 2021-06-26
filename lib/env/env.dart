import 'package:places/env/build_config.dart';

enum BuildType {
  dev,
  prod,
}

class Environment {
  Environment._({
    this.buildType,
    this.buildConfig,
  });

  final BuildType buildType;
  final BuildConfig buildConfig;

  static Environment _environment;

  static void init(
    BuildType buildType,
    BuildConfig buildConfig,
  ) {
    _environment = Environment._(
      buildType: buildType,
      buildConfig: buildConfig,
    );
  }

  static Environment get instance => _environment;
}
