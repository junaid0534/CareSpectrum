import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';

class DoctorVideoConsultationScreen extends StatefulWidget {
  final String patientName;
  final String patientAgeGender;
  final String clinicalNote;
  final String tokenNumber;
  final String initials;

  const DoctorVideoConsultationScreen({
    super.key,
    this.patientName = 'Junaid Tariq',
    this.patientAgeGender = '24 Y • Male',
    this.clinicalNote = 'Post-Op Review',
    this.tokenNumber = 'Token #03',
    this.initials = 'JT',
  });

  @override
  State<DoctorVideoConsultationScreen> createState() =>
      _DoctorVideoConsultationScreenState();
}

class _DoctorVideoConsultationScreenState
    extends State<DoctorVideoConsultationScreen> {
  // Call Controls State
  bool _isMuted = false;
  bool _isVideoOff = false;
  bool _isFrontCamera = true;
  bool _isSpeakerOn = true;
  bool _prescriptionSent = false;

  // Draggable PiP (Self-preview) Offset
  Offset? _pipPosition;

  // Real-time call timer
  int _callSeconds = 184; // 03:04
  Timer? _timer;

  // Active prescriptions for this consultation
  final List<Map<String, String>> _prescriptions = [
    {
      'name': 'Augmentin 625mg',
      'dosage': '1 Tab • Twice Daily',
      'duration': '5 Days',
    },
    {
      'name': 'Panadol 500mg',
      'dosage': '1 Tab • SOS (Pain)',
      'duration': '3 Days',
    },
    {
      'name': 'Risek 20mg',
      'dosage': '1 Cap • Before Breakfast',
      'duration': '7 Days',
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
          _callSeconds++;
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
    final m = (sec ~/ 60).toString().padLeft(2, '0');
    final s = (sec % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const double pipWidth = 84.0;
    const double pipHeight = 114.0;

    _pipPosition ??= Offset(screenSize.width - pipWidth - 16.0, 68.0);

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Stack(
          children: [
            // ==========================================
            // 1. MAIN PATIENT VIDEO CANVAS
            // ==========================================
            _buildVideoCanvas(),

            // ==========================================
            // 2. TOP MINIMAL BAR
            // ==========================================
            Positioned(
              top: 12,
              left: 16,
              right: 16,
              child: _buildTopBar(),
            ),

            // ==========================================
            // 3. DOCTOR SELF PiP (Draggable anywhere on screen)
            // ==========================================
            Positioned(
              left: _pipPosition!.dx,
              top: _pipPosition!.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    final newX = (_pipPosition!.dx + details.delta.dx)
                        .clamp(12.0, screenSize.width - pipWidth - 12.0);
                    final newY = (_pipPosition!.dy + details.delta.dy)
                        .clamp(56.0, screenSize.height - pipHeight - 90.0);
                    _pipPosition = Offset(newX, newY);
                  });
                },
                child: _buildDoctorPip(width: pipWidth, height: pipHeight),
              ),
            ),

            // ==========================================
            // 4. RX SENT NOTIFICATION PILL
            // ==========================================
            if (_prescriptionSent)
              Positioned(
                bottom: 96,
                left: 24,
                right: 24,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_rounded, size: 15, color: Colors.white),
                        SizedBox(width: 6),
                        Text(
                          'Prescription Sent ✓',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // ==========================================
            // 6. BOTTOM ACTION CONTROLS DOCK
            // ==========================================
            Positioned(
              bottom: 18,
              left: 20,
              right: 20,
              child: _buildActionDock(),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // MAIN PATIENT VIDEO CANVAS (Minimal, Clean)
  // =========================================================================
  Widget _buildVideoCanvas() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.center,
          radius: 1.1,
          colors: [
            Color(0xFF1E293B),
            Color(0xFF0F172A),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Patient Avatar Visual
            Container(
              width: 104,
              height: 104,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF0284C7).withValues(alpha: 0.15),
                border: Border.all(
                  color: const Color(0xFF0284C7).withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  widget.initials,
                  style: const TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Patient Name
            Text(
              widget.patientName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 3),

            // Subtitle
            Text(
              '${widget.tokenNumber} • ${widget.clinicalNote}',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // TOP MINIMAL STATUS BAR
  // =========================================================================
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back Button
        InkWell(
          onTap: _handleEndCall,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_rounded, size: 18, color: Colors.white),
          ),
        ),

        // Center Live Time Capsule
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B).withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                _formatDuration(_callSeconds),
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                '• HD',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ),

        // Speaker Toggle Button
        InkWell(
          onTap: () {
            setState(() {
              _isSpeakerOn = !_isSpeakerOn;
            });
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _isSpeakerOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================================
  // DOCTOR SELF PiP (Draggable Card)
  // =========================================================================
  Widget _buildDoctorPip({double width = 84.0, double height = 114.0}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary, width: 1.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Video / Off State
            _isVideoOff
                ? Container(
                    color: const Color(0xFF0F172A),
                    child: const Center(
                      child: Icon(Icons.videocam_off_rounded, size: 20, color: Colors.white54),
                    ),
                  )
                : Container(
                    color: const Color(0xFF0369A1),
                    child: const Center(
                      child: Icon(Icons.person_rounded, size: 32, color: Colors.white),
                    ),
                  ),

            // Mini Camera Switcher
            Positioned(
              top: 3,
              right: 3,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isFrontCamera = !_isFrontCamera;
                  });
                },
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.flip_camera_ios_rounded, size: 11, color: Colors.white),
                ),
              ),
            ),

            // "You"
            Positioned(
              bottom: 3,
              left: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const Text(
                  'You',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  // =========================================================================
  // BOTTOM ACTION DOCK (Clean circular icons, no text labels)
  // =========================================================================
  Widget _buildActionDock() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // 1. Mic
          _buildCircleBtn(
            icon: _isMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
            isActive: !_isMuted,
            onTap: () {
              setState(() {
                _isMuted = !_isMuted;
              });
            },
          ),

          // 2. Video
          _buildCircleBtn(
            icon: _isVideoOff ? Icons.videocam_off_rounded : Icons.videocam_rounded,
            isActive: !_isVideoOff,
            onTap: () {
              setState(() {
                _isVideoOff = !_isVideoOff;
              });
            },
          ),

          // 3. E-Prescribe (Primary Rx button)
          InkWell(
            onTap: _showPrescriptionSheet,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.edit_note_rounded, size: 22, color: Colors.white),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Vitals
          _buildCircleBtn(
            icon: Icons.monitor_heart_outlined,
            isActive: true,
            onTap: _showVitalsModal,
          ),

          // 5. End Call (Crimson red)
          InkWell(
            onTap: _handleEndCall,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.call_end_rounded, size: 20, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircleBtn({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withValues(alpha: 0.12) : const Color(0xFFEF4444).withValues(alpha: 0.25),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isActive ? Colors.white : const Color(0xFFEF4444),
        ),
      ),
    );
  }

  // =========================================================================
  // IN-CALL E-PRESCRIPTION SHEET (Clean & Direct)
  // =========================================================================
  void _showPrescriptionSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (modalContext, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.72,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'E-Prescription',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '${widget.patientName} (${widget.tokenNumber})',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(ctx),
                          icon: const Icon(Icons.close_rounded, size: 20),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, color: AppColors.border),

                  // Allergy Alert (Compact 1 line)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, size: 14, color: Color(0xFFDC2626)),
                        SizedBox(width: 6),
                        Text(
                          'Allergy: Penicillin',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF991B1B),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Medicine List
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Prescribed Medicines',
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => _showAddMedicineDialog(setModalState),
                              icon: const Icon(Icons.add, size: 14),
                              label: const Text('Add Drug', style: TextStyle(fontSize: 11)),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                padding: EdgeInsets.zero,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),

                        ..._prescriptions.asMap().entries.map((entry) {
                          final idx = entry.key;
                          final med = entry.value;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.medication_rounded, size: 16, color: AppColors.primary),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        med['name']!,
                                        style: const TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        '${med['dosage']} • ${med['duration']}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setModalState(() {
                                      _prescriptions.removeAt(idx);
                                    });
                                    setState(() {});
                                  },
                                  child: const Icon(Icons.close_rounded, size: 16, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  // Send Action Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          setState(() {
                            _prescriptionSent = true;
                          });
                        },
                        icon: const Icon(Icons.send_rounded, size: 14),
                        label: const Text(
                          'Send to Patient',
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
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
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddMedicineDialog(StateSetter setModalState) {
    final nameCtrl = TextEditingController();
    final dosageCtrl = TextEditingController(text: '1 Tab • Twice Daily');
    final durationCtrl = TextEditingController(text: '5 Days');

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text('Add Drug', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Drug Name',
                  isDense: true,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: dosageCtrl,
                decoration: const InputDecoration(
                  labelText: 'Dosage',
                  isDense: true,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: durationCtrl,
                decoration: const InputDecoration(
                  labelText: 'Duration',
                  isDense: true,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.trim().isNotEmpty) {
                  setModalState(() {
                    _prescriptions.add({
                      'name': nameCtrl.text.trim(),
                      'dosage': dosageCtrl.text.trim(),
                      'duration': durationCtrl.text.trim(),
                    });
                  });
                  setState(() {});
                }
                Navigator.pop(dialogCtx);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // =========================================================================
  // QUICK VITALS MODAL (Compact)
  // =========================================================================
  void _showVitalsModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 32,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Live Telemetry',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildMiniVitalCard('Heart Rate', '76 bpm', Icons.favorite_rounded, const Color(0xFFEF4444)),
                  const SizedBox(width: 8),
                  _buildMiniVitalCard('Blood Pressure', '120/80', Icons.speed_rounded, const Color(0xFF0284C7)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildMiniVitalCard('SpO2', '99 %', Icons.air_rounded, const Color(0xFF10B981)),
                  const SizedBox(width: 8),
                  _buildMiniVitalCard('Temp', '98.4 °F', Icons.thermostat_rounded, const Color(0xFFF59E0B)),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMiniVitalCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: color),
                ),
                Text(
                  label,
                  style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // END CALL HANDLER
  // =========================================================================
  void _handleEndCall() {
    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text('End Call?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
          content: Text(
            'Duration: ${_formatDuration(_callSeconds)}',
            style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogCtx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogCtx);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('End Call'),
            ),
          ],
        );
      },
    );
  }
}
