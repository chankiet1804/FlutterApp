import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CounterProvider extends ChangeNotifier {
  late int _counter = 0;
  Color color = Colors.green;

  int get counter => _counter;

  Future<void> loadCounter() async {
    final asyncPrefs = SharedPreferencesAsync();
    _counter = await asyncPrefs.getInt('counter') ?? 0;
    notifyListeners();
  }

  Future<void> add() async {
    final asyncPrefs = SharedPreferencesAsync();
    _counter++;
    notifyListeners();
    await asyncPrefs.setInt('counter', _counter);
  }

  Future<void> remove() async {
    final asyncPrefs = SharedPreferencesAsync();
    _counter--;
    notifyListeners();
    await asyncPrefs.setInt('counter', _counter);
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
