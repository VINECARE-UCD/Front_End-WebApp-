class Block {
  final String id;
  final String name;
  final String variety;
  final String farm;
  final double hectares;
  final double? latitude;
  final double? longitude;
  final String phenologyStage;
  final double? ndvi;
  final double? canopyCoverage;
  final int flightCount;
  final DateTime? lastFlight;
  final String? knownIssues;

  const Block({
    required this.id,
    required this.name,
    required this.variety,
    required this.farm,
    required this.hectares,
    this.latitude,
    this.longitude,
    required this.phenologyStage,
    this.ndvi,
    this.canopyCoverage,
    required this.flightCount,
    this.lastFlight,
    this.knownIssues,
  });

  factory Block.fromJson(Map<String, dynamic> json) => Block(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        variety: json['variety']?.toString() ?? '',
        farm: json['farm']?.toString() ?? '',
        hectares: (json['hectares'] as num?)?.toDouble() ?? 0,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        phenologyStage: json['phenology_stage']?.toString() ?? 'Unknown',
        ndvi: (json['ndvi'] as num?)?.toDouble(),
        canopyCoverage: (json['canopy_coverage'] as num?)?.toDouble(),
        flightCount: (json['flight_count'] as num?)?.toInt() ?? 0,
        lastFlight: json['last_flight'] != null
            ? DateTime.tryParse(json['last_flight'].toString())
            : null,
        knownIssues: json['known_issues']?.toString(),
      );

  String get lastFlightLabel {
    if (lastFlight == null) return 'No flights';

    final diff = DateTime.now().difference(lastFlight!);

    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';

    return '${diff.inDays}d ago';
  }

  // Mock data for UI development while API is being connected.
  // Reflects the 5 real KOKOTOS ESTATE blocks identified in D1.1.
  static List<Block> mockBlocks = [
    Block(
      id: '1',
      name: 'Block 1',
      variety: 'Cabernet Sauvignon',
      farm: 'Kokotos Estate – Upper Section',
      hectares: 2.3,

      // Corrected real block coordinates
      latitude: 38.1249632,
      longitude: 23.8912986,

      phenologyStage: 'Veraison',
      ndvi: 0.58,
      canopyCoverage: 66,
      flightCount: 9,
      lastFlight: DateTime(2026, 8, 6),
      knownIssues: 'Nutrient & water stress, insect pressure',
    ),
    Block(
      id: '2',
      name: 'Block 2',
      variety: 'Chardonnay',
      farm: 'Kokotos Estate – Lower Section',
      hectares: 1.9,

      // Corrected real block coordinates
      latitude: 38.1245507,
      longitude: 23.8915312,

      phenologyStage: 'Vine Dev.',
      ndvi: 0.59,
      canopyCoverage: 68,
      flightCount: 8,
      lastFlight: DateTime(2026, 8, 5),
      knownIssues: 'Fungus pressure, nutrient deficiency',
    ),
    Block(
      id: '3',
      name: 'Block 3',
      variety: 'Merlot',
      farm: 'Kokotos Estate – Mid Section',
      hectares: 2.6,

      // Corrected real block coordinates
      latitude: 38.1230667,
      longitude: 23.8923479,

      phenologyStage: 'Vine Dev.',
      ndvi: 0.63,
      canopyCoverage: 72,
      flightCount: 10,
      lastFlight: DateTime(2026, 8, 7),
      knownIssues: 'Water & nutrient deficiency',
    ),
    Block(
      id: '4',
      name: 'Block 4',
      variety: 'Assyrtiko',
      farm: 'Kokotos Estate – Lower Section',
      hectares: 3.1,

      // Corrected real block coordinates
      latitude: 38.1287965,
      longitude: 23.9057000,

      phenologyStage: 'Flowering',
      ndvi: 0.55,
      canopyCoverage: 60,
      flightCount: 7,
      lastFlight: DateTime(2026, 8, 8),
      knownIssues: 'Frost damage, fungus infestation',
    ),
    Block(
      id: '5',
      name: 'Block 5',
      variety: 'Gewurztraminer',
      farm: 'Kokotos Estate – Lower Section',
      hectares: 2.8,

      // Corrected real block coordinates
      latitude: 38.1298833,
      longitude: 23.9054924,

      phenologyStage: 'Vine Dev.',
      ndvi: 0.57,
      canopyCoverage: 63,
      flightCount: 8,
      lastFlight: DateTime(2026, 8, 4),
      knownIssues: 'Frost damage, fungus infestation',
    ),
  ];
}
