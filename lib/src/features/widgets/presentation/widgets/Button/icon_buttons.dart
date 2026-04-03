import 'package:flutter/material.dart';

class IconButtonExample extends StatefulWidget {
  const IconButtonExample({super.key});
  @override
  State<IconButtonExample> createState() => _IconButtonExampleState();
}

class _IconButtonExampleState extends State<IconButtonExample> {
  int? _selectedIndex;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.volume_up),
              color: _selectedIndex == 0 ? Colors.green : null,
              onPressed: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
            Text('Volume'),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.favorite_rounded),
              color: _selectedIndex == 1 ? Colors.red : null,
              onPressed: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
            ),
            Text('Favorite'),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.rocket),
              color: _selectedIndex == 2 ? Colors.lightBlue : null,
              onPressed: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
            Text('Rocket'),
          ],
        ),
      ],
    );
  }
}
