import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../models/wound_scan_result.dart';
import '../records/medical_records_hub_screen.dart';

class WoundScannerScreen extends StatefulWidget {
  const WoundScannerScreen({super.key});

  @override
  State<WoundScannerScreen> createState() => _WoundScannerScreenState();
}

class _WoundScannerScreenState extends State<WoundScannerScreen> {
  String _selectedProcedure = 'Laparoscopic Cholecystectomy';
  final int _postOpDay = 5;
  final String _surgeonName = 'Dr. Salman Haider';

  final List<String> _procedures = [
    'Laparoscopic Cholecystectomy',
    'Appendectomy Incision',
    'Cesarean Section (C-Section)',
    'Inguinal Hernia Repair',
    'Orthopedic Knee Arthroscopy',
  ];

  // Scanner state
  bool _isAnalyzing = false;
  String _currentAnalysisStep = '';
  double _analysisProgress = 0.0;
  Timer? _analysisTimer;

  // Selected sample / image
  String _selectedPresetType = 'normal';
  WoundScanResult? _currentResult;

  @override
  void initState() {
    super.initState();
    // Load initial normal demo preset
    _loadPreset('normal');
  }

  @override
  void dispose() {
    _analysisTimer?.cancel();
    super.dispose();
  }

  void _loadPreset(String type) {
    setState(() {
      _selectedPresetType = type;
      _currentResult = null;
    });

    _startAiAnalysis(type);
  }

