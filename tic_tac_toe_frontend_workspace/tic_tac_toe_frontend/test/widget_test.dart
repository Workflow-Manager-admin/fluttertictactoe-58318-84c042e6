import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe_frontend/main.dart';

void main() {
  testWidgets('Main menu shows Play Game button and app title', (WidgetTester tester) async {
    await tester.pumpWidget(const TicTacToeApp());

    expect(find.text('Tic Tac Toe'), findsWidgets);
    expect(find.text('Play Game'), findsOneWidget);
    expect(find.byIcon(Icons.grid_3x3), findsOneWidget);
  });
}
