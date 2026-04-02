import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/widgets/presentation/widgets/Button/cupertino_buttons.dart';
import 'package:flutter_app/src/features/widgets/presentation/widgets/Button/material_buttons.dart';

class ButtonScreen extends StatelessWidget {
  const ButtonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.apple)),
              Tab(icon: Icon(Icons.android)),
            ],
          ),
          title: const Text('Buttons Screen'),
        ),
        body: const TabBarView(
          children: [CupertinoButtons(), MaterialButtons()],
        ),
      ),
    );
  }
}
