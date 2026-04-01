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
    return Container(
      width: 60,
      height: 60,
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
  // This manages game logic, and is out of scope for this lesson.
  final Game _game = Game();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        spacing: 5.0,
        children: [
          for (var guess in _game.guesses)
            Row(
              spacing: 5.0,
              children: [
                for (var letter in guess) Tile(letter.char, letter.type),
              ],
            ),
          GuessInput(
            onSubmitGuess: (String guess) {
              setState(() {
                _game.guess(guess);
                print(guess); // Temporary
              });
            },
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

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  final FocusNode _focusNode = FocusNode();

  late void Function(String) onSubmitGuess;

  void _onSubmit(String guess) {
    _textEditingController.clear();
    _focusNode.requestFocus();
    print(_textEditingController.text); // Temporary
    onSubmitGuess(guess);
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
