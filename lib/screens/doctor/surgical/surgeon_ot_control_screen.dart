import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class SurgeonOtControlScreen extends StatefulWidget {
  const SurgeonOtControlScreen({super.key});

  @override
  State<SurgeonOtControlScreen> createState() => _SurgeonOtControlScreenState();
}

class _SurgeonOtControlScreenState extends State<SurgeonOtControlScreen> {
  // Surgery Stopwatch Timer
  int _elapsedSeconds = 5120; // 01:25:20
  Timer? _timer;

  // Active Milestone Index (starts at Stage 3: Active Procedure)
  int _currentMilestoneIndex = 3;

  // Live OT Vitals (Mutable & Editable)
  String _hr = '74 bpm';
  String _bp = '118/76';
  String _spo2 = '99%';
  String _ebl = '< 30 ml';

  // Surgery Milestones List
  final List<Map<String, dynamic>> _milestones = [
    {
      'title': 'Pre-Op Preparation',
      'subtitle': 'Patient prepped & IV access secured',
      'time': '08:30 AM',
      'icon': Icons.checklist_rounded,
    },
    {
      'title': 'Shifted to OT Suite #03',
      'subtitle': 'Sterile surgical field prepared',
      'time': '09:05 AM',
      'icon': Icons.meeting_room_outlined,
    },
    {
      'title': 'Anesthesia Induced',
      'subtitle': 'General anesthesia • Airway secured',
      'time': '09:30 AM',
      'icon': Icons.vaccines_outlined,
    },
    {
      'title': 'Active Procedure',
      'subtitle': 'Laparoscopic gallbladder dissection in progress',
      'time': '09:50 AM',
      'icon': Icons.medical_services_outlined,
    },
    {
      'title': 'Surgical Closure',
      'subtitle': 'Port closure & hemostasis verified',
      'time': '11:15 AM (Est.)',
      'icon': Icons.health_and_safety_outlined,
    },
    {
      'title': 'PACU Recovery Room',
      'subtitle': 'Post-anesthesia monitoring & vitals check',
      'time': '11:45 AM (Est.)',
      'icon': Icons.bed_outlined,
    },
    {
      'title': 'Shifted to Ward #402',
      'subtitle': 'Discharged to room • Family visit permitted',
      'time': '01:00 PM (Est.)',
      'icon': Icons.check_circle_outline_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _elapsedSeconds++;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(int sec) {
    final h = (sec ~/ 3600).toString().padLeft(2, '0');
    final m = ((sec % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (sec % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  void _advanceToNextStage() {
    if (_currentMilestoneIndex < _milestones.length - 1) {
      setState(() {
        _currentMilestoneIndex++;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Stage advanced to: ${_milestones[_currentMilestoneIndex]['title']} ✓',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // 1. BRAND HEADER (CareSpectrum 48px Standard)
            // ==========================================
            _buildHeader(),

            // ==========================================
            // 2. SCROLLABLE OT CONTROL CONSOLE
            // ==========================================
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                children: [
                  // Active Surgery Live Card (Bigger typography & action)
                  _buildLiveSurgeryCard(),

                  const SizedBox(height: 14),
                  _buildDottedLine(color: const Color(0xFFCBD5E1), dotWidth: 5, spacing: 3.5),
                  const SizedBox(height: 14),

                  // Intra-Op Vitals (2x2 Big Touch Targets • Tap to Edit)
                  _buildVitalsSection(),

                  const SizedBox(height: 14),
                  _buildDottedLine(color: const Color(0xFFCBD5E1), dotWidth: 5, spacing: 3.5),
                  const SizedBox(height: 14),

                  // Quick Broadcast Chips (Large, easy touch)
                  _buildQuickBroadcastSection(),

                  const SizedBox(height: 14),
                  _buildDottedLine(color: const Color(0xFFCBD5E1), dotWidth: 5, spacing: 3.5),
                  const SizedBox(height: 14),

                  // Surgery Milestones Timeline (Bigger indicators)
                  _buildMilestonesHeader(),
                  const SizedBox(height: 10),
                  _buildMilestonesList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // 1. HEADER (48px)
  // =========================================================================
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(22),
          bottomRight: Radius.circular(22),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'Live OT Console',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: -0.2,
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // 2. LIVE SURGERY HERO CARD (Larger, High-Visibility for Busy OT)
  // =========================================================================
  Widget _buildLiveSurgeryCard() {
    final nextMilestone = _currentMilestoneIndex < _milestones.length - 1
        ? _milestones[_currentMilestoneIndex + 1]['title']
        : 'Completed';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBFDBFE), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Case ID & Stopwatch Timer Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Case #OT-9842',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.timer_outlined, size: 14, color: Color(0xFF10B981)),
                    const SizedBox(width: 5),
                    Text(
                      _formatDuration(_elapsedSeconds),
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Patient Name & Procedure (Large & Bold)
          const Text(
            'Junaid Tariq',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Laparoscopic Cholecystectomy • Dr. Salman Haider (Lead)',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 12),

          // Active Phase Pill
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFDBEAFE)),
            ),
            child: Row(
              children: [
                const Icon(Icons.flash_on_rounded, size: 16, color: AppColors.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CURRENT SURGICAL STAGE',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        _milestones[_currentMilestoneIndex]['title'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF0369A1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Big 44px Primary "Advance Stage" Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: ElevatedButton.icon(
              onPressed: _advanceToNextStage,
              icon: const Icon(Icons.skip_next_rounded, size: 18),
              label: Text(
                _currentMilestoneIndex < _milestones.length - 1
                    ? 'Advance Stage ➔ $nextMilestone'
                    : 'Procedure Concluded ✓',
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 3. INTRA-OP VITALS (2x2 Large Touch Targets • Tap to Edit)
  // =========================================================================
  Widget _buildVitalsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Intra-Op Vitals Telemetry',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Row(
                children: [
                  Icon(Icons.touch_app_rounded, size: 11, color: AppColors.textSecondary),
                  SizedBox(width: 3),
                  Text(
                    'Tap to Update',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // 2x2 Grid of Large Vital Cards
        Row(
          children: [
            _buildLargeVitalCard(
              vitalKey: 'HR',
              label: 'Heart Rate',
              value: _hr,
              icon: Icons.favorite_rounded,
              color: const Color(0xFFEF4444),
            ),
            const SizedBox(width: 10),
            _buildLargeVitalCard(
              vitalKey: 'BP',
              label: 'Blood Pressure',
              value: _bp,
              icon: Icons.speed_rounded,
              color: const Color(0xFF0284C7),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildLargeVitalCard(
              vitalKey: 'SpO2',
              label: 'Oxygen Saturation',
              value: _spo2,
              icon: Icons.air_rounded,
              color: const Color(0xFF10B981),
            ),
            const SizedBox(width: 10),
            _buildLargeVitalCard(
              vitalKey: 'EBL',
              label: 'Blood Loss (EBL)',
              value: _ebl,
              icon: Icons.water_drop_rounded,
              color: const Color(0xFFF59E0B),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLargeVitalCard({
    required String vitalKey,
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: InkWell(
        onTap: () => _openEditVitalSheet(vitalKey, label, value),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: color,
                        letterSpacing: -0.2,
                      ),
                    ),
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.edit_rounded, size: 14, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // MODAL TO EDIT VITAL (Instant Presets for Busy OT)
  // =========================================================================
  void _openEditVitalSheet(String key, String label, String currentVal) {
    final textController = TextEditingController(text: currentVal);

    // Fast 1-tap presets according to the vital type
    List<String> presets = [];
    if (key == 'BP') {
      presets = ['110/70', '118/76', '120/80', '130/85', '140/90'];
    } else if (key == 'HR') {
      presets = ['65 bpm', '74 bpm', '80 bpm', '88 bpm', '100 bpm'];
    } else if (key == 'SpO2') {
      presets = ['96%', '98%', '99%', '100%'];
    } else if (key == 'EBL') {
      presets = ['< 20 ml', '< 30 ml', '50 ml', '100 ml', '200 ml'];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.fromLTRB(18, 14, 18, MediaQuery.of(ctx).viewInsets.bottom + 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
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

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Update $label',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Current: $currentVal',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // 1-Tap Presets Row (Surgeon doesn't need to type!)
              const Text(
                '1-TAP QUICK PRESETS',
                style: TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textMuted,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: presets.map((p) {
                  return InkWell(
                    onTap: () {
                      _saveVital(key, p);
                      Navigator.pop(ctx);
                    },
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFBFDBFE)),
                      ),
                      child: Text(
                        p,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 14),

              // Custom Input Field
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: textController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Or enter custom $label',
                        isDense: true,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (textController.text.trim().isNotEmpty) {
                        _saveVital(key, textController.text.trim());
                      }
                      Navigator.pop(ctx);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(0, 44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _saveVital(String key, String newVal) {
    setState(() {
      if (key == 'HR') _hr = newVal;
      if (key == 'BP') _bp = newVal;
      if (key == 'SpO2') _spo2 = newVal;
      if (key == 'EBL') _ebl = newVal;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$key updated to $newVal & broadcasted to patient app ✓'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // =========================================================================
  // 4. QUICK FAMILY BROADCAST CHIPS (Large Touch Targets)
  // =========================================================================
  Widget _buildQuickBroadcastSection() {
    final chips = [
      'Procedure in Progress • Stable',
      'Gallbladder safely removed ✓',
      'Closure in progress',
      'Surgery successfully completed 🎉',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '1-Tap Family Broadcast',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Syncs to Patient Live OT',
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: chips.map((c) {
            return InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Broadcast sent to family: "$c" 📡'),
                    backgroundColor: const Color(0xFF0284C7),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.cell_tower_rounded, size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      c,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // =========================================================================
  // 5. MILESTONES STEPPER LIST (Large & Easy to Tap)
  // =========================================================================
  Widget _buildMilestonesHeader() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Surgical Milestone Progress',
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        Text(
          'Tap any milestone to set',
          style: TextStyle(
            fontSize: 10.5,
            color: AppColors.textMuted,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildMilestonesList() {
    return Column(
      children: List.generate(_milestones.length, (index) {
        final m = _milestones[index];
        final bool isDone = index < _currentMilestoneIndex;
        final bool isCurrent = index == _currentMilestoneIndex;

        return InkWell(
          onTap: () {
            setState(() {
              _currentMilestoneIndex = index;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Milestone set to: ${m['title']}'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Step Indicator Icon (Large 34px circle)
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: isDone
                        ? const Color(0xFF10B981)
                        : (isCurrent ? AppColors.primary : AppColors.background),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDone
                          ? const Color(0xFF10B981)
                          : (isCurrent ? AppColors.primary : AppColors.border),
                      width: 1.8,
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      isDone
                          ? Icons.check_rounded
                          : (isCurrent ? Icons.circle : m['icon'] as IconData),
                      size: isDone ? 18 : (isCurrent ? 10 : 15),
                      color: isDone || isCurrent ? Colors.white : AppColors.textMuted,
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Title & Subtitle (Larger & clearer)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            m['title'],
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w700,
                              color: isCurrent ? AppColors.primary : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            m['time'],
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              color: isCurrent ? AppColors.primary : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        m['subtitle'],
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  // =========================================================================
  // DOTTED LINE WIDGET
  // =========================================================================
  Widget _buildDottedLine({
    Color color = const Color(0xFFCBD5E1),
    double height = 1.0,
    double dotWidth = 5.0,
    double spacing = 3.5,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        if (boxWidth <= 0) return const SizedBox.shrink();
        final count = (boxWidth / (dotWidth + spacing)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(count, (_) {
            return SizedBox(
              width: dotWidth,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
