/// Disease & pest risk windows per block, sourced directly from the
/// agriculturalist's spreadsheet ("Rules for NDVI Estate Kokotos.xlsx",
/// forwarded 10 Aug meeting). Each block has 6 flight windows; each
/// window lists the diseases/pests to scout for during that phenology
/// stage. Block numbering here follows the spreadsheet (not the overview
/// map image, which numbers blocks differently — see the tech report
/// note flagging that mismatch).
class FlightRiskWindow {
  final String flightLabel;
  final String elStage;
  final String growthStage;
  final List<String> risks;

  const FlightRiskWindow({
    required this.flightLabel,
    required this.elStage,
    required this.growthStage,
    required this.risks,
  });
}

class BlockPestRisk {
  final String blockId;
  final String variety;
  final List<FlightRiskWindow> windows;

  const BlockPestRisk({
    required this.blockId,
    required this.variety,
    required this.windows,
  });

  /// Look up the pest/disease rules for a given block ID (as used by
  /// the Farms/Flights API — "1".."5"). Returns null if this block
  /// isn't covered by the agriculturalist's rules yet (e.g. mock/demo
  /// block IDs), so callers can hide the section gracefully.
  static BlockPestRisk? forBlock(String blockId) {
    for (final b in all) {
      if (b.blockId == blockId) return b;
    }
    return null;
  }

