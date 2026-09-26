import 'package:flutter/material.dart';
import '../widgets/vc_bottom_nav.dart';

/// Shell wrapper that holds the persistent bottom nav bar
class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const VcBottomNav(),
    );
  }
}
