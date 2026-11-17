import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../models/ot_tracking_model.dart';

class LiveOtTrackerScreen extends StatefulWidget {
  final String? caseId;

  const LiveOtTrackerScreen({
    super.key,
    this.caseId,
  });

  @override
  State<LiveOtTrackerScreen> createState() => _LiveOtTrackerScreenState();
}

class _LiveOtTrackerScreenState extends State<LiveOtTrackerScreen> {
  late OtCaseDetails _caseDetails;
  late Timer _liveTimer;
  int _elapsedSeconds = 5078; // 1 hr 24 mins 38 secs
  bool _smsAlertsEnabled = true;

  @override
  void initState() {
    super.initState();
    _initCaseDetails();
    _startLiveTimer();
  }

  void _startLiveTimer() {
    _liveTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  @override
  void dispose() {
    _liveTimer.cancel();
    super.dispose();
  }

  String _formatElapsedTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;
    final hStr = hours.toString().padLeft(2, '0');
    final mStr = minutes.toString().padLeft(2, '0');
    final sStr = seconds.toString().padLeft(2, '0');
    return '$hStr:$mStr:$sStr';
  }

  void _initCaseDetails() {
    _caseDetails = const OtCaseDetails(
      caseId: 'OT-9842',
      patientName: 'Junaid',
      procedureName: 'Laparoscopic Cholecystectomy',
      hospitalName: 'Shifa International Hospital',
      otSuite: 'OT Suite #03',
      leadSurgeon: 'Dr. Salman Haider',
      anesthesiologist: 'Dr. Ayesha Malik',
      nurseInCharge: 'Staff Nurse Zainab',
      startTime: '10:15 AM',
      estimatedEndTime: '12:15 PM',
      estimatedDuration: '1h 45m',
      currentStageIndex: 3,
      liveSurgeryNote:
          'Gallbladder dissection in progress. Vitals completely stable.',
      currentVitals: {
        'Heart Rate': '74 bpm',
        'BP': '118/76',
        'SpO2': '99%',
      },
      milestones: [
        OtMilestone(
          title: 'Pre-Op Preparation',
          description: 'Identity verified, IV placed',
          time: '08:30 AM',
          isCompleted: true,
          isCurrent: false,
          icon: Icons.checklist_rounded,
        ),
        OtMilestone(
          title: 'Shifted to OT Suite #03',
          description: 'Surgical field prepped',
          time: '09:05 AM',
          isCompleted: true,
          isCurrent: false,
          icon: Icons.meeting_room_outlined,
        ),
        OtMilestone(
          title: 'Anesthesia Induced',
          description: 'Airway secured, vitals normal',
          time: '09:30 AM',
          isCompleted: true,
          isCurrent: false,
          icon: Icons.vaccines_outlined,
        ),
        OtMilestone(
          title: 'Surgery in Progress',
          description: 'Active laparoscopic procedure by Dr. Salman Haider',
          time: '09:50 AM',
          isCompleted: false,
          isCurrent: true,
          clinicalNote: 'Dissection active with zero bleeding. Vitals stable.',
          icon: Icons.medical_services_outlined,
        ),
        OtMilestone(
          title: 'Surgical Closure',
          description: 'Suture closure & anesthesia reversal',
          time: '12:00 PM (Est.)',
          isCompleted: false,
          isCurrent: false,
          icon: Icons.health_and_safety_outlined,
        ),
        OtMilestone(
          title: 'Recovery Room (PACU)',
          description: 'Post-op observation',
          time: '12:20 PM (Est.)',
          isCompleted: false,
          isCurrent: false,
          icon: Icons.bed_outlined,
        ),
        OtMilestone(
          title: 'Shifted to Room #402',
          description: 'Family visiting open',
          time: '01:45 PM (Est.)',
          isCompleted: false,
          isCurrent: false,
          icon: Icons.room_preferences_outlined,
        ),
      ],
    );
  }

