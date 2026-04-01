import 'package:flutter/material.dart';
import 'package:birdle/game.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text('Birdle'),
          ),
        ),
        body: Center(child: GamePage()),
        // body: Center(child: Text('Hello World!')),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile(this.letter, this.hitType, {super.key});

  final String letter;
  final HitType hitType;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.bounceIn,
      height: 60,
      width: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        color: switch (hitType) {
          HitType.hit => Colors.green,
          HitType.partial => Colors.yellow,
          HitType.miss => Colors.grey,
          _ => Colors.white,
        },
      ),
      child: Center(
        child: Text(
          letter.toUpperCase(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
      )
    );
  }
}

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
          Text(_message, style: TextStyle(fontSize: 16)),
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
            icon: Icon(Icons.refresh),
            label: Text('Restart'),
          ),
        ],
      ),
    );
  }
}

class GuessInput extends StatefulWidget {
  const GuessInput({super.key, required this.onSubmitGuess});

  @override
  State<GuessInput> createState() => _GuessInputState();

  final void Function(String) onSubmitGuess;
}

class _GuessInputState extends State<GuessInput> {
  late final TextEditingController _textEditingController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSubmit(String guess) {
    final trimmed = guess.trim();
    if (trimmed.isEmpty) return;
    widget.onSubmitGuess(trimmed);
    _textEditingController.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLength: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
              ),
              controller: _textEditingController,
              autofocus: true,
              onSubmitted: (value) {
                _onSubmit(_textEditingController.text.trim());
              },
            ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          icon: Icon(Icons.arrow_circle_up),
          onPressed: () {
            _onSubmit(_textEditingController.text.trim());
          },
        ),
      ],
    );
  }
}
