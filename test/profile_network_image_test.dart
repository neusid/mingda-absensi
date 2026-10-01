import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mingda_app/features/dashboard/presentation/widgets/profile_network_image.dart';

void main() {
  testWidgets('ProfileNetworkImage renders fallback when network fails', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileNetworkImage(
            url: 'https://invalid.example.com/x.webp',
            width: 50,
            height: 50,
          ),
        ),
      ),
    );

    // Beri waktu untuk error network terjadi
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));

    // Fallback ikon person harus muncul
    expect(find.byIcon(Icons.person), findsOneWidget);
  });

  testWidgets('ProfileNetworkImage renders fallback immediately when url is empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileNetworkImage(
            url: '',
            width: 50,
            height: 50,
          ),
        ),
      ),
    );

    await tester.pump();
    expect(find.byIcon(Icons.person), findsOneWidget);
  });

  testWidgets('ProfileNetworkImage renders custom fallback when provided', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileNetworkImage(
            url: '',
            width: 50,
            height: 50,
            fallback: Text('Custom Fallback'),
          ),
        ),
      ),
    );

    await tester.pump();
    expect(find.text('Custom Fallback'), findsOneWidget);
  });
}
