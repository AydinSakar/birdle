import 'package:flutter/material.dart';
import 'package:birdle/game/game.dart';
import 'package:birdle/game/tile.dart';
import 'package:birdle/game/guess_input.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final Game _game = Game();
  String _message = 'Guess the 5-letter word';

  void _submitGuess(String guess) {
    if (_game.didWin || _game.didLose) {
      setState(() {
        _message = 'Game over! Press Restart to play again.';
      });
      return;
    }

    final normalized = guess.trim().toLowerCase();

    if (normalized.length != 5) {
      setState(() {
        _message = 'Guess must be exactly 5 letters.';
      });
      return;
    }

    if (!_game.isLegalGuess(normalized)) {
      setState(() {
        _message = 'Not a legal guess. Try a valid word.';
      });
      return;
    }

    setState(() {
      _game.guess(normalized);
      if (_game.didWin) {
        _message = 'You win! The word was ${_game.hiddenWord}.';
      } else if (_game.didLose) {
        _message = 'You lose! The word was ${_game.hiddenWord}.';
      } else {
        _message = 'Guesses left: ${_game.guessesRemaining}';
      }
    });
  }

  void _resetGame() {
    setState(() {
      _game.resetGame();
      _message = 'Guess the 5-letter word';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(_message, style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var guess in _game.guesses) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (var letter in guess) ...[
                          Tile(letter.char, letter.type),
                          const SizedBox(width: 6),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ),
          GuessInput(onSubmitGuess: _submitGuess),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _resetGame,
            icon: const Icon(Icons.refresh),
            label: const Text('Restart'),
          ),
        ],
      ),
    );
  }
}
