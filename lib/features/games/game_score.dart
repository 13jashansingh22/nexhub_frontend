import 'package:flutter/material.dart';

class GameScore extends ChangeNotifier {
  int _score = 0;
  int get score => _score;

  void increment([int by = 1]) {
    _score += by;
    notifyListeners();
  }

  void reset() {
    _score = 0;
    notifyListeners();
  }
}
