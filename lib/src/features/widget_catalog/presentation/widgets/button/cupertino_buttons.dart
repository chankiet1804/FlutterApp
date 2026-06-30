import 'package:flutter/cupertino.dart';

class CupertinoButtons extends StatelessWidget {
  const CupertinoButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoButtonExample();
  }
}

class CupertinoButtonExample extends StatelessWidget {
  const CupertinoButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const CupertinoButton(onPressed: null, child: Text('Disabled')),
          const SizedBox(height: 30),
          const CupertinoButton.filled(
            onPressed: null,
            child: Text('Disabled'),
          ),
          const SizedBox(height: 30),
          CupertinoButton(onPressed: () {}, child: const Text('Enabled')),
          const SizedBox(height: 30),
          CupertinoButton.filled(
            onPressed: () {},
            child: const Text('Enabled'),
          ),
        ],
      ),
    );
  }
}
