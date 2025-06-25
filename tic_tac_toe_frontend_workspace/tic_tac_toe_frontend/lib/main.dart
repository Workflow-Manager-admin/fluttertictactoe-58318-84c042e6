import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToeApp());
}

///
/// The main application widget for Tic Tac Toe.
/// Implements a modern, minimalistic, light-themed tic tac toe game.
///
class TicTacToeApp extends StatelessWidget {
  const TicTacToeApp({super.key});

  // PUBLIC_INTERFACE
  @override
  Widget build(BuildContext context) {
    final Color primary = const Color(0xFF2196F3); // Blue
    final Color secondary = const Color(0xFF4CAF50); // Green
    final Color accent = const Color(0xFFFFC107); // Amber

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tic Tac Toe',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: primary,
        colorScheme: ColorScheme.light(
          primary: primary,
          secondary: secondary,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        canvasColor: Colors.white,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 2,
          ),
          bodyMedium: TextStyle(
            fontSize: 20,
            color: Colors.black87,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: accent,
            foregroundColor: Colors.black87,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            elevation: 0.5,
          ),
        ),
        useMaterial3: true,
      ),
      home: const MainMenuScreen(),
    );
  }
}

///
/// Displays the main menu screen with a "Play Game" button.
///
class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  // PUBLIC_INTERFACE
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // Status Bar (just a modern white bar by default)
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.grid_3x3, size: 72, color: Color(0xFF2196F3)),
              const SizedBox(height: 20),
              Text(
                'Tic Tac Toe',
                style: theme.textTheme.titleLarge!.copyWith(
                  letterSpacing: 3,
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const GameScreen()),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 12.0),
                  child: Text('Play Game'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///
/// Represents the main game screen for the Tic Tac Toe PvP game.
/// Contains the centered 3x3 grid, player status, notification for win/draw, and reset functionality.
///
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  // PUBLIC_INTERFACE
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // The 3x3 board cells: '' (empty), 'X', or 'O'
  List<String> _board = List.generate(9, (_) => '');

  // True if next turn is 'X', else 'O'
  bool _isXTurn = true;

  // Game Over state
  bool _gameOver = false;

  // Holds the winner message if any, or draw
  String? _resultMessage;

  // PUBLIC_INTERFACE
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color accent = theme.elevatedButtonTheme.style?.backgroundColor?.resolve({}) ?? const Color(0xFFFFC107);

    // Status Bar on top
    Widget statusBar() {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Text(
          _gameOver
              ? _resultMessage ?? ''
              : "Current: ${_isXTurn ? "X" : "O"}",
          style: theme.textTheme.bodyMedium!.copyWith(
            color: _gameOver ? Colors.redAccent : theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    // Game grid: 3x3
    Widget gameGrid() {
      return AspectRatio(
        aspectRatio: 1,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: theme.colorScheme.secondary,
              width: 2.0,
            ),
            borderRadius: BorderRadius.circular(18),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.blueGrey.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            ]
          ),
          child: GridView.builder(
            itemCount: 9,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () => _handleTap(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 110),
                  curve: Curves.easeInOutCubic,
                  decoration: BoxDecoration(
                    color: _board[index].isNotEmpty
                        ? accent.withOpacity(0.35)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: accent.withOpacity(0.5),
                      width: 1.1,
                    ),
                  ),
                  child: Center(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 190),
                      child: _buildCellSymbol(_board[index]),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    // Controls at the bottom
    Widget controls() {
      return Padding(
        padding: const EdgeInsets.only(bottom: 28.0, top: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh, size: 22),
              label: const Text('Reset'),
              onPressed: _resetGame,
            ),
            const SizedBox(width: 22),
            OutlinedButton.icon(
              icon: const Icon(Icons.home_outlined, size: 22),
              label: const Text('Menu'),
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white,
                primary: theme.colorScheme.primary,
                side: BorderSide(
                  color: theme.colorScheme.primary,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tic Tac Toe',
          style: TextStyle(fontWeight: FontWeight.w700, letterSpacing: 2.0),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: theme.colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            statusBar(),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width < 400
                      ? double.infinity
                      : 400,
                  child: gameGrid(),
                ),
              ),
            ),
            controls(),
          ],
        ),
      ),
    );
  }

  /// Handles a tap on a cell. Updates the board state and checks for a win or draw.
  // PUBLIC_INTERFACE
  void _handleTap(int index) {
    if (_gameOver || _board[index].isNotEmpty) return;

    setState(() {
      _board[index] = _isXTurn ? 'X' : 'O';
      if (_checkWinner(_board[index])) {
        _gameOver = true;
        _resultMessage = 'Player ${_board[index]} wins!';
      } else if (_board.every((e) => e.isNotEmpty)) {
        _gameOver = true;
        _resultMessage = 'Draw!';
      } else {
        _isXTurn = !_isXTurn;
      }
    });
  }

  /// Resets the game to the initial empty state.
  // PUBLIC_INTERFACE
  void _resetGame() {
    setState(() {
      _board = List.generate(9, (_) => '');
      _isXTurn = true;
      _gameOver = false;
      _resultMessage = null;
    });
  }

  /// Checks if the given player has won.
  // PUBLIC_INTERFACE
  bool _checkWinner(String player) {
    const List<List<int>> winPatterns = [
      [0,1,2], [3,4,5], [6,7,8], // rows
      [0,3,6], [1,4,7], [2,5,8], // columns
      [0,4,8], [2,4,6]           // diagonals
    ];
    for (final pattern in winPatterns) {
      if (pattern.every((index) => _board[index] == player)) {
        return true;
      }
    }
    return false;
  }

  /// Builds the X or O symbol for a board cell.
  Widget _buildCellSymbol(String symbol) {
    if (symbol == 'X') {
      return Text(
        'X',
        key: const ValueKey('X'),
        style: TextStyle(
          color: const Color(0xFF2196F3),
          fontSize: 44,
          fontWeight: FontWeight.w900,
        ),
      );
    } else if (symbol == 'O') {
      return Text(
        'O',
        key: const ValueKey('O'),
        style: TextStyle(
          color: const Color(0xFF4CAF50),
          fontSize: 44,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return const SizedBox(key: ValueKey('empty'));
    }
  }
}
