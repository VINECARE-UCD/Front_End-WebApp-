import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../models/block.dart';
import 'status_pill.dart';
import 'weather_kpi.dart';

class BlockCard extends StatelessWidget {
  final Block block;
  final VoidCallback? onTap;

  const BlockCard({
    super.key,
    required this.block,
    this.onTap,
  });

  static const _varietyColors = {
    'Gewurztraminer': Color(0xFFE1B444),
    'Assyrtiko': Color(0xFF318E52),
    'Merlot': Color(0xFF8B5CF6),
    'Chardonnay': Color(0xFF3B82F6),
    'Cabernet Sauvignon': Color(0xFFDC2626),
  };

  @override
  Widget build(BuildContext context) {
    final accentColor = _varietyColors[block.variety] ?? AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(
          left: 0,
          right: 16,
          top: 16,
          bottom: 16,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            // Accent bar
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Block ID badge
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  block.id,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: accentColor,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 12),

            // Block information
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    block.variety,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    '${block.farm} · ${block.hectares} ha',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  // GPS coordinates
                  if (block.latitude != null && block.longitude != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      '📍 ${block.latitude!.toStringAsFixed(4)}°N '
                      '${block.longitude!.toStringAsFixed(4)}°E',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],

                  const SizedBox(height: 4),

                  Text(
                    '4 GPS points · Last flight: ${block.lastFlightLabel}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                  ),

                  // Known issues
                  if (block.knownIssues != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      '⚠️ ${block.knownIssues}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.gold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  // Live weather
                  if (block.latitude != null && block.longitude != null)
                    WeatherKpi(
                      latitude: block.latitude!,
                      longitude: block.longitude!,
                    ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // Phenology status
            StatusPill.phenology(
              block.phenologyStage,
            ),
          ],
        ),
      ),
    );
  }
}
