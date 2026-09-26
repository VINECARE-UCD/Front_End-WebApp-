import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/app_colors.dart';
import '../models/block.dart';
import '../models/pest_risk.dart';
import '../models/ndvi_outcome.dart';

/// Phenology tab (meeting-notes item 1.b) — one diagram per block, each
/// a tappable stepper timeline through the agriculturalist's 6 flight
/// windows, linking straight into that block's own drone imagery in the
/// Flights tab. Per-block data comes directly from [BlockPestRisk],
/// which already encodes "Rules for NDVI Estate Kokotos.xlsx" per block
/// — no new agriculturalist input needed for this restructure. Previously
/// this screen showed one shared calendar for all blocks; this replaces
/// that with a genuinely separate diagram per block, as requested.
class PhenologyScreen extends StatelessWidget {
  const PhenologyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final blocks = Block.mockBlocks
        .where((b) => BlockPestRisk.forBlock(b.id) != null)
        .toList();

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
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Text(
                    'Phenology Tracking',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'One diagram per block · Rules for NDVI Estate Kokotos',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Dormancy — before the flight season begins, shown once
                // as context for every block's diagram below.
                Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    children: [
                      Text('💤', style: TextStyle(fontSize: 20)),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dormancy',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Before the flight season begins — no scouting flight, '
                              'applies to every block below',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // One diagram per block.
                for (final block in blocks)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _BlockPhenologyDiagram(
                      block: block,
                      risk: BlockPestRisk.forBlock(block.id)!,
                    ),
                  ),

                const Text(
                  'Disease/pest risks shown are the agriculturalist\'s rules for '
                  'each flight window, applied per block. Tap a stage to see its '
                  'window and risks, or open that block\'s drone imagery directly.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BlockPhenologyDiagram extends StatefulWidget {
  final Block block;
  final BlockPestRisk risk;
  const _BlockPhenologyDiagram({required this.block, required this.risk});

  @override
  State<_BlockPhenologyDiagram> createState() =>
      _BlockPhenologyDiagramState();
}

class _BlockPhenologyDiagramState extends State<_BlockPhenologyDiagram> {
  static const _phaseEmoji = {
    'Budburst to Early Shoot Growth': '🌱',
    'Leaf Development': '🌿',
    'Pre-Bloom to Flowering': '🌸',
    'Fruit Set to Bunch Closure': '🍇',
    'Veraison': '🟣',
    'Veraison to Harvest': '✂️',
  };

  late int _selectedIndex;

  int get _currentIndex => widget.risk.windows
      .indexWhere((w) => w.growthStage == widget.block.phenologyStage);

  /// The real NDVI report for the *currently selected* stage, if this
  /// block has one. Windows and outcome flights are both ordered 1st
  /// flight..6th flight for the same season, so the stage's position in
  /// the stepper (_selectedIndex) maps directly to FlightOutcome.flightNumber
  /// (1-based) — e.g. tapping "Budburst" (index 0) links to Flight 1,
  /// 20 April; tapping "Leaf Development" (index 1) links to Flight 2,
  /// 2-16 May; and so on for all 6 stages.
  FlightOutcome? get _matchingOutcome {
    final outcomes = BlockOutcomes.forBlock(widget.block.id);
    if (outcomes == null) return null;
    final flightNumber = _selectedIndex + 1;
    for (final f in outcomes.flights) {
      if (f.flightNumber == flightNumber) return f;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    final current = _currentIndex;
    _selectedIndex = current >= 0 ? current : 0;
  }

  @override
  Widget build(BuildContext context) {
    final windows = widget.risk.windows;
    final selected = windows[_selectedIndex];
    final currentIndex = _currentIndex;
    final matchingOutcome = _matchingOutcome;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Block header
          Row(
            children: [
              Expanded(
                child: Text(
                  'Block ${widget.block.id} — ${widget.risk.variety}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              // Only claim a "current stage" badge when the block's own
              // stage exactly matches one of this diagram's windows —
              // no guessing at a mapping between shorthand phenology
              // labels ("Vine Dev.") and the spreadsheet's full stage
              // names when there isn't an exact match.
              if (currentIndex >= 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTint15,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Now: ${widget.block.phenologyStage}',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryLight,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          // Stepper diagram — tap any stage to see its window + risks.
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              for (int i = 0; i < windows.length; i++) ...[
                _StageNode(
                  emoji: _phaseEmoji[windows[i].growthStage] ?? '🍃',
                  isSelected: i == _selectedIndex,
                  isCurrent: i == currentIndex,
                  onTap: () => setState(() => _selectedIndex = i),
                ),
                if (i != windows.length - 1)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: currentIndex >= 0 && i < currentIndex
                          ? AppColors.primary.withValues(alpha: 0.4)
                          : AppColors.divider,
                    ),
                  ),
              ],
            ],
          ),
          const SizedBox(height: 12),

          // Selected stage detail.
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.inputField,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        selected.growthStage,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        selected.elStage,
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  selected.flightLabel,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: selected.risks
                      .map((r) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.goldTint,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              r,
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10,
                                color: AppColors.gold,
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    if (matchingOutcome != null) {
                      // This stage has a real NDVI report for its date —
                      // jump straight to it in the Outcome tab.
                      context.go(
                        '/outcome?block=${widget.block.id}&flight=${matchingOutcome.flightNumber}',
                      );
                    } else {
                      // No report for this stage yet — fall back to the
                      // block's drone-upload/imagery screen.
                      context.go('/flights?block=${widget.block.id}');
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        matchingOutcome != null
                            ? 'View NDVI image for ${selected.flightLabel.split('·').last.trim()} →'
                            : 'Open drone images for this block →',
                        style: const TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primaryLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StageNode extends StatelessWidget {
  final String emoji;
  final bool isSelected;
  final bool isCurrent;
  final VoidCallback onTap;

  const _StageNode({
    required this.emoji,
    required this.isSelected,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isCurrent
        ? AppColors.primary
        : (isSelected ? AppColors.primaryLight : AppColors.divider);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCurrent ? AppColors.primaryTint15 : AppColors.inputField,
          border: Border.all(
            color: borderColor,
            width: isSelected || isCurrent ? 2 : 1,
          ),
        ),
        child: Center(
          child: Text(emoji, style: const TextStyle(fontSize: 15)),
        ),
      ),
    );
  }
}
