import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../patient/surgical/wound_scanner_screen.dart';
import '../../patient/notifications/notifications_screen.dart';
import '../consultation/doctor_video_consultation_screen.dart';
import '../surgical/surgeon_ot_control_screen.dart';

class DoctorDashboardScreen extends StatefulWidget {
  final VoidCallback? onOpenDrawer;
  final VoidCallback? onNavigateToBookings;

  const DoctorDashboardScreen({
    super.key,
    this.onOpenDrawer,
    this.onNavigateToBookings,
  });

  @override
  State<DoctorDashboardScreen> createState() => _DoctorDashboardScreenState();
}

class _DoctorDashboardScreenState extends State<DoctorDashboardScreen> {
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // 1. Brand Header: Exactly like User Screen ("CareSpectrum")
            _buildBrandHeader(),

            // 2. Scrollable Body
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // A. Doctor Profile Info Card (Replaces old KPI)
                    _buildDoctorInfoCard(),

                    const SizedBox(height: 14),

                    // B. Clinical Day Glance (Compact 3-metric strip)
                    _buildDailySummaryStrip(),

                    const SizedBox(height: 14),

                    // C. Next Patient In Queue (Hero Card)
                    _buildNextPatientHero(),

                    const SizedBox(height: 14),

                    // D. Quick Clinical Tools (Live OT & AI Triage)
                    _buildQuickToolsRow(),

                    const SizedBox(height: 16),

                    // E. Patient Queue Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'TODAY\'S APPOINTMENTS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            color: AppColors.textMuted,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (widget.onNavigateToBookings != null) {
                              widget.onNavigateToBookings!();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Opening full patient roster...'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'View All ➔',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // F. Clean Queue Items
                    _buildQueueItem(
                      token: '#04',
                      name: 'Amina Bibi',
                      time: '03:15 PM',
                      type: 'Teleconsult',
                      typeColor: const Color(0xFF0284C7),
                    ),
                    _buildQueueItem(
                      token: '#05',
                      name: 'Usman Farooq',
                      time: '03:45 PM',
                      type: 'In-Clinic',
                      typeColor: const Color(0xFF10B981),
                    ),
                    _buildQueueItem(
                      token: '#06',
                      name: 'Zainab Fatima',
                      time: '04:15 PM',
                      type: 'Post-Op Review',
                      typeColor: const Color(0xFFD97706),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // TOP BRAND HEADER (Exact CareSpectrum Style)
  // ==========================================
  Widget _buildBrandHeader() {
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Menu Icon
          InkWell(
            onTap: widget.onOpenDrawer,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.notes_rounded,
                size: 18,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Center: Brand Title "CareSpectrum"
          const Expanded(
            child: Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Care',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    TextSpan(
                      text: 'Spectrum',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Right: Notifications Bell
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsScreen(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // DOCTOR INFO CARD (Replaces old KPI)
  // ==========================================
  Widget _buildDoctorInfoCard() {
    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Row(
        children: [
          // Doctor Image with subtle border
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              'https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=400&auto=format&fit=crop&q=80',
              width: 52,
              height: 52,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 52,
                height: 52,
                color: AppColors.primaryLight,
                child: const Icon(Icons.person, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Doctor Credentials
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Dr. Salman Haider',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.verified_rounded, size: 14, color: AppColors.primary),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  'Consultant Laparoscopic Surgeon',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: 3),
                Row(
                  children: [
                    Icon(Icons.star_rounded, size: 13, color: Color(0xFFF59E0B)),
                    SizedBox(width: 2),
                    Text(
                      '4.9 (128)',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text('•', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                    SizedBox(width: 6),
                    Text(
                      'Shifa International',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Online / Away Switch Pill
          InkWell(
            onTap: () {
              setState(() => _isOnline = !_isOnline);
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _isOnline ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _isOnline ? const Color(0xFFA7F3D0) : const Color(0xFFFECACA),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isOnline ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _isOnline ? 'Online' : 'Away',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                      color: _isOnline ? const Color(0xFF047857) : const Color(0xFFDC2626),
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

  // ==========================================
  // COMPACT DAILY SUMMARY STRIP (1-Row)
  // ==========================================
  Widget _buildDailySummaryStrip() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem('14', 'Patients Today', const Color(0xFF0284C7)),
          Container(width: 1, height: 26, color: AppColors.border),
          _buildSummaryItem('2', 'Surgeries (OT)', const Color(0xFFD97706)),
          Container(width: 1, height: 26, color: AppColors.border),
          _buildSummaryItem('5', 'Teleconsults', const Color(0xFF10B981)),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String val, String label, Color color) {
    return Column(
      children: [
        Text(
          val,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  // ==========================================
  // NEXT PATIENT HERO CARD
  // ==========================================
  Widget _buildNextPatientHero() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFBFDBFE)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Waiting Pill & Token
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 6, color: Color(0xFF10B981)),
                    SizedBox(width: 4),
                    Text(
                      'NEXT IN QUEUE • READY',
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Token #03',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Patient Name & Clinical Reason
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text(
                    'JT',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Junaid Tariq',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '24 Y • Male • Post-Cholecystectomy Review',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 10),

          // Action Buttons: Compact 32px height
          Row(
            children: [
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DoctorVideoConsultationScreen(
                          patientName: 'Junaid Tariq',
                          patientAgeGender: '24 Y • Male',
                          clinicalNote: 'Post-Cholecystectomy Review (Day 3)',
                          tokenNumber: 'Token #03',
                          initials: 'JT',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.videocam_rounded, size: 14),
                  label: const Text('Start Video Call'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    textStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening patient medical records chart...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.folder_shared_outlined, size: 13),
                  label: const Text('Chart'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    minimumSize: const Size(0, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 11,
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

  // ==========================================
  // QUICK TOOLS ROW (Live OT & AI Triage)
  // ==========================================
  Widget _buildQuickToolsRow() {
    return Row(
      children: [
        // Live OT Status Shortcut
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SurgeonOtControlScreen(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.meeting_room_outlined, size: 18, color: Color(0xFF0284C7)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Live OT-04',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0369A1),
                          ),
                        ),
                        Text(
                          'Dissection Active',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, size: 10, color: Color(0xFF0284C7)),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // AI Wound Triage Shortcut
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const WoundScannerScreen(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFFECACA)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, size: 18, color: Color(0xFFDC2626)),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI SSI Triage',
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF991B1B),
                          ),
                        ),
                        Text(
                          '1 Alert Review',
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, size: 10, color: Color(0xFFDC2626)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // QUEUE ITEM (Clean & Simple)
  // ==========================================
  Widget _buildQueueItem({
    required String token,
    required String name,
    required String time,
    required String type,
    required Color typeColor,
  }) {
    final bool isVideo = type.toLowerCase().contains('teleconsult');

    return InkWell(
      onTap: () {
        if (isVideo) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DoctorVideoConsultationScreen(
                patientName: name,
                patientAgeGender: '30 Y • Female',
                clinicalNote: 'Scheduled Teleconsultation',
                tokenNumber: 'Token $token',
                initials: name.split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join(),
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening $name ($token) clinical profile...'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.border),
              ),
              child: Text(
                token,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    type,
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w600,
                      color: typeColor,
                    ),
                  ),
                ],
              ),
            ),
            if (isVideo) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.videocam_rounded, size: 12, color: Color(0xFF0284C7)),
                    SizedBox(width: 3),
                    Text(
                      'Video',
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              time,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
