import 'package:flutter/material.dart';

class TweenAnimationBuilderExample extends StatefulWidget {
  const TweenAnimationBuilderExample({super.key});

  @override
  State<TweenAnimationBuilderExample> createState() =>
      _TweenAnimationBuilderExampleState();
}

class _TweenAnimationBuilderExampleState
    extends State<TweenAnimationBuilderExample> {
  double _targetValue = 32.0;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: _targetValue),
      duration: const Duration(seconds: 1),
      builder: (BuildContext context, double size, Widget? child) {
        return IconButton(
          iconSize: size,
          color: Colors.blue,
          icon: child!,
          onPressed: () {
            setState(() {
              _targetValue = _targetValue == 32.0
                  ? 48.0
                  : _targetValue == 48.0
                  ? 72.0
                  : 32.0;
            });
          },
        );
      },
      child: const Icon(Icons.flutter_dash_sharp),
      // onEnd: () {
      //   setState(() {
      //     _targetValue = _targetValue == 24.0 ? 48.0 : 24.0;
      //   });
      // },
    );
  }
}
