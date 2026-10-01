import 'package:flutter_test/flutter_test.dart';
import 'package:mingda_app/features/dashboard/data/models/profile_model.dart';

void main() {
  test('ProfileModel.fromJson parses documented real server response', () {
    final json = {
      'success': true,
      'data': {
        'id': 10,
        'name': 'Budi Santoso',
        'employee_code': 'EMP001',
        'shift_type': 'Shift Pagi (08:00 - 17:00)',
        'department': {'name': 'IT'},
        'position': {'name': 'Staff'}
      }
    };

    final model = ProfileModel.fromJson(json);
    expect(model.id, 10);
    expect(model.name, 'Budi Santoso');
    expect(model.department.name, 'IT');
    expect(model.position.name, 'Staff');
  });
}
