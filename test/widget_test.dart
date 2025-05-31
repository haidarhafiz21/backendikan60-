// test/widget_test.dart

// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Import yang benar untuk proyek Anda:
import 'package:pemesanan_ikan1/main.dart'; // Sesuaikan 'pemesanan_ikan1' jika nama proyek Anda berbeda

void main() {
  testWidgets('Aplikasi memulai di WelcomePage', (WidgetTester tester) async {
    // Bangun aplikasi kita.
    await tester.pumpWidget(const MyApp());

    // Verifikasi bahwa WelcomePage muncul.
    // Anda bisa mencari teks unik di WelcomePage, contoh:
    expect(find.text('Selamat Datang!'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Daftar Sekarang'), findsOneWidget);
  });

  // Tes bawaan Counter increments smoke test (dikomentari karena tidak relevan dengan aplikasi e-commerce Anda)
  /*
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
  */
}