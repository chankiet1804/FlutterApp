import 'package:flutter/material.dart';
import 'package:flutter_app/src/state/counter_provider.dart';
import 'package:provider/provider.dart';
import '../features/widget_catalog/presentation/screens/widgets_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/settings/presentation/screens/settings_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int currentPageIndex = 0;

  // Danh sách màn hình đã được tách ra
  final List<Widget> _screens = const [
    HomeScreen(),
    WidgetsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter App'),
        backgroundColor: context
            .watch<CounterProvider>()
            .color, // Lấy màu từ CounterProvider
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'inc',
            onPressed: () async {
              await context.read<CounterProvider>().add();
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            heroTag: 'dec',
            onPressed: () async {
              await context.read<CounterProvider>().remove();
            },
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            heroTag: 'changeColor',
            onPressed: () {
              context.read<CounterProvider>().changeColor();
            },
            child: const Icon(Icons.color_lens),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(icon: (Icon(Icons.widgets)), label: 'Widgets'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
      body: _screens[currentPageIndex],
    );
  }
}
