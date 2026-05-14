import 'package:flutter/material.dart';

class CounterProvider extends ChangeNotifier {
  int _counter = 10;
  Color color = Colors.green;

  int get counter => _counter;

  void add() {
    _counter++;
    notifyListeners();
  }

  void remove() {
    _counter--;
    notifyListeners();
  }

  void changeColor() {
    if (color == Colors.green) {
      color = Colors.red;
    } else if (color == Colors.red) {
      color = Colors.yellow;
    } else if (color == Colors.yellow) {
      color = Colors.pink;
    } else if (color == Colors.pink) {
      color = Colors.orange;
    } else if (color == Colors.orange) {
      color = Colors.blue;
    } else if (color == Colors.blue) {
      color = Colors.blueGrey;
    } else {
      color = Colors.green;
    }
    notifyListeners();
  }
}
