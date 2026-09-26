import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import 'drone_icon.dart';

class KpiCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final VoidCallback? onTap;
  final bool isDrone;

  const KpiCard({
    super.key,
    required this.emoji,
    required this.value,
    required this.label,
    this.onTap,
    this.isDrone = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isDrone
                ? const DroneIcon(
                    size: 22,
                    color: Colors.amber,
                  )
                : Text(
                    emoji,
                    style: const TextStyle(fontSize: 22),
                  ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
