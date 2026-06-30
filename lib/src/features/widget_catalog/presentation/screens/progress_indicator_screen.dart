import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/widgets/progress_indicator/circle_progress_indicator.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/widgets/progress_indicator/linear_progress_indicator.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/widgets/progress_indicator/synchronization_indicator.dart';

class ProgressIndicatorScreen extends StatelessWidget {
  const ProgressIndicatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> data = [
      ProgressIndicatorExample(),
      CircleProgressIndicatorExample(),
      SynchronizationIndicatorExample(),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Indicator'),
        scrolledUnderElevation: 0,
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return data[index];
        },
      ),
    );
  }
}
