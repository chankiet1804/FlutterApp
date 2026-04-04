import 'package:flutter/material.dart';

class SynchronizationIndicatorExample extends StatefulWidget {
  const SynchronizationIndicatorExample({super.key});

  @override
  State<SynchronizationIndicatorExample> createState() =>
      _SynchronizationIndicatorExampleState();
}

class _SynchronizationIndicatorExampleState
    extends State<SynchronizationIndicatorExample>
    with TickerProviderStateMixin {
  late AnimationController controller;
  int indicatorNum = 1;
  bool hasThemeController = true;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: CircularProgressIndicator.defaultAnimationDuration * 0.8,
    );
    controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        progressIndicatorTheme: hasThemeController
            ? ProgressIndicatorThemeData(controller: controller)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          spacing: 24.0,
          children: <Widget>[
            const Text('Synchronization indicator'),
            ManyProgressIndicators(indicatorNum: indicatorNum),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      indicatorNum += 1;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    setState(() {
                      indicatorNum -= 1;
                    });
                  },
                ),
                Switch(
                  value: hasThemeController,
                  onChanged: (bool value) {
                    setState(() {
                      hasThemeController = !hasThemeController;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Display several [CircularProgressIndicator] in nested `Container`s.
class ManyProgressIndicators extends StatelessWidget {
  const ManyProgressIndicators({super.key, required this.indicatorNum});

  final int indicatorNum;

  Widget _nestIndicator({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [const CircularProgressIndicator(), child],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget child = const SizedBox();
    for (int i = 0; i < indicatorNum; i++) {
      child = _nestIndicator(child: child);
    }
    return child;
  }
}
