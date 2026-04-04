import 'package:flutter/material.dart';

class ProgressIndicatorExample extends StatefulWidget {
  const ProgressIndicatorExample({super.key});

  @override
  State<ProgressIndicatorExample> createState() =>
      _ProgressIndicatorExampleState();
}

class _ProgressIndicatorExampleState extends State<ProgressIndicatorExample>
    with TickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(
            /// [AnimationController]s can be created with `vsync: this` because of
            /// [TickerProviderStateMixin].
            vsync: this,
            duration: const Duration(seconds: 5),
          )
          ..addListener(() {
            setState(() {});
          })
          ..repeat(reverse: true);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16.0,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text('Determinate LinearProgressIndicator'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LinearProgressIndicator(
              // ignore: deprecated_member_use
              value: controller.value,
            ),
          ),
          const Text('Determinate LinearProgressIndicator year2023: false'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LinearProgressIndicator(
              // ignore: deprecated_member_use
              year2023: false,
              value: controller.value,
            ),
          ),
          const Text('Indeterminate LinearProgressIndicator'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            // ignore: deprecated_member_use
            child: LinearProgressIndicator(year2023: true),
          ),
          const Text('Custom Colors LinearProgressIndicator'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            // ignore: deprecated_member_use
            child: LinearProgressIndicator(
              backgroundColor: Colors.grey[300],
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
