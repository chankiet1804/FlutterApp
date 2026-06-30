import 'package:flutter/material.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/widgets/animations/animated_container.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/widgets/animations/animated_logo_builder.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/widgets/animations/animated_logo_widget.dart';
import 'package:flutter_app/src/features/widget_catalog/presentation/widgets/animations/tween_animation_builder.dart';

class AnimationsScreen extends StatefulWidget {
  const AnimationsScreen({super.key});
  @override
  State<AnimationsScreen> createState() => _AnimationsScreenState();
}

class _AnimationsScreenState extends State<AnimationsScreen>
    with TickerProviderStateMixin {
  // Số cột mỗi hàng và khoảng cách giữa các item
  static const int _columns = 2;
  static const double _spacing = 16;

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

  // Mỗi item: widget animation + mô tả + phần điều khiển riêng.
  // [width] do hàng cha tính sẵn để vừa [_columns] item trên 1 hàng.
  Widget _buildItem({
    required double width,
    required Widget animatedWidget,
    required String description,
    required Widget control,
  }) {
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 120, child: Center(child: animatedWidget)),
              const SizedBox(height: 16),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              control,
            ],
          ),
        ),
      ),
    );
  }

  // Nút bật/tắt dùng chung cho các item có điều khiển thủ công
  Widget _toggleButton(bool isAnimating, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(isAnimating ? Icons.pause : Icons.play_arrow),
      label: Text(isAnimating ? 'Tạm dừng' : 'Bắt đầu'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Animations Screen')),
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Trừ padding ngang (16 * 2) và khoảng cách giữa các cột,
          // phần còn lại chia đều cho _columns item -> đúng 3 widget/hàng.
          final itemWidth =
              (constraints.maxWidth - 32 - _spacing * (_columns - 1)) /
              _columns;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            // Wrap: đủ 3 item sẽ tự xuống hàng khi thêm item mới
            child: Wrap(
              spacing: _spacing,
              runSpacing: _spacing,
              children: [
                _buildItem(
                  width: itemWidth,
                  animatedWidget: AnimatedLogo(animation: logoAnimation),
                  description: 'AnimatedWidget',
                  control: _toggleButton(isLogoAnimating, _toggleLogo),
                ),
                _buildItem(
                  width: itemWidth,
                  animatedWidget: GrowTransition(
                    animation: growAnimation,
                    child: const LogoWidget(),
                  ),
                  description: 'AnimatedBuilder',
                  control: _toggleButton(isGrowAnimating, _toggleGrow),
                ),
                _buildItem(
                  width: itemWidth,
                  animatedWidget: AnimatedContainerExample(
                    selected: isContainerAnimating,
                  ),
                  description: 'AnimatedContainer',
                  control: _toggleButton(
                    isContainerAnimating,
                    _toggleContainer,
                  ),
                ),
                _buildItem(
                  width: itemWidth,
                  animatedWidget: const TweenAnimationBuilderExample(),
                  description: 'TweenAnimationBuilder',
                  control: const Text(
                    'Chạm vào icon để phóng to',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          );
        },
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
