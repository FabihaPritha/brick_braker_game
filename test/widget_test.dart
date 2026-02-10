// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flame/game.dart';

import 'package:brick_braker_game/src/brick_breaker.dart';

void main() {
  testWidgets('BrickBreaker game loads', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    final game = BrickBreaker();
    await tester.pumpWidget(GameWidget(game: game));

    // Verify that the game widget is rendered.
    expect(find.byType(GameWidget<BrickBreaker>), findsOneWidget);
  });
}
