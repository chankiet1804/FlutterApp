import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/home/presentation/widgets/welcome_banner.dart';
import 'package:flutter_app/src/state/counter_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const WelcomeBanner(),
          const SizedBox(height: 12),
          Expanded(
            child: Card(
              shadowColor: Colors.transparent,
              margin: EdgeInsets.zero,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Home page', style: theme.textTheme.titleLarge),
                    Text(
                      'Counter get by context.watch: ${context.watch<CounterProvider>().counter}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
