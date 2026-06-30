import 'package:flutter/material.dart';

class NewPageErrorIndicator extends StatelessWidget {
  const NewPageErrorIndicator({
    super.key,
    required this.error,
    required this.onTryAgain,
  });

  final Object? error;
  final VoidCallback onTryAgain;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.refresh, size: 24),
          const SizedBox(height: 8),
          Text(
            'Failed to load more',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(
            error?.toString() ?? 'Something went wrong.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: onTryAgain, child: const Text('Retry')),
        ],
      ),
    ),
  );
}
