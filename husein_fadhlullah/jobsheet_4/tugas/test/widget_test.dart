// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:tugas/main.dart';

void main() {
  testWidgets('Lyrics app loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LyricsApp());

    // Verify that the app loads with the song title or loading state
    expect(find.textContaining('Still Standing'), findsOneWidget);
    
    // Verify that the view lyrics button is present
    expect(find.text('View Lyrics'), findsOneWidget);
  });
}
