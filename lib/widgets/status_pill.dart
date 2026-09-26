import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  final Color backgroundColor;

  const StatusPill({
    super.key,
    required this.label,
    required this.color,
    required this.backgroundColor,
  });

  factory StatusPill.processed() => const StatusPill(
        label: 'Processed',
        color: AppColors.primary,
        backgroundColor: AppColors.primaryTint15,
      );

  factory StatusPill.pending() => const StatusPill(
        label: 'Pending',
        color: AppColors.pending,
        backgroundColor: AppColors.pendingTint,
      );

  factory StatusPill.failed() => const StatusPill(
        label: 'Failed',
        color: AppColors.error,
        backgroundColor: AppColors.errorTint,
      );

  factory StatusPill.forStatus(String status) {
    switch (status.toLowerCase()) {
      case 'processed':
        return StatusPill.processed();
      case 'pending':
        return StatusPill.pending();
      case 'failed':
        return StatusPill.failed();
      default:
        return StatusPill(
          label: status,
          color: AppColors.textSecondary,
          backgroundColor: AppColors.divider,
        );
    }
  }

  factory StatusPill.phenology(String stage) => StatusPill(
        label: stage,
        color: AppColors.primaryLight,
        backgroundColor: AppColors.primaryTint15,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
