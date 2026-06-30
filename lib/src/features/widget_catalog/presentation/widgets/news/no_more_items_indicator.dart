import 'package:flutter/material.dart';

class NoMoreItemsIndicator extends StatelessWidget {
  const NoMoreItemsIndicator({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: 24),
    child: Center(child: Text('You have reached the end.')),
  );
}
