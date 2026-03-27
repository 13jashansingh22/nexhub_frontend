import 'package:flutter/material.dart';

class ChessGameScreen extends StatelessWidget {
  const ChessGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chess')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Chess Game', style: TextStyle(fontSize: 28)),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[900],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 8,
                  ),
                  itemCount: 64,
                  itemBuilder: (context, i) {
                    final r = i ~/ 8;
                    final c = i % 8;
                    final isWhite = (r + c) % 2 == 0;
                    return Container(
                      decoration: BoxDecoration(
                        color: isWhite ? Colors.white : Colors.black,
                      ),
                    );
                  },
                ),
              ),
            ),
            const Text(
              'Demo board only. Full chess logic coming soon!',
              style: TextStyle(color: Colors.orange),
            ),
          ],
        ),
      ),
    );
  }
}
