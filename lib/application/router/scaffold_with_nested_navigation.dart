import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: const [
          NavigationDestination(
            label: 'Chat',
            icon: Icon(Icons.chat_outlined),
            selectedIcon: Icon(Icons.chat),
          ),
          NavigationDestination(
            label: 'History',
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark),
          ),
          NavigationDestination(
            label: 'Profile',
            icon: Icon(Icons.person_2_outlined),
            selectedIcon: Icon(Icons.person_2),
          ),
        ],
        onDestinationSelected: _goBranch,
      ),
    );
  }
}
