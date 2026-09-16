import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mingda_app/features/dashboard/data/models/attendance_summary_model.dart';

void main() {
  test('AttendanceSummaryModel.fromJson parses real response', () {
    final json = jsonDecode('''
    {
      "success": true,
      "data": {
        "total": 19,
        "hadir": 11,
        "terlambat": 1,
        "izin": 0,
        "sakit": 0,
        "alpha": 3,
        "cuti": 0,
        "total_late_minutes": 85
      }
    }
    ''');

    final model = AttendanceSummaryModel.fromJson(json);
    expect(model.total, 19);
    expect(model.hadir, 11);
    expect(model.totalLateMinutes, 85);
  });

  test('AttendanceSummaryModel.fromJson tolerates null/missing fields', () {
    final json = jsonDecode('''
    {
      "success": true,
      "data": {
        "total": null,
        "total_late_minutes": null
      }
    }
    ''');

    final model = AttendanceSummaryModel.fromJson(json);
    expect(model.total, 0);
    expect(model.hadir, 0);
    expect(model.totalLateMinutes, 0);
  });

  test('AttendanceSummaryModel.fromJson tolerates string numbers', () {
    final json = jsonDecode('''
    {
      "success": true,
      "data": {
        "total": "19",
        "hadir": "11",
        "terlambat": "1",
        "izin": "0",
        "sakit": "0",
        "alpha": "3",
        "cuti": "0",
        "total_late_minutes": "85"
      }
    }
    ''');

    final model = AttendanceSummaryModel.fromJson(json);
    expect(model.total, 19);
    expect(model.hadir, 11);
    expect(model.totalLateMinutes, 85);
  });
}
