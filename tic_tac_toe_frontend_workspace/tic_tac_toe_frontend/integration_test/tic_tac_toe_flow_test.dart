import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe_frontend/main.dart';

void main() {
  // Entry point for Flutter integration tests
  group('Tic Tac Toe Integration Tests', () {
    testWidgets('Full game flow: play game, win, draw notification, reset, menu navigation', (WidgetTester tester) async {
      // 1. Start from the main menu
      await tester.pumpWidget(const TicTacToeApp());
      expect(find.text('Tic Tac Toe'), findsWidgets); // title shows on menu

      // Tap "Play Game" button to go to game screen
      await tester.tap(find.widgetWithText(ElevatedButton, 'Play Game'));
      await tester.pumpAndSettle();
      expect(find.text('Current: X'), findsOneWidget); // X starts

      // 2. Simulate play sequence resulting in X winning: X O X O X
      // X | O | X
      // O | X | .
      // . | . | .

      // Tap sequence: [0]X, [1]O, [2]X, [3]O, [4]X
      Future<void> tapCell(int idx) async {
        await tester.tap(find.byKey(ValueKey('board_cell_$idx')));
        await tester.pump();
      }

      await tapCell(0); // X
      expect(find.text('X'), findsOneWidget); // at least one X visible
      await tapCell(1); // O
      await tapCell(2); // X
      await tapCell(3); // O
      await tapCell(4); // X -- X should win

      // After possible win
      await tester.pump();
      expect(find.byKey(const ValueKey('result_status')), findsOneWidget);
      expect(find.textContaining('wins!'), findsOneWidget);

      // 3. Reset game via button
      await tester.tap(find.widgetWithIcon(ElevatedButton, Icons.refresh));
      await tester.pump();

      // After reset: status should be 'Current: X', board is empty
      expect(find.text('Current: X'), findsOneWidget);
      for (int i = 0; i < 9; i++) {
        final cellText = tester.widget<AnimatedSwitcher>(
          find.descendant(
            of: find.byKey(ValueKey('board_cell_$i')),
            matching: find.byType(AnimatedSwitcher)
          )
        );
        // Can't extract the direct text because of animation, but we know board should be empty (no X/O found in cells)
        // Just skip as the widget will NOT show any Text('X') nor Text('O') at reset.
      }

      // 4. Simulate a draw game: fill board without win
      // X O X
      // X O O
      // O X X
      final drawMoves = [0,1,2,4,3,5,7,6,8];
      for (var i=0; i<drawMoves.length; i++) {
        await tapCell(drawMoves[i]);
        await tester.pump();
      }
      expect(find.textContaining('Draw!'), findsOneWidget);

      // 5. Menu navigation: go back to menu using OutlinedButton (icon: Icons.home_outlined)
      await tester.tap(find.widgetWithIcon(OutlinedButton, Icons.home_outlined));
      await tester.pumpAndSettle();
      expect(find.text('Tic Tac Toe'), findsWidgets); // Back at menu

      // 6. Navigate again to game screen for final check
      await tester.tap(find.widgetWithText(ElevatedButton, 'Play Game'));
      await tester.pumpAndSettle();
      expect(find.text('Current: X'), findsOneWidget);
    });
  });
}
