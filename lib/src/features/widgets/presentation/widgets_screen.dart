import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/widgets/presentation/button_screen.dart';

class WidgetsScreen extends StatelessWidget {
  const WidgetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> data = [
      Card(
        child: ListTile(
          leading: Icon(Icons.width_normal),
          title: Text('Buttons'),
          subtitle: Text('Tap to open button screen'),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute<void>(builder: (context) => const ButtonScreen()),
          ),
        ),
      ),
    ];
    return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return data[index];
      },
    );
  }
}