  void _startAiAnalysis(String type) {
    _analysisTimer?.cancel();
    setState(() {
      _isAnalyzing = true;
      _analysisProgress = 0.15;
      _currentAnalysisStep = 'Calibrating image illumination...';
      _currentResult = null;
    });

    int step = 0;
    _analysisTimer = Timer.periodic(const Duration(milliseconds: 450), (timer) {
      step++;
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        if (step == 1) {
          _analysisProgress = 0.45;
          _currentAnalysisStep = 'Segmenting incision & suture edges...';
        } else if (step == 2) {
          _analysisProgress = 0.75;
          _currentAnalysisStep = 'Analyzing erythema & tissue color index...';
        } else if (step == 3) {
          _analysisProgress = 0.92;
          _currentAnalysisStep = 'Checking exudate & CDC SSI criteria...';
        } else if (step >= 4) {
          timer.cancel();
          _isAnalyzing = false;
          _analysisProgress = 1.0;
          _currentResult = _generateMockResult(type);
        }
      });
    });
  }

  WoundScanResult _generateMockResult(String type) {
    if (type == 'normal') {
      return WoundScanResult(
        id: 'scan_001',
        procedureName: _selectedProcedure,
        postOpDay: _postOpDay,
        scanDate: 'Today, 16 Nov 2026 • 11:30 AM',
        status: WoundHealingStatus.normalHealing,
        healingScore: 94,
        confidencePercentage: 98.2,
        erythemaIndex: 'Minimal (< 2mm)',
        exudateType: 'None (Clean & dry)',
        edgeApproximation: 'Closed & approximated',
        edemaLevel: 'Mild expected swelling',
        localThermalEstimate: 'Normothermic (36.8°C)',
        aiSummary:
            'Surgical incision exhibits clean wound healing trajectory with intact sutures and zero infection markers.',
        clinicalObservations: [
          'Incision edges are fully closed with healthy collagen bridging.',
          'Skin perimeter is supple with no expanding redness.',
        ],
        surgeonRecommendations: [
          'Keep dry and clean as directed by Dr. Salman Haider.',
          'Suture inspection scheduled at Day 10 in clinic.',
        ],
        warningFlags: [],
        statusColor: const Color(0xFF10B981),
        statusBgColor: const Color(0xFFECFDF5),
      );
    } else if (type == 'warning') {
      return WoundScanResult(
        id: 'scan_002',
        procedureName: _selectedProcedure,
        postOpDay: _postOpDay,
        scanDate: 'Today, 16 Nov 2026 • 11:30 AM',
        status: WoundHealingStatus.mildErythema,
        healingScore: 68,
        confidencePercentage: 94.6,
        erythemaIndex: 'Moderate (5mm halo)',
        exudateType: 'Trace serous fluid',
        edgeApproximation: 'Intact with slight tension',
        edemaLevel: 'Moderate localized swelling',
        localThermalEstimate: 'Sub-febrile (+1.2°C)',
        aiSummary:
            'Early localized erythema and mild tissue warmth detected around lower suture. Monitor closely for early infection.',
        clinicalObservations: [
          'Redness margin measures ~5mm from the incision border.',
          'Trace serous weeping noted; no thick pus at this stage.',
        ],
        surgeonRecommendations: [
          'Re-photograph in 12 hours to verify redness margin.',
          'Complete prescribed oral prophylactic antibiotics course.',
        ],
        warningFlags: [
          'Contact surgeon if redness expands past 1 cm from stitches.',
        ],
        statusColor: const Color(0xFFF59E0B),
        statusBgColor: const Color(0xFFFFFBEB),
      );
    } else {
      return WoundScanResult(
        id: 'scan_003',
        procedureName: _selectedProcedure,
        postOpDay: _postOpDay,
        scanDate: 'Today, 16 Nov 2026 • 11:30 AM',
        status: WoundHealingStatus.infectionAlert,
        healingScore: 42,
        confidencePercentage: 97.1,
        erythemaIndex: 'Severe (> 15mm spreading)',
        exudateType: 'Purulent exudate present',
        edgeApproximation: 'Partial edge separation',
        edemaLevel: 'Marked periwound swelling',
        localThermalEstimate: 'Elevated warmth (+2.8°C)',
        aiSummary:
            'CRITICAL: Clinical signs of acute Superficial Surgical Site Infection (SSI) with purulent drainage detected.',
        clinicalObservations: [
          'Active purulent drainage visible along middle incision axis.',
          'Spreading redness exceeds 1.5 cm beyond wound boundaries.',
        ],
        surgeonRecommendations: [
          'Urgent in-person clinical review required with surgical team.',
          'Do not squeeze or press the surgical wound area.',
        ],
        warningFlags: [
          'High risk of deeper wound complications without prompt care.',
        ],
        statusColor: const Color(0xFFEF4444),
        statusBgColor: const Color(0xFFFEF2F2),
      );
    }
  }

  void _showGuidelineSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),
            const Text(
              'How to Take a Clean Photo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildGuidelineRow(Icons.light_mode_outlined, 'Good Natural Lighting',
                'Ensure clear lighting without shadows covering the stitches.'),
            _buildGuidelineRow(Icons.straighten_rounded, '10–15 cm Distance',
                'Keep phone parallel and centered directly above the wound.'),
            _buildGuidelineRow(Icons.visibility_outlined, 'Exposed Incision',
                'Remove any covering gauze before taking the picture.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 42),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text('Got it'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuidelineRow(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showProcedurePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Surgical Procedure',
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            ..._procedures.map((proc) {
              final isSelected = proc == _selectedProcedure;
              return ListTile(
                dense: true,
                onTap: () {
                  setState(() => _selectedProcedure = proc);
                  Navigator.pop(ctx);
                },
                title: Text(
                  proc,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textPrimary,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(Icons.check_circle_rounded,
                        color: AppColors.primary, size: 18)
                    : null,
              );
            }),
          ],
        ),
      ),
    );
  }

  void _saveToVault() {
    if (_currentResult == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('Wound scan saved to Medical Records Vault!'),
          ],
        ),
        backgroundColor: const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'View Vault',
          textColor: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MedicalRecordsHubScreen(),
              ),
            );
          },
        ),
      ),
    );
  }

  void _callSurgeon() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connecting with $_surgeonName surgical care line...'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 18,
                      color: AppColors.textPrimary,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Wound monitoring',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.info_outline_rounded,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: _showGuidelineSheet,
                    tooltip: 'Instructions',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Sleek Procedure Header Capsule
            _buildCleanProcedureStrip(),

            const SizedBox(height: 14),

            // 2. Clean Clinical Capture Box
            _buildCleanCaptureArea(),

            const SizedBox(height: 14),

            // 3. Clean Case Selector Pills (Normal / Mild Redness / Infection)
            _buildCleanCaseSelector(),

            const SizedBox(height: 16),

            // 4. Analysis Progress OR Unified Clean Diagnostic Card
            if (_isAnalyzing)
              _buildCleanAnalyzingBox()
            else if (_currentResult != null)
              _buildUnifiedDiagnosticCard(_currentResult!),
          ],
        ),
      ),
    );
  }

  Widget _buildCleanProcedureStrip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.healing_rounded,
              color: AppColors.primary,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedProcedure,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Post-Op Day $_postOpDay • $_surgeonName',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          InkWell(
            onTap: _showProcedurePicker,
            borderRadius: BorderRadius.circular(6),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              child: Text(
                'Change',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCleanCaptureArea() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Centered Camera Frame Target
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE2E8F0), width: 2),
            ),
            child: const Center(
              child: Icon(
                Icons.camera_alt_outlined,
                size: 34,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Scan Surgical Incision',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Take a well-lit photo of your stitches to analyze healing',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          // Two Clean Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _loadPreset('normal'),
                  icon: const Icon(Icons.camera_alt_rounded, size: 16),
                  label: const Text('Take Photo'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    textStyle: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _loadPreset('warning'),
                  icon: const Icon(Icons.photo_library_outlined, size: 16),
                  label: const Text('Choose Gallery'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textPrimary,
                    side: const BorderSide(color: AppColors.border),
                    minimumSize: const Size(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCleanCaseSelector() {
    final cases = [
      {'key': 'normal', 'label': 'Healthy Healing', 'color': const Color(0xFF10B981)},
      {'key': 'warning', 'label': 'Mild Redness', 'color': const Color(0xFFF59E0B)},
      {'key': 'infection', 'label': 'Infection Alert', 'color': const Color(0xFFEF4444)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TEST CLINICAL CASES',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: cases.map((c) {
            final key = c['key'] as String;
            final label = c['label'] as String;
            final color = c['color'] as Color;
            final isSelected = _selectedPresetType == key;

            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: InkWell(
                  onTap: () => _loadPreset(key),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? color.withValues(alpha: 0.12) : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? color : AppColors.border,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? color : AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildCleanAnalyzingBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 2.8,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _currentAnalysisStep,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _analysisProgress,
              minHeight: 4,
              backgroundColor: AppColors.background,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnifiedDiagnosticCard(WoundScanResult result) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Status Header & Score
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: result.statusBgColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: result.statusColor.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: result.statusColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          result.riskBadgeLabel,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: result.statusColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Score: ${result.healingScore}%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: result.statusColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Title & Summary
          Text(
            result.statusTitle,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            result.aiSummary,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 12),

          // 2. 4 Clean Metric Pills (2x2 Grid)
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                    'Closure', result.edgeApproximation.contains('Closed') ? 'Closed' : 'Partial Gap'),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile('Redness', result.erythemaIndex),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile('Discharge', result.exudateType),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile('Swelling', result.edemaLevel),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 3. Clinical Recommendation
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.verified_outlined, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    result.surgeonRecommendations.first,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textPrimary,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 4. Action Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _callSurgeon,
                  icon: const Icon(Icons.phone_in_talk_rounded, size: 15),
                  label: const Text('Contact Surgeon'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: result.status == WoundHealingStatus.infectionAlert
                        ? const Color(0xFFEF4444)
                        : AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 42),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    textStyle: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _saveToVault,
                  icon: const Icon(Icons.lock_outline_rounded, size: 15),
                  label: const Text('Save to Vault'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    minimumSize: const Size(0, 42),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
