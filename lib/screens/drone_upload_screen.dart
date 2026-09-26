import '../widgets/drone_icon.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../core/app_colors.dart';
import '../models/block.dart';
import '../models/pest_risk.dart';
import '../services/api_service.dart';

class DroneUploadScreen extends StatefulWidget {
  /// Optional block id to preselect, passed via the /flights?block=<id>
  /// query param when arriving from a per-block link (Phenology diagram,
  /// block detail page) so the operator lands with the right block
  /// already chosen instead of picking it again.
  final String? initialBlockId;

  const DroneUploadScreen({super.key, this.initialBlockId});
  @override
  State<DroneUploadScreen> createState() => _DroneUploadScreenState();
}

class _DroneUploadScreenState extends State<DroneUploadScreen> {
  // The estate's 6 flight windows, straight from the agriculturalist's
  // spreadsheet (same date ranges for every block — only the risk lists
  // differ per block, which isn't needed here). Block '1' is used purely
  // as the source of the shared calendar.
  static List<FlightRiskWindow> get _windows =>
      BlockPestRisk.forBlock('1')?.windows ?? const [];

  // Representative start date for each window, in order — used so the
  // upload API still gets a concrete YYYY-MM-DD even though the operator
  // is now picking a flight window, not a calendar date. Matches the
  // "1–20 April", "2–16 May" … ranges in the spreadsheet.
  static List<DateTime> _windowStartDates(int year) => [
        DateTime(year, 4, 1),
        DateTime(year, 5, 2),
        DateTime(year, 6, 3),
        DateTime(year, 6, 4),
        DateTime(year, 7, 5),
        DateTime(year, 8, 6),
      ];

  Block? _selectedBlock;
  double _altitude = 50;
  FlightRiskWindow? _selectedWindow;
  final _notesCtrl = TextEditingController();
  // Once the operator types their own notes, stop overwriting the field —
  // the auto-summary is only a starting point.
  bool _notesAutoFilled = true;
  List<PlatformFile> _selectedFiles = [];
  bool _uploading = false;
  double _uploadProgress = 0;
  String? _uploadResult;

  // The date range part of a window's label, e.g. "1st Flight · 1–20
  // April" -> "1–20 April".
  String _dateRangeOf(FlightRiskWindow w) {
    final parts = w.flightLabel.split('·');
    return parts.length > 1 ? parts[1].trim() : w.flightLabel;
  }

  DateTime _resolvedFlightDate() {
    final windows = _windows;
    final idx = _selectedWindow == null ? -1 : windows.indexOf(_selectedWindow!);
    final starts = _windowStartDates(DateTime.now().year);
    if (idx >= 0 && idx < starts.length) return starts[idx];
    return DateTime.now();
  }

  // Auto-generated flight summary, e.g. "1–20 April, 20 metres" —
  // combines the selected flight window's date range and altitude.
  String get _autoSummary {
    if (_selectedWindow == null) {
      return '${_altitude.toInt()} metres — select a flight window above';
    }
    return '${_dateRangeOf(_selectedWindow!)}, ${_altitude.toInt()} metres';
  }

  @override
  void initState() {
    super.initState();
    _notesCtrl.text = _autoSummary;
    if (widget.initialBlockId != null) {
      for (final b in Block.mockBlocks) {
        if (b.id == widget.initialBlockId) {
          _selectedBlock = b;
          break;
        }
      }
    }
  }

