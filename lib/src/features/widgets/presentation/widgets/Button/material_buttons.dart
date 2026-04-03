import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/widgets/presentation/widgets/Button/floating_action_button.dart';
import 'package:flutter_app/src/features/widgets/presentation/widgets/Button/floating_button.dart';
import 'package:flutter_app/src/features/widgets/presentation/widgets/Button/icon_buttons.dart';

class MaterialButtons extends StatelessWidget {
  const MaterialButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return const ButtonTypesExample();
  }
}

class ButtonTypesExample extends StatelessWidget {
  const ButtonTypesExample({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.sizeOf(context).height;
    return ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            children: [
              SizedBox(
                height: deviceHeight * 0.5,
                child: const Row(
                  children: <Widget>[
                    Spacer(),
                    ButtonTypesGroup(enabled: true),
                    ButtonTypesGroup(enabled: false),
                    Spacer(),
                  ],
                ),
              ),
              CustomFloatingActionButton(),
              FloatingActionButtonExampleWidget(),
              IconButtonExample(),
            ],
          ),
        );
      },
    );
  }
}

class ButtonTypesGroup extends StatelessWidget {
  const ButtonTypesGroup({super.key, required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final VoidCallback? onPressed = enabled ? () {} : null;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ElevatedButton(onPressed: onPressed, child: const Text('Elevated')),
          FilledButton(onPressed: onPressed, child: const Text('Filled')),
          FilledButton.tonal(
            onPressed: onPressed,
            child: const Text('Filled Tonal'),
          ),
          OutlinedButton(onPressed: onPressed, child: const Text('Outlined')),
          TextButton(onPressed: onPressed, child: const Text('Text')),
        ],
      ),
    );
  }
}
