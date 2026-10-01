import 'package:flutter_test/flutter_test.dart';
import 'package:mingda_app/app/config/app_config.dart';

void main() {
  test('AppConfig offline mode is disabled', () {
    expect(AppConfig.isOfflineMode, isFalse);
  });
}
