/// Real per-flight NDVI output reports, sourced directly from the
/// agriculturalist's drone-pipeline PDFs (forwarded by email, Sept 2026).
/// Each report is one flight's NDVI vigor-zone map + recommended actions
/// for a block, matched by date to the same flight windows already
/// defined in pest_risk.dart (same spreadsheet, same 6 windows/season).
///
/// Only Block 1 (Cabernet Sauvignon — Upper) has reports so far; the
/// other 4 blocks are expected to follow later. `BlockOutcomes.forBlock`
/// returns null for a block with no reports yet, so callers can keep
/// showing "coming soon" for those rather than inventing data.
library;

class NdviZone {
  /// e.g. 'Zone A — High Vigor'
  final String label;

  /// e.g. 'NDVI > 0.55'
  final String ndviRange;

  /// Share of sampled canopy cells in this zone, e.g. '40.3%'.
  /// Not reported on the first two (earlier, simpler) flight reports.
  final String? sampledShare;

  /// Mean NDVI within the zone, e.g. '0.61'. Same availability caveat.
  final String? meanNdvi;

  final String description;
  final String action;

  const NdviZone({
    required this.label,
    required this.ndviRange,
    this.sampledShare,
    this.meanNdvi,
    required this.description,
    required this.action,
  });
}

class FlightOutcome {
  /// 1-6, matches the flight order in BlockPestRisk.windows for the same block.
  final int flightNumber;

  final DateTime date;

  /// Matches FlightRiskWindow.growthStage for the same flight, so the two
  /// datasets can be cross-linked from either screen.
  final String growthStage;

  /// Bundled report image (the actual NDVI map + zone overlay), registered
  /// as a Flutter asset — see pubspec.yaml.
  final String imageAsset;

  final List<NdviZone> zones;
  final String observation;

  /// Only reported from the 3rd flight onward.
  final int? usableCaptures;
  final String? meanCanopyNdvi;

  const FlightOutcome({
    required this.flightNumber,
    required this.date,
    required this.growthStage,
    required this.imageAsset,
    required this.zones,
    required this.observation,
    this.usableCaptures,
    this.meanCanopyNdvi,
  });
}

class BlockOutcomes {
  final String blockId;
  final List<FlightOutcome> flights;

  const BlockOutcomes({required this.blockId, required this.flights});

  static BlockOutcomes? forBlock(String blockId) {
    for (final b in all) {
      if (b.blockId == blockId) return b;
    }
    return null;
  }

