import 'package:flutter/material.dart';

class GameLeaderboard extends StatelessWidget {
  final List<Map<String, dynamic>> scores;
  const GameLeaderboard({super.key, required this.scores});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: scores.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final entry = scores[index];
        return ListTile(
          leading: Text('#${index + 1}'),
          title: Text(entry['name'] ?? 'Player'),
          trailing: Text('${entry['score']}'),
        );
      },
    );
  }
}
