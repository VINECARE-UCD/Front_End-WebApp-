import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/app_colors.dart';
import '../models/block.dart';
import '../models/flight.dart';
import '../widgets/status_pill.dart';
import '../widgets/drone_icon.dart';
import '../widgets/pest_risk_section.dart';

class BlockDetailScreen extends StatelessWidget {
  final String blockId;

  const BlockDetailScreen({
    super.key,
    required this.blockId,
  });

  Block get _block => Block.mockBlocks.firstWhere(
        (b) => b.id == blockId,
        orElse: () => Block.mockBlocks.first,
      );

  List<DroneFlight> get _flights =>
      DroneFlight.mockFlights.where((f) => f.blockId == blockId).toList();

  @override
  Widget build(BuildContext context) {
    final block = _block;
    final flights = _flights;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header
          Container(
            color: AppColors.surface,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              bottom: 12,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.go('/farms'),
                    child: const Text(
                      '← Blocks',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Block ${block.id}',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 60),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // Map placeholder
                Container(
                  height: 200,
                  color: const Color(0xFF0D1B12),
                  child: Stack(
                    children: [
                      // Grid lines
                      CustomPaint(
                        size: const Size(double.infinity, 200),
                        painter: _GridPainter(),
                      ),

                      // Block polygon placeholder
                      Center(
                        child: Container(
                          width: 120,
                          height: 70,
                          decoration: BoxDecoration(
                            color: AppColors.primaryTint20,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              block.id,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryLight,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 12,
                        left: 16,
                        child: Text(
                          '📍 ${block.latitude?.toStringAsFixed(4)}°N '
                          '${block.longitude?.toStringAsFixed(4)}°E · '
                          '${block.variety}',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Block info bar
                Container(
                  color: AppColors.surface,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              block.variety,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${block.farm} · eu-central-1',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTint15,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${block.hectares} ha',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Stats row
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: Row(
                    children: [
                      _StatTile(
                        emoji: '📊',
                        value: block.ndvi?.toStringAsFixed(2) ?? '—',
                        label: 'NDVI',
                      ),
                      const SizedBox(width: 8),

                      _StatTile(
                        emoji: '🌿',
                        value:
                            '${block.canopyCoverage?.toStringAsFixed(0) ?? '—'}%',
                        label: 'Coverage',
                      ),
                      const SizedBox(width: 8),

                      // Flights uses the proper drone icon
                      _StatTile(
                        value: '${block.flightCount}',
                        label: 'Flights',
                        isDrone: true,
                      ),
                      const SizedBox(width: 8),

                      _StatTile(
                        emoji: '📅',
                        value: block.lastFlightLabel,
                        label: 'Last Check',
                      ),
                    ],
                  ),
                ),

                if (block.knownIssues != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.gold.withValues(alpha: 0.4),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '⚠️',
                            style: TextStyle(fontSize: 16),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Known issues: ${block.knownIssues}',
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.gold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 20),

                // Recent flights
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Recent Flights',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                ...flights.map(
                  (f) => Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const DroneIcon(
                            size: 22,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  f.dateLabel,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${f.imageCount} images'
                                  '${f.ndvi != null ? ' · NDVI: ${f.ndvi!.toStringAsFixed(2)}' : ''}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                if (f.s3Key != null)
                                  const Text(
                                    'Stored in S3',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 11,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          StatusPill.forStatus(f.status),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Phenotype / disease-pressure section, sourced from the
                // agriculturalist's spreadsheet, with a link through to
                // this block's drone imagery on the Flights tab.
                PestRiskSection(blockId: block.id),

                // New flight button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () => context.go('/flights'),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DroneIcon(
                            size: 20,
                            color: Colors.white,
                          ),
                          SizedBox(width: 8),
                          Text('New Drone Flight'),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String? emoji;
  final String value;
  final String label;
  final bool isDrone;

  const _StatTile({
    this.emoji,
    required this.value,
    required this.label,
    this.isDrone = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            isDrone
                ? const DroneIcon(
                    size: 20,
                    color: Colors.amber,
                  )
                : Text(
                    emoji ?? '',
                    style: const TextStyle(fontSize: 20),
                  ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 9,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.divider.withValues(alpha: 0.3)
      ..strokeWidth = 0.5;

    const step = 25.0;

    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
