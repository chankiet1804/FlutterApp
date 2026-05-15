import 'package:flutter/material.dart';

enum AnimationStyles { defaultStyle, custom, none }

const List<(AnimationStyles, String)> animationStyleSegments =
    <(AnimationStyles, String)>[
      (AnimationStyles.defaultStyle, 'Default'),
      (AnimationStyles.custom, 'Custom'),
      (AnimationStyles.none, 'None'),
    ];

class ModalBottomSheetScreen extends StatefulWidget {
  const ModalBottomSheetScreen({super.key});

  @override
  State<ModalBottomSheetScreen> createState() => _ModalBottomSheetScreenState();
}

class _ModalBottomSheetScreenState extends State<ModalBottomSheetScreen> {
  Set<AnimationStyles> _animationStyleSelection = <AnimationStyles>{
    AnimationStyles.defaultStyle,
  };
  AnimationStyle? _animationStyle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Modal Bottom Sheet')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SegmentedButton<AnimationStyles>(
              selected: _animationStyleSelection,
              onSelectionChanged: (Set<AnimationStyles> styles) {
                setState(() {
                  _animationStyle = switch (styles.first) {
                    AnimationStyles.defaultStyle => null,
                    AnimationStyles.custom => const AnimationStyle(
                      duration: Duration(seconds: 3),
                      reverseDuration: Duration(seconds: 1),
                    ),
                    AnimationStyles.none => AnimationStyle.noAnimation,
                  };
                  _animationStyleSelection = styles;
                });
              },
              segments: animationStyleSegments
                  .map<ButtonSegment<AnimationStyles>>((
                    (AnimationStyles, String) shirt,
                  ) {
                    return ButtonSegment<AnimationStyles>(
                      value: shirt.$1,
                      label: Text(shirt.$2),
                    );
                  })
                  .toList(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              child: const Text('showModalBottomSheet'),
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  sheetAnimationStyle: _animationStyle,
                  builder: (BuildContext context) {
                    return SizedBox.expand(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            const Text('Modal bottom sheet'),
                            ElevatedButton(
                              child: const Text('Close'),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
