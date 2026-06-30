import 'package:flutter/material.dart';

class CircleProgressIndicatorExample extends StatefulWidget {
  const CircleProgressIndicatorExample({super.key});

  @override
  State<CircleProgressIndicatorExample> createState() =>
      _CircleProgressIndicatorExampleState();
}

class _CircleProgressIndicatorExampleState
    extends State<CircleProgressIndicatorExample>
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
          const Text('Determinate CircleProgressIndicator'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CircularProgressIndicator(
              // ignore: deprecated_member_use
              value: controller.value,
            ),
          ),
          const Text('Determinate CircleProgressIndicator year2023: false'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CircularProgressIndicator(
              // ignore: deprecated_member_use
              year2023: false,
              value: controller.value,
            ),
          ),
          const Text('Indeterminate CircleProgressIndicator'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            // ignore: deprecated_member_use
            child: CircularProgressIndicator(),
          ),
          const Text('Custom Colors CircleProgressIndicator'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            // ignore: deprecated_member_use
            child: CircularProgressIndicator(
              backgroundColor: Colors.grey[300],
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
