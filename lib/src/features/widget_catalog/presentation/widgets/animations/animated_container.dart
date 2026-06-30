import 'package:flutter/material.dart';

class AnimatedContainerExample extends StatefulWidget {
  const AnimatedContainerExample({super.key, required this.selected});

  final bool selected;

  @override
  State<AnimatedContainerExample> createState() =>
      _AnimatedContainerExampleState();
}

class _AnimatedContainerExampleState extends State<AnimatedContainerExample> {
  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;

    final glowColor = selected
        ? const Color(0xFF7C4DFF)
        : const Color(0xFF1976D2);

    return Center(
      child: AnimatedContainer(
        width: selected ? 110.0 : 90.0,
        height: selected ? 110.0 : 90.0,
        padding: const EdgeInsets.all(12),
        alignment: selected ? Alignment.bottomCenter : Alignment.topCenter,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: selected
                ? const [Color(0xFF7C4DFF), Color(0xFF448AFF)]
                : const [Color(0xFF1565C0), Color(0xFF42A5F5)],
          ),
          borderRadius: BorderRadius.circular(selected ? 32 : 16),
          boxShadow: [
            BoxShadow(
              color: glowColor.withValues(alpha: 0.55),
              blurRadius: selected ? 16 : 10,
              spreadRadius: selected ? 2 : 0,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 2000),
        curve: Curves.easeOutQuint,
        child: const FlutterLogo(size: 35),
      ),
    );
  }
}
