import 'package:flutter/material.dart';

class FloatingActionButtonExample extends StatelessWidget {
  const FloatingActionButtonExample({super.key});

  @override
  Widget build(BuildContext context) {
    return const FloatingActionButtonExampleWidget();
  }
}

class FloatingActionButtonExampleWidget extends StatefulWidget {
  const FloatingActionButtonExampleWidget({super.key});

  @override
  State<FloatingActionButtonExampleWidget> createState() =>
      _FloatingActionButtonExampleWidgetState();
}

class _FloatingActionButtonExampleWidgetState
    extends State<FloatingActionButtonExampleWidget> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    Widget titleBox(String title) {
      return DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.inverseSurface,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(
            title,
            style: TextStyle(color: colorScheme.onInverseSurface),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 24),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FloatingActionButton.small(
                  heroTag: null,
                  foregroundColor: _selectedIndex == 0
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                  backgroundColor: _selectedIndex == 0
                      ? colorScheme.primary
                      : colorScheme.surface,
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: const Icon(Icons.edit_outlined),
                ),
                const SizedBox(height: 20),
                titleBox('Surface'),
              ],
            ),
            // Secondary color mapping.
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FloatingActionButton.small(
                  heroTag: null,
                  foregroundColor: _selectedIndex == 1
                      ? colorScheme.onPrimary
                      : colorScheme.onSecondaryContainer,
                  backgroundColor: _selectedIndex == 1
                      ? colorScheme.primary
                      : colorScheme.secondaryContainer,
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: const Icon(Icons.edit_outlined),
                ),
                const SizedBox(height: 20),
                titleBox('Secondary'),
              ],
            ),
            // Tertiary color mapping.
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FloatingActionButton.small(
                  heroTag: null,
                  foregroundColor: _selectedIndex == 2
                      ? colorScheme.onPrimary
                      : colorScheme.onTertiaryContainer,
                  backgroundColor: _selectedIndex == 2
                      ? colorScheme.primary
                      : colorScheme.tertiaryContainer,
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                  child: const Icon(Icons.edit_outlined),
                ),
                const SizedBox(height: 20),
                titleBox('Tertiary'),
              ],
            ),
            // Inverse color mapping.
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FloatingActionButton.small(
                  heroTag: null,
                  foregroundColor: _selectedIndex == 3
                      ? colorScheme.onPrimary
                      : colorScheme.onInverseSurface,
                  backgroundColor: _selectedIndex == 3
                      ? colorScheme.primary
                      : colorScheme.inverseSurface,
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 3;
                    });
                  },
                  child: const Icon(Icons.edit_outlined),
                ),
                const SizedBox(height: 20),
                titleBox('Inverse'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
