import 'package:flutter/material.dart';

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
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35)),
                ),
              ),
              controller: _textEditingController,
              autofocus: true,
              focusNode: _focusNode,
              onSubmitted: (value) {
                _onSubmit(_textEditingController.text.trim());
              },
            ),
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          icon: const Icon(Icons.arrow_circle_up),
          onPressed: () {
            _onSubmit(_textEditingController.text.trim());
          },
        ),
      ],
    );
  }
}