  void _callOtDesk() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dialing OT Waiting Lounge Nurse (Ext. 4021)...'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showHospitalAmenities() {
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
              'Hospital Amenities',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildAmenityRow(Icons.weekend_outlined, 'Attendant Lounge', '2nd Floor, Near OT #3'),
            _buildAmenityRow(Icons.restaurant_outlined, 'Cafeteria', 'Basement 1 • 24/7 Open'),
            _buildAmenityRow(Icons.mosque_outlined, 'Prayer Area', 'Ground Floor East Wing'),
            _buildAmenityRow(Icons.local_pharmacy_outlined, 'Pharmacy', 'Main Entrance 24/7'),
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
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenityRow(IconData icon, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$title • $desc',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
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
                        'Live OT Tracker',
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
                    onPressed: _showHospitalAmenities,
                    tooltip: 'Hospital Amenities',
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
            // 1. Unified Clean Hero Card (Status + Timer + Vitals + Surgery)
            _buildUnifiedHeroCard(),

            const SizedBox(height: 16),

            // 2. Timeline Header
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'SURGICAL TIMELINE',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: AppColors.textMuted,
                  ),
                ),
                Text(
                  'Stage 4 of 7 Active',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 3. Clean Milestone Timeline
            _buildCleanTimeline(),

            const SizedBox(height: 16),

            // 4. Clean Family Support Strip
            _buildCleanFamilyCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildUnifiedHeroCard() {
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
          // Top Row: Status pill & Room
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 7, color: Color(0xFF10B981)),
                    SizedBox(width: 5),
                    Text(
                      'IN SURGERY',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF047857),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                'Suite #03 • Shifa Int.',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Surgery & Doctor
          Text(
            _caseDetails.procedureName,
            style: const TextStyle(
              fontSize: 15.5,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${_caseDetails.leadSurgeon} • Patient: ${_caseDetails.patientName}',
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),

          // Timer & Remaining
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ELAPSED TIME',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMuted,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatElapsedTime(_elapsedSeconds),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Est: ${_caseDetails.estimatedEndTime} (~30m left)',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 10),

          // 3 Compact Vitals
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCleanVital('Heart Rate', '74 bpm', const Color(0xFFEF4444)),
              _buildCleanDivider(),
              _buildCleanVital('Blood Pressure', '118/76', const Color(0xFF0284C7)),
              _buildCleanDivider(),
              _buildCleanVital('Oxygen SpO2', '99%', const Color(0xFF10B981)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCleanVital(String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.circle, size: 6, color: color),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9.5,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCleanDivider() {
    return Container(
      width: 1,
      height: 18,
      color: AppColors.border,
    );
  }

  Widget _buildCleanTimeline() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _caseDetails.milestones.length,
        separatorBuilder: (_, __) => _buildSimpleConnector(),
        itemBuilder: (context, index) {
          final m = _caseDetails.milestones[index];
          return _buildCleanMilestoneRow(m);
        },
      ),
    );
  }

  Widget _buildSimpleConnector() {
    return Padding(
      padding: const EdgeInsets.only(left: 11, top: 2, bottom: 2),
      child: Container(
        width: 1.5,
        height: 14,
        color: AppColors.border,
      ),
    );
  }

  Widget _buildCleanMilestoneRow(OtMilestone m) {
    Color dotColor = AppColors.border;
    Widget statusBadge = const SizedBox.shrink();

    if (m.isCompleted) {
      dotColor = const Color(0xFF10B981);
    } else if (m.isCurrent) {
      dotColor = AppColors.primary;
      statusBadge = Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Text(
          'NOW',
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w800,
            color: AppColors.primaryDark,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Status Dot
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: m.isCompleted
                    ? const Color(0xFFECFDF5)
                    : m.isCurrent
                        ? AppColors.primaryLight
                        : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
                border: Border.all(color: dotColor, width: m.isCurrent ? 2 : 1),
              ),
              child: Center(
                child: m.isCompleted
                    ? const Icon(Icons.check, size: 13, color: Color(0xFF10B981))
                    : Icon(Icons.circle,
                        size: 7,
                        color: m.isCurrent
                            ? AppColors.primary
                            : AppColors.textMuted),
              ),
            ),
            const SizedBox(width: 10),

            // Milestone Title
            Expanded(
              child: Text(
                m.title,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: m.isCurrent
                      ? FontWeight.w700
                      : m.isCompleted
                          ? FontWeight.w600
                          : FontWeight.w500,
                  color: m.isCurrent
                      ? AppColors.textPrimary
                      : m.isCompleted
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                ),
              ),
            ),
            const SizedBox(width: 6),
            if (m.isCurrent) statusBadge else ...[
              Text(
                m.time,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: m.isCompleted ? AppColors.textSecondary : AppColors.textMuted,
                ),
              ),
            ],
          ],
        ),

        // Live note for active step
        if (m.isCurrent && m.clinicalNote != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 34, top: 4),
            child: Text(
              m.clinicalNote!,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCleanFamilyCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.notifications_active_outlined,
                      size: 16, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'SMS Alerts for Family',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Switch.adaptive(
                value: _smsAlertsEnabled,
                activeTrackColor: AppColors.primary,
                onChanged: (val) {
                  setState(() => _smsAlertsEnabled = val);
                },
              ),
            ],
          ),
          const Divider(height: 16, color: AppColors.border),
          InkWell(
            onTap: _callOtDesk,
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone_in_talk_rounded, size: 14, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text(
                    'Call Waiting Lounge Desk (Ext. 4021)',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
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
}
