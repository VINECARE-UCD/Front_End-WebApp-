import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../core/app_colors.dart';
import '../models/block.dart';
import '../models/ndvi_outcome.dart';

/// Output / Outcome tab (meeting-notes item 3).
///
/// Block 1 (Cabernet Sauvignon) now shows its real per-flight NDVI output
/// reports — the agriculturalist's actual drone-pipeline PDFs, one per
/// flight window, bundled as app assets and organised in
/// models/ndvi_outcome.dart. Every other block still shows the honest
/// "coming soon" placeholder below, because no reports have arrived for
/// them yet — this is not backend-generated, it's the same
/// "real-data-as-static-asset" pattern already used for pest_risk.dart.
///
/// Can be opened pre-scrolled to a specific block/flight (e.g. from the
/// Phenology diagram's "View NDVI image for this flight" link) via
/// [initialBlockId] / [initialFlightNumber].
class OutcomeScreen extends StatefulWidget {
  final String? initialBlockId;
  final int? initialFlightNumber;

  const OutcomeScreen({
    super.key,
    this.initialBlockId,
    this.initialFlightNumber,
  });

  @override
  State<OutcomeScreen> createState() => _OutcomeScreenState();
}

class _OutcomeScreenState extends State<OutcomeScreen> {
  final Map<String, GlobalKey> _sectionKeys = {};

  @override
  void initState() {
    super.initState();
    if (widget.initialBlockId != null) {
      // Scroll to the requested block's section once the list has laid
      // out — a single frame after the first build.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final key = _sectionKeys[widget.initialBlockId];
        final ctx = key?.currentContext;
        if (ctx != null) {
          Scrollable.ensureVisible(
            ctx,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
            alignment: 0.05,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final blocksWithOutput =
        Block.mockBlocks.where((b) => BlockOutcomes.forBlock(b.id) != null);
    final blocksPending =
        Block.mockBlocks.where((b) => BlockOutcomes.forBlock(b.id) == null);

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
                    'Output / Outcome',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'KOKOTOS ESTATE',
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
                // Real output — one section per block that has reports.
                for (final block in blocksWithOutput) ...[
                  _BlockOutcomeSection(
                    key: _sectionKeys.putIfAbsent(block.id, () => GlobalKey()),
                    block: block,
                    outcomes: BlockOutcomes.forBlock(block.id)!,
                    initialFlightNumber: block.id == widget.initialBlockId
                        ? widget.initialFlightNumber
                        : null,
                  ),
                  const SizedBox(height: 20),
                ],

                // Explanation + list for blocks still pending reports.
                if (blocksPending.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: AppColors.gold.withValues(alpha: 0.35)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.goldTint,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'COMING SOON',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.gold,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const _PlanRow(
                          label: 'What',
                          body:
                              'Show the actual generated result for each block — the '
                              'processed NDVI/health image the pipeline produces from a '
                              'flight — so you can see the outcome directly, not just the '
                              'underlying numbers.',
                        ),
                        const SizedBox(height: 12),
                        const _PlanRow(
                          label: 'How',
                          body:
                              'Block 1 above shows this working end to end with real '
                              'reports. The remaining blocks will get the same treatment '
                              'as soon as their NDVI reports arrive.',
                        ),
                        const SizedBox(height: 12),
                        const _PlanRow(
                          label: 'When',
                          body:
                              'No fixed date yet for the other 4 blocks — waiting on '
                              'reports from the agriculturalist/drone pipeline.',
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      'Pending output',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  ...blocksPending.map((b) => Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.inputField,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text('🖼️', style: TextStyle(fontSize: 18)),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Block ${b.id} — ${b.variety}',
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  const Text(
                                    'Output image will appear here once its NDVI reports arrive',
                                    style: TextStyle(
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
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.inputField,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'SOON',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textMuted,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One block's full output section: a flight selector (chips, one per
/// NDVI report received) plus the selected flight's map image and zone
/// breakdown. Can open pre-selected to [initialFlightNumber] (matching
/// [FlightOutcome.flightNumber], 1-6) instead of defaulting to the latest.
class _BlockOutcomeSection extends StatefulWidget {
  final Block block;
  final BlockOutcomes outcomes;
  final int? initialFlightNumber;

  const _BlockOutcomeSection({
    super.key,
    required this.block,
    required this.outcomes,
    this.initialFlightNumber,
  });

  @override
  State<_BlockOutcomeSection> createState() => _BlockOutcomeSectionState();
}

class _BlockOutcomeSectionState extends State<_BlockOutcomeSection> {
  // `late` defers evaluation to first access (after initState), so it's
  // safe to read `widget` here.
  late int _selectedIndex = _initialIndex();

  int _initialIndex() {
    final requested = widget.initialFlightNumber;
    if (requested != null) {
      final idx =
          widget.outcomes.flights.indexWhere((f) => f.flightNumber == requested);
      if (idx >= 0) return idx;
    }
    return widget.outcomes.flights.length - 1; // default: latest flight
  }

  @override
  void didUpdateWidget(covariant _BlockOutcomeSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If we're re-navigated to this same screen with a different flight
    // requested (e.g. tapping a different Phenology stage), jump to it.
    if (widget.initialFlightNumber != null &&
        widget.initialFlightNumber != oldWidget.initialFlightNumber) {
      final idx = widget.outcomes.flights
          .indexWhere((f) => f.flightNumber == widget.initialFlightNumber);
      if (idx >= 0) setState(() => _selectedIndex = idx);
    }
  }

  @override
  Widget build(BuildContext context) {
    final flight = widget.outcomes.flights[_selectedIndex];
    final dateLabel = DateFormat('d MMM yyyy').format(flight.date);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Block ${widget.block.id} — ${widget.block.variety}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'LIVE REPORT',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: AppColors.gold,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Flight selector chips.
          SizedBox(
            height: 32,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.outcomes.flights.length,
              separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (context, i) {
                final f = widget.outcomes.flights[i];
                final selected = i == _selectedIndex;
                return GestureDetector(
                  onTap: () => setState(() => _selectedIndex = i),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected ? AppColors.gold : AppColors.inputField,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Flight ${f.flightNumber} · ${DateFormat('d MMM').format(f.date)}',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.black : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // The report image itself.
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              flight.imageAsset,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Container(
                height: 160,
                color: AppColors.inputField,
                alignment: Alignment.center,
                child: const Text(
                  'Report image missing from assets',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          Text(
            '$dateLabel · ${flight.growthStage}',
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          if (flight.meanCanopyNdvi != null) ...[
            const SizedBox(height: 2),
            Text(
              'Mean sampled canopy NDVI: ${flight.meanCanopyNdvi}'
              '${flight.usableCaptures != null ? ' · ${flight.usableCaptures} usable captures' : ''}',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
          ],
          const SizedBox(height: 10),

          // Zone breakdown.
          ...flight.zones.map((z) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${z.label}  (${z.ndviRange}'
                      '${z.sampledShare != null ? ' · ${z.sampledShare} of canopy' : ''})',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${z.description} ${z.action}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 4),
          Text(
            flight.observation,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 11.5,
              fontStyle: FontStyle.italic,
              color: AppColors.textMuted,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanRow extends StatelessWidget {
  final String label;
  final String body;
  const _PlanRow({required this.label, required this.body});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.gold,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          body,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 12,
            color: AppColors.textSecondary,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
