import 'package:flutter_test/flutter_test.dart';
import 'package:tic_tac_toe_frontend/main.dart';

void main() {
  group('Tic Tac Toe Core Game Logic', () {
    _GameScreenState createState() {
      // HACK: Flutter requires State objects to be created via the Widget.
      // This helper creates the State and initializes it via createState.
      final gameScreen = const GameScreen();
      final state = gameScreen.createState();
      return state as _GameScreenState;
    }

    test('Initial state is correct', () {
      final state = createState();
      expect(state._board, List.generate(9, (_) => ''));
      expect(state._isXTurn, isTrue);
      expect(state._gameOver, isFalse);
      expect(state._resultMessage, isNull);
    });

    test('Player X wins with a row', () {
      final state = createState();
      // X X X
      // O O
      state._board = [
        'X', 'X', 'X',
        'O', 'O', '',
        '', '', ''
      ];
      final isWin = state._checkWinner('X');
      expect(isWin, isTrue);
    });

    test('Player O wins with a column', () {
      final state = createState();
      // O X X
      // O
      // O
      state._board = [
        'O', 'X', 'X',
        'O', '', '',
        'O', '', ''
      ];
      final isWin = state._checkWinner('O');
      expect(isWin, isTrue);
    });

    test('Player X wins with a diagonal', () {
      final state = createState();
      // X     O
      //   X   O
      //     X
      state._board = [
        'X', '', 'O',
        '', 'X', 'O',
        '', '', 'X'
      ];
      final isWin = state._checkWinner('X');
      expect(isWin, isTrue);
    });

    test('Game detects draw', () {
      final state = createState();
      // X O X
      // X O O
      // O X X
      state._board = [
        'X', 'O', 'X',
        'X', 'O', 'O',
        'O', 'X', 'X'
      ];
      state._gameOver = false;
      state._isXTurn = true;
      state._resultMessage = null;

      // Simulate last move to force check for draw
      state._handleTap(8);
      expect(state._gameOver, isTrue);
      expect(state._resultMessage, 'Draw!');
    });

    test('Player turn switches after valid move', () {
      final state = createState();

      expect(state._isXTurn, isTrue);
      // First move (X)
      state._handleTap(0);
      expect(state._board[0], 'X');
      expect(state._isXTurn, isFalse);
      // Second move (O)
      state._handleTap(1);
      expect(state._board[1], 'O');
      expect(state._isXTurn, isTrue);
    });

    test('Game stops after win', () {
      final state = createState();
      state._board = [
        'X', 'X', '',
        '', '', '',
        '', '', ''
      ];
      state._isXTurn = true;
      
      // Make winning move
      state._handleTap(2);
      expect(state._gameOver, isTrue);
      expect(state._resultMessage, 'Player X wins!');
      // Try further moves
      state._handleTap(3);
      expect(state._board[3], '');
    });

    test('Reset functionality restores initial state', () {
      final state = createState();
      // Set up a won board
      state._board = [
        'X', 'X', 'X',
        'O', 'O', '',
        '', '', ''
      ];
      state._gameOver = true;
      state._resultMessage = "Player X wins!";
      state._isXTurn = false;
      // Reset game
      state._resetGame();
      // Expectations
      expect(state._board, List.generate(9, (_) => ''));
      expect(state._isXTurn, isTrue);
      expect(state._gameOver, isFalse);
      expect(state._resultMessage, isNull);
    });

    test('Tap on occupied cell has no effect', () {
      final state = createState();
      state._handleTap(0); // X at 0
      final beforeBoard = List<String>.from(state._board);
      // try to play at cell 0 again
      state._handleTap(0);
      expect(state._board, beforeBoard, reason: "Occupied cell should not change board");
    });
  });
}
