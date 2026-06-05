import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/widgets/Animations/animated_container.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/widgets/Animations/animated_logo_builder.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/widgets/Animations/animated_logo_widget.dart';

class AnimationsScreen extends StatefulWidget {
  const AnimationsScreen({super.key});
  @override
  State<AnimationsScreen> createState() => _AnimationsScreenState();
}

class _AnimationsScreenState extends State<AnimationsScreen>
    with TickerProviderStateMixin {
  // Item 1: AnimatedWidget
  late final AnimationController logoController;
  late final Animation<double> logoAnimation;
  bool isLogoAnimating = false;

  // Item 2: AnimatedBuilder
  late final AnimationController growController;
  late final Animation<double> growAnimation;
  bool isGrowAnimating = false;

  // Item 3: AnimatedContainer
  bool isContainerAnimating = false;

  @override
  void initState() {
    super.initState();

    //Item 1: Animation logo với AnimatedWidget
    logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    logoAnimation = CurvedAnimation(
      parent: logoController,
      curve: Curves.fastLinearToSlowEaseIn,
    )..addStatusListener((status) => _loop(logoController, status));

    // Item 2: Animation logo với AnimatedBuilder
    growController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    growAnimation = Tween<double>(begin: 0, end: 100).animate(growController)
      ..addStatusListener((status) => _loop(growController, status));
  }

  // Lặp animation: chạy tới rồi lùi lại liên tục
  void _loop(AnimationController controller, AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      controller.reverse();
    } else if (status == AnimationStatus.dismissed) {
      controller.forward();
    }
  }

  void _toggleLogo() {
    setState(() {
      isLogoAnimating = !isLogoAnimating;
      isLogoAnimating ? logoController.forward() : logoController.stop();
    });
  }

  void _toggleGrow() {
    setState(() {
      isGrowAnimating = !isGrowAnimating;
      isGrowAnimating ? growController.forward() : growController.stop();
    });
  }

  void _toggleContainer() {
    setState(() {
      isContainerAnimating = !isContainerAnimating;
    });
  }

  // Mỗi item: widget animation + mô tả + nút bấm riêng
  Widget _buildItem({
    required Widget animatedWidget,
    required String description,
    required bool isAnimating,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Column(
        children: [
          SizedBox(height: 120, child: animatedWidget),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onPressed,
            icon: Icon(isAnimating ? Icons.pause : Icons.play_arrow),
            label: Text(isAnimating ? 'Tạm dừng' : 'Bắt đầu'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animations Screen')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildItem(
              animatedWidget: AnimatedLogo(animation: logoAnimation),
              description: 'AnimatedWidget',
              isAnimating: isLogoAnimating,
              onPressed: _toggleLogo,
            ),
            const SizedBox(width: 16),
            _buildItem(
              animatedWidget: GrowTransition(
                animation: growAnimation,
                child: const LogoWidget(),
              ),
              description: 'AnimatedBuilder',
              isAnimating: isGrowAnimating,
              onPressed: _toggleGrow,
            ),
            _buildItem(
              animatedWidget: AnimatedContainerExample(
                selected: isContainerAnimating,
              ),
              description: 'AnimatedContainer',
              isAnimating: isContainerAnimating,
              onPressed: _toggleContainer,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    logoController.dispose();
    growController.dispose();
    super.dispose();
  }
}
