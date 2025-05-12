import 'package:injectable/injectable.dart';

@injectable
class EnvironmentConfig {
  static const ENV = String.fromEnvironment(
    'DART_DEFINES_ENV',
    defaultValue: 'test',
  );

  static const BASE_URL = String.fromEnvironment(
    'DART_DEFINES_URL',
    defaultValue: 'https://api.shopizi.me',
  );
}
