import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/app_colors.dart';
import 'drone_icon.dart';

class VcBottomNav extends StatelessWidget {
  const VcBottomNav({super.key});

  static const _tabs = [
    _NavTab(
      icon: '🏠',
      label: 'Home',
      path: '/dashboard',
    ),
    _NavTab(
      icon: '🍇',
      label: 'Farms',
      path: '/farms',
    ),
    _NavTab(
      icon: '',
      label: 'Flights',
      path: '/flights',
      isDrone: true,
    ),
    _NavTab(
      icon: '🌱',
      label: 'Phenology',
      path: '/phenology',
    ),
    _NavTab(
      icon: '🖼️',
      label: 'Outcome',
      path: '/outcome',
    ),
    _NavTab(
      icon: '🔔',
      label: 'Alerts',
      path: '/notifications',
    ),
  ];

  int _currentIndex(String location) {
    for (int i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].path)) {
        return i;
      }
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _currentIndex(location);

    return Container(
      height: 82,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.divider,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final isActive = i == currentIndex;

            return Expanded(
              child: GestureDetector(
                onTap: () => context.go(_tabs[i].path),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Container(
                    margin: isActive
                        ? const EdgeInsets.symmetric(horizontal: 2)
                        : null,
                    decoration: isActive
                        ? BoxDecoration(
                            color: AppColors.navActiveBg,
                            borderRadius: BorderRadius.circular(12),
                          )
                        : null,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _tabs[i].isDrone
                            ? DroneIcon(
                                size: 22,
                                color: isActive
                                    ? AppColors.navActive
                                    : AppColors.navInactive,
                              )
                            : Text(
                                _tabs[i].icon,
                                style: const TextStyle(fontSize: 22),
                              ),
                        const SizedBox(height: 2),
                        Text(
                          _tabs[i].label,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                            color: isActive
                                ? AppColors.navActive
                                : AppColors.navInactive,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavTab {
  final String icon;
  final String label;
  final String path;
  final bool isDrone;

  const _NavTab({
    required this.icon,
    required this.label,
    required this.path,
    this.isDrone = false,
  });
}
