import 'package:flutter_test/flutter_test.dart';
import 'package:mingda_app/features/auth/data/datasources/auth_dummy_data_source_impl.dart';

void main() {
  group('AuthDummyDataSourceImpl', () {
    final dataSource = AuthDummyDataSourceImpl();

    test('SignInDataSource returns dummy LoginModel with token and user', () async {
      final result = await dataSource.SignInDataSource(
        email: 'admin@mingda.co.id',
        password: 'password123',
      );

      expect(result.success, isTrue);
      expect(result.token, isNotEmpty);
      expect(result.userModel.email, equals('admin@mingda.co.id'));
    });
  });
}
