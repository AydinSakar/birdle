import 'package:flutter/material.dart';
import 'package:birdle/game/game_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text('Birdle'),
        ),
      ),
      body: const Center(child: GamePage()),
    );
  }
}
