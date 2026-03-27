import 'package:flutter/material.dart';

class MemoryMatchGameScreen extends StatefulWidget {
  const MemoryMatchGameScreen({super.key});

  @override
  State<MemoryMatchGameScreen> createState() => _MemoryMatchGameScreenState();
}

class _MemoryMatchGameScreenState extends State<MemoryMatchGameScreen> {
  static const int gridSize = 4;
  late List<_CardModel> cards;
  int? firstIndex;
  int? secondIndex;
  bool waiting = false;
  int matches = 0;

  @override
  void initState() {
    super.initState();
    _initGame();
  }

  void _initGame() {
    final values = List.generate(gridSize * gridSize ~/ 2, (i) => i + 1);
    final allValues = [...values, ...values]..shuffle();
    cards = allValues.map((v) => _CardModel(value: v)).toList();
    firstIndex = null;
    secondIndex = null;
    waiting = false;
    matches = 0;
    setState(() {});
  }

  void _onCardTap(int idx) async {
    if (waiting || cards[idx].revealed || idx == firstIndex) return;
    setState(() {
      if (firstIndex == null) {
        firstIndex = idx;
        cards[idx].revealed = true;
      } else if (secondIndex == null) {
        secondIndex = idx;
        cards[idx].revealed = true;
        waiting = true;
      }
    });
    if (firstIndex != null && secondIndex != null) {
      await Future.delayed(const Duration(milliseconds: 700));
      if (cards[firstIndex!].value == cards[secondIndex!].value) {
        matches++;
      } else {
        setState(() {
          cards[firstIndex!].revealed = false;
          cards[secondIndex!].revealed = false;
        });
      }
      setState(() {
        firstIndex = null;
        secondIndex = null;
        waiting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final won = matches == gridSize * gridSize ~/ 2;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Memory Match'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _initGame),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (won)
            const Text(
              'You Win!',
              style: TextStyle(fontSize: 28, color: Colors.green),
            ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: gridSize,
              ),
              itemCount: cards.length,
              itemBuilder: (context, i) {
                final card = cards[i];
                return GestureDetector(
                  onTap: () => _onCardTap(i),
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: card.revealed ? Colors.orange : Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child:
                          card.revealed
                              ? Text(
                                '${card.value}',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                              : const Icon(
                                Icons.help_outline,
                                color: Colors.white38,
                                size: 32,
                              ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CardModel {
  final int value;
  bool revealed;
  _CardModel({required this.value}) : revealed = false;
}
