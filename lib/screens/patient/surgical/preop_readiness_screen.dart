import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class PreOpReadinessScreen extends StatefulWidget {
  const PreOpReadinessScreen({super.key});

  @override
  State<PreOpReadinessScreen> createState() => _PreOpReadinessScreenState();
}

class _PreOpReadinessScreenState extends State<PreOpReadinessScreen> {
  late Timer _countdownTimer;
  int _remainingSeconds = 20538; // 5 hours 42 mins 18 secs
  bool _simulateViolation = false; // Interactive FYP AI Risk simulation toggle

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer.cancel();
    super.dispose();
  }

  void _showFastingFaqSheet() {
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
              'Fasting Rules',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildFaqItem('Water', 'Plain water only until 06:30 AM.'),
            _buildFaqItem('Milk & Tea', 'Counts as food. Stop by 12:00 AM.'),
            _buildFaqItem('Teeth Brushing', 'Allowed. Spit out water completely.'),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
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

  void _showAiAuditSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setSheetState) => Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.auto_awesome_rounded, size: 18, color: AppColors.primary),
                      SizedBox(width: 8),
                      Text(
                        'AI Surgical Risk Engine',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'NSQIP / ASA-PS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Vectors
              _buildAuditVector(
                title: 'Pulmonary Aspiration Risk',
                desc: _simulateViolation ? 'CRITICAL: Solid food intake within 6h' : 'Minimal (<0.1%): 8h solid food buffer maintained',
                isSafe: !_simulateViolation,
              ),
              _buildAuditVector(
                title: 'Hemostasis & Bleeding',
                desc: 'Safe: Disprin paused 5d (Platelets normal, PT/INR 1.05)',
                isSafe: true,
              ),
              _buildAuditVector(
                title: 'Cardiopulmonary Clearance',
                desc: 'Cleared: 12-lead ECG normal sinus rhythm',
                isSafe: true,
              ),

              const SizedBox(height: 14),
              const Divider(height: 1, color: AppColors.border),
              const SizedBox(height: 12),

              // Interactive Simulation Toggle
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _simulateViolation ? const Color(0xFFFCA5A5) : AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'FYP Defense Simulation',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _simulateViolation
                              ? 'Simulating: Patient ate food (Violation active)'
                              : 'Test AI reaction if patient breaks fasting',
                            style: TextStyle(
                              fontSize: 10.5,
                              color: _simulateViolation ? const Color(0xFFDC2626) : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: _simulateViolation,
                      activeTrackColor: const Color(0xFFEF4444),
                      onChanged: (val) {
                        setSheetState(() {
                          _simulateViolation = val;
                        });
                        setState(() {
                          _simulateViolation = val;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text('Close Audit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuditVector({
    required String title,
    required String desc,
    required bool isSafe,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isSafe ? Icons.check_circle_rounded : Icons.warning_rounded,
            size: 15,
            color: isSafe ? const Color(0xFF10B981) : const Color(0xFFEF4444),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 10.5,
                    color: isSafe ? AppColors.textSecondary : const Color(0xFFDC2626),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle_outline, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: '$title: ',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
                children: [
                  TextSpan(
                    text: subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _callAnesthesiaDesk() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Calling Anesthesia Nurse Desk (Ext. 2104)...'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hours = (_remainingSeconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((_remainingSeconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');

    final readinessScore = _simulateViolation ? 34 : 96;
    final isSafe = !_simulateViolation;

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
                        'Pre-Op Fasting Guard',
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
                    onPressed: _showFastingFaqSheet,
                    tooltip: 'Rules',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Sleek Procedure Capsule
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Row(
                children: [
                  Icon(Icons.medical_services_outlined, size: 15, color: AppColors.primary),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Laparoscopic Cholecystectomy • Tomorrow 08:30 AM',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 2. AI Pre-Op Readiness & Risk Predictor Module
            _buildAiReadinessCard(readinessScore, isSafe),

            const SizedBox(height: 10),

            // 3. Minimalist Fasting Hero Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSafe ? AppColors.border : const Color(0xFFFCA5A5),
                ),
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
                  // Status Badge & Doctor
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                        decoration: BoxDecoration(
                          color: isSafe ? const Color(0xFFFEF3C7) : const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 6,
                              color: isSafe ? const Color(0xFFD97706) : const Color(0xFFDC2626),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              isSafe ? 'FASTING ACTIVE' : 'FASTING VIOLATED',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: isSafe ? const Color(0xFFB45309) : const Color(0xFF991B1B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Flexible(
                        child: Text(
                          'Dr. Salman Haider',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Digital Clock Block
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDigitBlock(hours, 'HRS'),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                        child: Text(
                          ':',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                      _buildDigitBlock(minutes, 'MIN'),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                        child: Text(
                          ':',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                      _buildDigitBlock(seconds, 'SEC'),
                    ],
                  ),

                  const SizedBox(height: 6),
                  const Text(
                    'Solid Food Cutoff Window',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 10),

                  // 2 Minimal Rule Columns
                  Row(
                    children: [
                      Expanded(
                        child: _buildMinimalRule(
                          icon: Icons.no_meals_outlined,
                          title: 'Solid Food',
                          cutoff: 'Stop 12:00 AM',
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                      Container(width: 1, height: 30, color: AppColors.border),
                      Expanded(
                        child: _buildMinimalRule(
                          icon: Icons.water_drop_outlined,
                          title: 'Plain Water',
                          cutoff: 'Stop 06:30 AM',
                          color: const Color(0xFF0284C7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 4. Safety Clearance Row (Medication & Consent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildSafetyRow(
                    icon: Icons.medication_outlined,
                    title: 'Tab. Disprin (Aspirin)',
                    badge: 'Paused 5d ago',
                  ),
                  const Divider(height: 14, color: AppColors.border),
                  _buildSafetyRow(
                    icon: Icons.draw_outlined,
                    title: 'Surgical Consent',
                    badge: 'Signed & Clear',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 5. Clinical Fitness (4 Minimalist Pills)
            const Text(
              'CLINICAL CLEARANCES',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 6),

            _buildClearanceRow(),

            const SizedBox(height: 14),

            // 6. Action Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _callAnesthesiaDesk,
                icon: const Icon(Icons.phone_in_talk_rounded, size: 15),
                label: const Text('Call Anesthesia Desk'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isSafe ? AppColors.primary : const Color(0xFFDC2626),
                  side: BorderSide(
                    color: isSafe ? AppColors.primary : const Color(0xFFDC2626),
                  ),
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
      ),
    );
  }

  Widget _buildAiReadinessCard(int score, bool isSafe) {
    return InkWell(
      onTap: _showAiAuditSheet,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSafe ? const Color(0xFFF0FDF4) : const Color(0xFFFEF2F2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSafe ? const Color(0xFFBBF7D0) : const Color(0xFFFECACA),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 15,
                      color: isSafe ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      'AI SURGICAL READINESS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isSafe ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isSafe ? 'ASA-I • READY' : 'HIGH RISK • DELAY',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: isSafe ? const Color(0xFF15803D) : const Color(0xFFB91C1C),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  '$score%',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: isSafe ? const Color(0xFF15803D) : const Color(0xFFDC2626),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: score / 100,
                          minHeight: 6,
                          backgroundColor: Colors.black.withValues(alpha: 0.06),
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isSafe ? const Color(0xFF16A34A) : const Color(0xFFEF4444),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isSafe ? 'Optimal for General Anesthesia' : 'Aspiration Hazard Detected',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isSafe ? const Color(0xFF16A34A) : const Color(0xFFDC2626),
                            ),
                          ),
                          const Text(
                            'Audit Details ➔',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDigitBlock(String val, String unit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            val,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              fontFamily: 'monospace',
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimalRule({
    required IconData icon,
    required String title,
    required String cutoff,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
                Text(
                  cutoff,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyRow({
    required IconData icon,
    required String title,
    required String badge,
  }) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppColors.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check, size: 11, color: Color(0xFF10B981)),
              const SizedBox(width: 3),
              Text(
                badge,
                style: const TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF047857),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildClearanceRow() {
    final tests = [
      {'label': 'ECG', 'val': 'Normal'},
      {'label': 'PT/INR', 'val': '1.05 Safe'},
      {'label': 'Blood', 'val': 'B+ Ready'},
      {'label': 'X-Ray', 'val': 'Clear'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: tests.map((t) {
          return Expanded(
            child: Column(
              children: [
                const Icon(Icons.check_circle_rounded, size: 15, color: Color(0xFF10B981)),
                const SizedBox(height: 3),
                Text(
                  t['label']!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  t['val']!,
                  style: const TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF047857),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