  static const all = <BlockPestRisk>[
    BlockPestRisk(
      blockId: '2',
      variety: 'Chardonnay',
      windows: [
        FlightRiskWindow(
          flightLabel: '1st Flight · 1–20 April',
          elStage: 'EL 1–9',
          growthStage: 'Budburst to Early Shoot Growth',
          risks: [
            'Phomopsis viticola (Phomopsis)',
            'Elsinoë ampelina (Black spot)',
            'Plasmopara viticola (Downy mildew)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '2nd Flight · 2–16 May',
          elStage: 'EL 10–15',
          growthStage: 'Leaf Development',
          risks: [
            'Phomopsis viticola (Phomopsis)',
            'Plasmopara viticola (Downy mildew)',
            'Erysiphe necator (Powdery mildew)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '3rd Flight · 3–11 June',
          elStage: 'EL 17–25',
          growthStage: 'Pre-Bloom to Flowering',
          risks: [
            'Plasmopara viticola (Downy mildew)',
            'Erysiphe necator (Powdery mildew)',
            'Botrytis cinerea (Botrytis)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '4th Flight · 4–25 June',
          elStage: 'EL 27–33',
          growthStage: 'Fruit Set to Bunch Closure',
          risks: [
            'Plasmopara viticola (Downy mildew)',
            'Erysiphe necator (Powdery mildew)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '5th Flight · 5–18 July',
          elStage: 'EL 34–35',
          growthStage: 'Veraison',
          risks: [
            'Plasmopara viticola (Downy mildew)',
            'Erysiphe necator (Powdery mildew)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '6th Flight · 6–17 August',
          elStage: 'EL 38',
          growthStage: 'Veraison to Harvest',
          risks: [
            'Botrytis cinerea (Botrytis)',
            'Guignardia bidwellii (Black Rot)',
          ],
        ),
      ],
    ),
    BlockPestRisk(
      blockId: '1',
      variety: 'Cabernet Sauvignon',
      windows: [
        FlightRiskWindow(
          flightLabel: '1st Flight · 1–20 April',
          elStage: 'EL 1–9',
          growthStage: 'Budburst to Early Shoot Growth',
          risks: [
            'Phomopsis viticola (Phomopsis)',
            'Elsinoë ampelina (Black spot)',
            'Plasmopara viticola (Downy mildew)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '2nd Flight · 2–16 May',
          elStage: 'EL 10–15',
          growthStage: 'Leaf Development',
          risks: [
            'Phomopsis viticola (Phomopsis)',
            'Plasmopara viticola (Downy mildew)',
            'Erysiphe necator (Powdery mildew)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '3rd Flight · 3–11 June',
          elStage: 'EL 17–25',
          growthStage: 'Pre-Bloom to Flowering',
          risks: [
            'Plasmopara viticola (Downy mildew)',
            'Erysiphe necator (Powdery mildew)',
            'Botrytis cinerea (Botrytis)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '4th Flight · 4–25 June',
          elStage: 'EL 27–33',
          growthStage: 'Fruit Set to Bunch Closure',
          risks: [
            'Plasmopara viticola (Downy mildew)',
            'Erysiphe necator (Powdery mildew)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '5th Flight · 5–18 July',
          elStage: 'EL 34–35',
          growthStage: 'Veraison',
          risks: [
            'Plasmopara viticola (Downy mildew)',
            'Erysiphe necator (Powdery mildew)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '6th Flight · 6–17 August',
          elStage: 'EL 38',
          growthStage: 'Veraison to Harvest',
          risks: [
            'Botrytis cinerea (Botrytis)',
          ],
        ),
      ],
    ),
    BlockPestRisk(
      blockId: '4',
      variety: 'Assyrtiko',
      windows: [
        FlightRiskWindow(
          flightLabel: '1st Flight · 1–20 April',
          elStage: 'EL 1–9',
          growthStage: 'Budburst to Early Shoot Growth',
          risks: [
            'Phomopsis viticola (Phomopsis)',
            'Elsinoë ampelina (Black spot)',
            'Plasmopara viticola (Downy mildew)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '2nd Flight · 2–16 May',
          elStage: 'EL 10–15',
          growthStage: 'Leaf Development',
          risks: [
            'Phomopsis viticola (Phomopsis)',
            'Plasmopara viticola (Downy mildew)',
            'Erysiphe necator (Powdery mildew)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '3rd Flight · 3–11 June',
          elStage: 'EL 17–25',
          growthStage: 'Pre-Bloom to Flowering',
          risks: [
            'Plasmopara viticola (Downy mildew)',
            'Erysiphe necator (Powdery mildew)',
            'Botrytis cinerea (Botrytis)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '4th Flight · 4–25 June',
          elStage: 'EL 27–33',
          growthStage: 'Fruit Set to Bunch Closure',
          risks: [
            'Plasmopara viticola (Downy mildew)',
            'Erysiphe necator (Powdery mildew)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '5th Flight · 5–18 July',
          elStage: 'EL 34–35',
          growthStage: 'Veraison',
          risks: [
            'Plasmopara viticola (Downy mildew)',
            'Erysiphe necator (Powdery mildew)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '6th Flight · 6–17 August',
          elStage: 'EL 38',
          growthStage: 'Veraison to Harvest',
          risks: [
            'Botrytis cinerea (Botrytis)',
          ],
        ),
      ],
    ),
    BlockPestRisk(
      blockId: '5',
      variety: 'Gewurztraminer',
      windows: [
        FlightRiskWindow(
          flightLabel: '1st Flight · 1–20 April',
          elStage: 'EL 1–9',
          growthStage: 'Budburst to Early Shoot Growth',
          risks: [
            'Phomopsis viticola (Phomopsis)',
            'Elsinoë ampelina (Black spot)',
            'Plasmopara viticola (Downy mildew)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '2nd Flight · 2–16 May',
          elStage: 'EL 10–15',
          growthStage: 'Leaf Development',
          risks: [
            'Phomopsis viticola (Phomopsis)',
            'Plasmopara viticola (Downy mildew)',
            'Erysiphe necator (Powdery mildew)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '3rd Flight · 3–11 June',
          elStage: 'EL 17–25',
          growthStage: 'Pre-Bloom to Flowering',
          risks: [
            'Plasmopara viticola (Downy mildew)',
            'Erysiphe necator (Powdery mildew)',
            'Botrytis cinerea (Botrytis)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '4th Flight · 4–25 June',
          elStage: 'EL 27–33',
          growthStage: 'Fruit Set to Bunch Closure',
          risks: [
            'Plasmopara viticola (Downy mildew)',
            'Erysiphe necator (Powdery mildew)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '5th Flight · 5–18 July',
          elStage: 'EL 34–35',
          growthStage: 'Veraison',
          risks: [
            'Plasmopara viticola (Downy mildew)',
            'Erysiphe necator (Powdery mildew)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '6th Flight · 6–17 August',
          elStage: 'EL 38',
          growthStage: 'Veraison to Harvest',
          risks: [
            'Botrytis cinerea (Botrytis)',
            'Guignardia bidwellii (Black Rot)',
          ],
        ),
      ],
    ),
    BlockPestRisk(
      blockId: '3',
      variety: 'Merlot',
      windows: [
        FlightRiskWindow(
          flightLabel: '1st Flight · 1–20 April',
          elStage: 'EL 1–9',
          growthStage: 'Budburst to Early Shoot Growth',
          risks: [
            'Phomopsis viticola (Phomopsis)',
            'Elsinoë ampelina (Black spot)',
            'Plasmopara viticola (Downy mildew)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '2nd Flight · 2–16 May',
          elStage: 'EL 10–15',
          growthStage: 'Leaf Development',
          risks: [
            'Phomopsis viticola (Phomopsis)',
            'Plasmopara viticola (Downy mildew)',
            'Erysiphe necator (Powdery mildew)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '3rd Flight · 3–11 June',
          elStage: 'EL 17–25',
          growthStage: 'Pre-Bloom to Flowering',
          risks: [
            'Plasmopara viticola (Downy mildew)',
            'Erysiphe necator (Powdery mildew)',
            'Botrytis cinerea (Botrytis)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '4th Flight · 4–25 June',
          elStage: 'EL 27–33',
          growthStage: 'Fruit Set to Bunch Closure',
          risks: [
            'Plasmopara viticola (Downy mildew)',
            'Erysiphe necator (Powdery mildew)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '5th Flight · 5–18 July',
          elStage: 'EL 34–35',
          growthStage: 'Veraison',
          risks: [
            'Plasmopara viticola (Downy mildew)',
            'Erysiphe necator (Powdery mildew)',
          ],
        ),
        FlightRiskWindow(
          flightLabel: '6th Flight · 6–17 August',
          elStage: 'EL 38',
          growthStage: 'Veraison to Harvest',
          risks: [
            'Botrytis cinerea (Botrytis)',
          ],
        ),
      ],
    ),
  ];
}