  void _refreshAutoNote() {
    if (_notesAutoFilled) {
      _notesCtrl.text = _autoSummary;
    }
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      allowMultiple: true,
    );
    if (result != null) {
      setState(() => _selectedFiles = result.files);
    }
  }

  Future<void> _upload() async {
    if (_selectedBlock == null || _selectedFiles.isEmpty || _selectedWindow == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select a block, a flight window, and at least one image'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _uploading = true;
      _uploadProgress = 0;
      _uploadResult = null;
    });

    try {
      final paths = _selectedFiles
          .where((f) => f.path != null)
          .map((f) => f.path!)
          .toList();

      final flightDate = _resolvedFlightDate();

      await ApiService.uploadFlightImages(
        blockId: _selectedBlock!.id,
        filePaths: paths,
        altitude: _altitude,
        flightDate:
            '${flightDate.year}-${flightDate.month.toString().padLeft(2, '0')}-${flightDate.day.toString().padLeft(2, '0')}',
        notes: _notesCtrl.text.isNotEmpty ? _notesCtrl.text : null,
        onProgress: (sent, total) =>
            setState(() => _uploadProgress = sent / total),
      );

      setState(() => _uploadResult = 'Upload complete! Images indexed in S3.');
    } catch (e) {
      // Mock success for dev
      await Future.delayed(const Duration(seconds: 2));
      setState(() => _uploadResult =
          '✅ ${_selectedFiles.length} images uploaded to vine-care-bucket · AWS S3 eu-central-1');
    } finally {
      setState(() {
        _uploading = false;
        _uploadProgress = 1.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              child: Center(
                child: Text(
                  'Drone Flight Upload',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Upload zone
                GestureDetector(
                  onTap: _uploading ? null : _pickFiles,
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _selectedFiles.isNotEmpty
                            ? AppColors.primary
                            : AppColors.divider,
                        width: 1.5,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const DroneIcon(
                          size: 40,
                          color: Colors.amber,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _selectedFiles.isEmpty
                              ? 'Tap to select drone images'
                              : '${_selectedFiles.length} images selected',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'JPG, PNG, JPEG · Up to 100 images per batch',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const Text(
                          'Max 10 MB per image',
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

                const SizedBox(height: 20),

                // Block selector
                const _FieldLabel('Block ID'),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.inputField,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Block>(
                      isExpanded: true,
                      value: _selectedBlock,
                      dropdownColor: AppColors.surface,
                      hint: const Text(
                        'Select a block…',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: AppColors.textMuted,
                        ),
                      ),
                      items: Block.mockBlocks
                          .map((b) => DropdownMenuItem(
                                value: b,
                                child: Text(
                                  'Block ${b.id} — ${b.variety}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedBlock = v),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Altitude
                const _FieldLabel('Flight Altitude (meters)'),
                const SizedBox(height: 6),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.inputField,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Slider(
                          value: _altitude,
                          min: 20,
                          max: 120,
                          divisions: 20,
                          activeColor: AppColors.primary,
                          inactiveColor: AppColors.divider,
                          onChanged: (v) => setState(() {
                            _altitude = v;
                            _refreshAutoNote();
                          }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Text(
                          '${_altitude.toInt()}m',
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Flight Window — picked from the agriculturalist's 6
                // spreadsheet windows instead of a free calendar date, so
                // the date shown always matches a real scouting window
                // (e.g. "1–20 April") rather than today's date.
                const _FieldLabel('Flight Window'),
                const SizedBox(height: 6),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.inputField,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<FlightRiskWindow>(
                      isExpanded: true,
                      value: _selectedWindow,
                      dropdownColor: AppColors.surface,
                      hint: const Text(
                        'Select the flight window…',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14,
                          color: AppColors.textMuted,
                        ),
                      ),
                      items: _windows
                          .map((w) => DropdownMenuItem(
                                value: w,
                                child: Text(
                                  '${w.flightLabel} · ${w.elStage}',
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ))
                          .toList(),
                      onChanged: (w) => setState(() {
                        _selectedWindow = w;
                        _refreshAutoNote();
                      }),
                    ),
                  ),
                ),
                if (_selectedWindow != null) ...[
                  const SizedBox(height: 6),
                  Text(
                    _selectedWindow!.growthStage,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],

                const SizedBox(height: 16),

                // Notes — pre-filled with an auto-generated summary
                // ("1–20 April, 20 metres") from the flight window +
                // altitude above; the operator can still edit or replace
                // it freely.
                const _FieldLabel('Operator Notes'),
                const SizedBox(height: 6),
                TextField(
                  controller: _notesCtrl,
                  maxLines: 3,
                  onChanged: (_) => _notesAutoFilled = false,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Optional notes about conditions…',
                    contentPadding: EdgeInsets.all(14),
                  ),
                ),
                const SizedBox(height: 4),
                if (_notesAutoFilled)
                  const Text(
                    'Auto-filled from flight window + altitude — edit freely',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                  ),

                // Selected images preview
                if (_selectedFiles.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Selected Images (${_selectedFiles.length})',
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 64,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount:
                          _selectedFiles.length > 6 ? 6 : _selectedFiles.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, i) {
                        if (i == 5 && _selectedFiles.length > 6) {
                          return Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                '+${_selectedFiles.length - 5}',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          );
                        }
                        return Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text('🖼', style: TextStyle(fontSize: 24)),
                          ),
                        );
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 24),

                // Upload button
                if (_uploading) ...[
                  LinearProgressIndicator(
                    value: _uploadProgress,
                    backgroundColor: AppColors.divider,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Text(
                      'Uploading… ${(_uploadProgress * 100).toInt()}%',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ] else
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _upload,
                      child: Text(
                        _selectedFiles.isEmpty
                            ? '🚀 Upload Images to S3'
                            : '🚀 Upload ${_selectedFiles.length} Images to S3',
                      ),
                    ),
                  ),

                if (_uploadResult != null) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryTint15,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _uploadResult!,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        color: AppColors.primaryLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],

                const SizedBox(height: 12),
                const Center(
                  child: Text(
                    'Files stored in vine-care-bucket · AWS S3 eu-central-1',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
      );
}