  // Not `const`: FlightOutcome holds DateTime values, whose constructor
  // isn't const in Dart.
  static final all = <BlockOutcomes>[
    BlockOutcomes(
      blockId: '1',
      flights: [
        FlightOutcome(
          flightNumber: 1,
          date: _d(2026, 4, 20),
          growthStage: 'Budburst to Early Shoot Growth',
          imageAsset: 'assets/outcomes/block-1/flight-01.jpg',
          zones: [
            const NdviZone(
              label: 'Zone A — High Vigor',
              ndviRange: 'NDVI > 0.55',
              description: 'Vines are healthy and vigorous.',
              action: 'No immediate action. Monitor and maintain.',
            ),
            const NdviZone(
              label: 'Zone B — Medium Vigor',
              ndviRange: 'NDVI 0.40–0.55',
              description: 'Normal growth.',
              action:
                  'Monitor closely. Ensure adequate nutrition and irrigation.',
            ),
            const NdviZone(
              label: 'Zone C — Low Vigor',
              ndviRange: 'NDVI 0.20–0.40',
              description:
                  'Possible stress (water, nutrients, soil variability).',
              action:
                  'Inspect field. Check irrigation/nutrients. Targeted intervention recommended.',
            ),
          ],
          observation:
              'First flight of the season. Zones established as a baseline for the rest of the season.',
        ),
        FlightOutcome(
          flightNumber: 2,
          date: _d(2026, 5, 16),
          growthStage: 'Leaf Development',
          imageAsset: 'assets/outcomes/block-1/flight-02.jpg',
          zones: [
            const NdviZone(
              label: 'Zone A — High Vigor',
              ndviRange: 'NDVI > 0.55',
              description: 'Vines are healthy and vigorous.',
              action: 'No immediate action. Monitor and maintain.',
            ),
            const NdviZone(
              label: 'Zone B — Moderate Vigor',
              ndviRange: 'NDVI 0.40–0.55',
              description: 'Normal growth with slight variation.',
              action:
                  'Monitor closely. Ensure adequate nutrition and irrigation.',
            ),
            const NdviZone(
              label: 'Zone C — Low Vigor',
              ndviRange: 'NDVI 0.20–0.40',
              description: 'No areas detected in this flight.',
              action: 'Not applicable.',
            ),
          ],
          observation:
              'Overall vineyard shows healthy and uniform vigor. No significant stress detected.',
        ),
        FlightOutcome(
          flightNumber: 3,
          date: _d(2026, 6, 11),
          growthStage: 'Pre-Bloom to Flowering',
          imageAsset: 'assets/outcomes/block-1/flight-03.jpg',
          usableCaptures: 22,
          meanCanopyNdvi: '0.43',
          zones: [
            const NdviZone(
              label: 'Zone A — High Vigor',
              ndviRange: 'NDVI > 0.55',
              sampledShare: '40.3%',
              meanNdvi: '0.61',
              description: 'Healthy, active canopy.',
              action: 'Maintain current management. No corrective treatment required.',
            ),
            const NdviZone(
              label: 'Zone B — Moderate Vigor',
              ndviRange: 'NDVI 0.40–0.55',
              sampledShare: '29.1%',
              meanNdvi: '0.48',
              description: 'Normal spatial variation.',
              action: 'Check irrigation uniformity and nutrition; reassess next flight.',
            ),
            const NdviZone(
              label: 'Zone C — Possible Lower Vigor',
              ndviRange: 'NDVI 0.20–0.40',
              sampledShare: '30.7%',
              meanNdvi: '0.30',
              description: 'Possible canopy stress or mixed variability.',
              action:
                  'Inspect emitters, soil moisture and leaves. Test before treatment.',
            ),
          ],
          observation:
              'High and moderate vigor represent 69.3% of sampled canopy cells. Lower-NDVI clusters are sufficiently present to justify targeted field checks, but not an automatic diagnosis.',
        ),
        FlightOutcome(
          flightNumber: 4,
          date: _d(2026, 6, 25),
          growthStage: 'Fruit Set to Bunch Closure',
          imageAsset: 'assets/outcomes/block-1/flight-04.jpg',
          usableCaptures: 20,
          meanCanopyNdvi: '0.44',
          zones: [
            const NdviZone(
              label: 'Zone A — High Vigor',
              ndviRange: 'NDVI > 0.55',
              sampledShare: '33.5%',
              meanNdvi: '0.60',
              description: 'Healthy, active canopy.',
              action: 'Maintain current management and routine monitoring.',
            ),
            const NdviZone(
              label: 'Zone B — Moderate Vigor',
              ndviRange: 'NDVI 0.40–0.55',
              sampledShare: '38.7%',
              meanNdvi: '0.48',
              description: 'Normal spatial variation.',
              action: 'Check irrigation uniformity and nutrition; reassess next flight.',
            ),
            const NdviZone(
              label: 'Zone C — Possible Lower Vigor',
              ndviRange: 'NDVI 0.20–0.40',
              sampledShare: '27.8%',
              meanNdvi: '0.31',
              description: 'Potential localized canopy variability.',
              action:
                  'Prioritise field checks for irrigation, moisture and leaf symptoms.',
            ),
          ],
          observation:
              'The sampled canopy is generally healthy, with localized variability. High and moderate vigor represent 72.2% of classified sampled cells.',
        ),
        FlightOutcome(
          flightNumber: 5,
          date: _d(2026, 7, 18),
          growthStage: 'Veraison',
          imageAsset: 'assets/outcomes/block-1/flight-05.jpg',
          usableCaptures: 27,
          meanCanopyNdvi: '0.48',
          zones: [
            const NdviZone(
              label: 'Zone A — High Vigor',
              ndviRange: 'NDVI > 0.55',
              sampledShare: '27.0%',
              meanNdvi: '0.59',
              description: 'Healthy, active canopy.',
              action: 'Maintain current management; no corrective treatment required.',
            ),
            const NdviZone(
              label: 'Zone B — Moderate Vigor',
              ndviRange: 'NDVI 0.40–0.55',
              sampledShare: '50.0%',
              meanNdvi: '0.48',
              description: 'Dominant mid-season class.',
              action: 'Check irrigation uniformity and nutrition; reassess next flight.',
            ),
            const NdviZone(
              label: 'Zone C — Possible Lower Vigor',
              ndviRange: 'NDVI 0.30–0.40',
              sampledShare: '23.0%',
              meanNdvi: '0.35',
              description: 'Possible heat, water, soil or canopy variability.',
              action:
                  'Inspect emitters, soil moisture and leaves. Test before treatment.',
            ),
          ],
          observation:
              'High and moderate vigor represent 77.0% of sampled canopy cells. Lower-NDVI clusters justify targeted field checks, but not an automatic diagnosis. NDVI alone does not identify the cause of lower vigor.',
        ),
        FlightOutcome(
          flightNumber: 6,
          date: _d(2026, 8, 17),
          growthStage: 'Veraison to Harvest',
          imageAsset: 'assets/outcomes/block-1/flight-06.jpg',
          usableCaptures: 26,
          meanCanopyNdvi: '0.43',
          zones: [
            const NdviZone(
              label: 'Zone A — High Vigor',
              ndviRange: 'NDVI > 0.55',
              sampledShare: '31.2%',
              meanNdvi: '0.60',
              description: 'Healthy, active canopy.',
              action:
                  'Maintain balanced irrigation; avoid unnecessary late-season inputs.',
            ),
            const NdviZone(
              label: 'Zone B — Moderate Vigor',
              ndviRange: 'NDVI 0.40–0.55',
              sampledShare: '39.9%',
              meanNdvi: '0.49',
              description: 'Normal spatial variation.',
              action:
                  'Check irrigation uniformity and canopy condition; distinguish seasonal senescence from stress.',
            ),
            const NdviZone(
              label: 'Zone C — Possible Lower Vigor',
              ndviRange: 'NDVI 0.20–0.40',
              sampledShare: '28.9%',
              meanNdvi: '0.31',
              description: 'Potential localized canopy variability.',
              action:
                  'Inspect moisture, emitters and leaves; distinguish stress from premature senescence.',
            ),
          ],
          observation:
              'High and moderate vigor represent 71.1% of sampled canopy cells. Check lower-NDVI areas against normal late-season maturation and field symptoms before action.',
        ),
      ],
    ),
  ];
}

DateTime _d(int y, int m, int d) => DateTime(y, m, d);
