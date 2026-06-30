import 'package:flutter/material.dart';

class FirstPageErrorIndicator extends StatelessWidget {
  const FirstPageErrorIndicator({
    super.key,
    required this.error,
    required this.onTryAgain,
  });

  final Object? error;
  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 32),
          const SizedBox(height: 12),
          Text(
            'Failed to load news',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(
            error?.toString() ?? 'Something went wrong.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onTryAgain, child: const Text('Try again')),
        ],
      ),
    ),
  );
}
