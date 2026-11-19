import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/mock_data.dart';
import '../../../models/appointment.dart';
import '../../../models/doctor.dart';
import '../booking/appointment_booking_screen.dart';
import '../booking/booking_slip_screen.dart';
import '../doctors/doctor_profile_screen.dart';
import 'doctor_review_screen.dart';

class PatientAppointmentsScreen extends StatefulWidget {
  const PatientAppointmentsScreen({super.key});

  @override
  State<PatientAppointmentsScreen> createState() =>
      _PatientAppointmentsScreenState();
}

class _PatientAppointmentsScreenState extends State<PatientAppointmentsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Appointment> _appointmentList;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
    _appointmentList = List.from(MockData.appointments);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Doctor _findDoctorForAppointment(Appointment appt) {
    return MockData.doctors.firstWhere(
      (d) =>
          d.name.toLowerCase() == appt.doctorName.toLowerCase() ||
          d.specialty.toLowerCase() == appt.specialty.toLowerCase(),
      orElse: () => Doctor(
        id: appt.id,
        name: appt.doctorName,
        specialty: appt.specialty,
        hospital: appt.hospital,
        rating: 4.9,
        reviews: 120,
        experience: '12 Years',
        fee: appt.fee,
        imageUrl: appt.doctorImageUrl ??
            'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=400&auto=format&fit=crop&q=80',
      ),
    );
  }

  void _openAppointmentSlip(Appointment appt) {
    final doctor = _findDoctorForAppointment(appt);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingSlipScreen(
          doctor: doctor,
          consultMode: appt.type == 'Teleconsult'
              ? 'Teleconsultation (Video Call)'
              : 'Hospital Visit',
          selectedDate: DateTime.now(),
          selectedSlot: appt.time,
          patientName: 'Junaid',
          patientAge: '24',
          patientCnic: '35201-1234567-1',
          patientPhone: '0301-4025346',
          reasonForVisit: 'Routine Clinical Follow-up & Review',
          paymentMethod: 'EasyPaisa',
        ),
      ),
    );
  }

  Future<void> _openReviewScreen(Appointment appt) async {
    final updatedAppt = await Navigator.push<Appointment>(
      context,
      MaterialPageRoute(
        builder: (_) => DoctorReviewScreen(appointment: appt),
      ),
    );

    if (updatedAppt != null) {
      setState(() {
        final idx = _appointmentList.indexWhere((a) => a.id == updatedAppt.id);
        if (idx != -1) {
          _appointmentList[idx] = updatedAppt;
        }
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Verified review published for ${updatedAppt.doctorName}!',
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showDoctorCallNotice(Appointment appt) {
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
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: const Icon(
                  Icons.videocam_outlined,
                  color: AppColors.primary,
                  size: 28,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Teleconsultation Security Policy',
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'To prevent doctor disruptions during live clinical operations, patients cannot dial in advance.\n\n${appt.doctorName} will initiate your encrypted video consultation precisely at ${appt.time}.\n\nPlease ensure your device internet is active and stay in this app.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Understood',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCancelDialog(Appointment appt) {
    String selectedReason = 'Schedule Conflict';
    final reasons = [
      'Schedule Conflict',
      'Recovered / Feeling Better',
      'Prefer in-person doctor visit',
      'Emergency personal circumstances',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
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
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 44,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Cancel Appointment',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Appointment with ${appt.doctorName} on ${appt.date} (${appt.time}) will be cancelled.',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Reason for cancellation:',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Column(
                  children: reasons.map((r) {
                    final isSel = selectedReason == r;
                    return InkWell(
                      onTap: () => setSheetState(() => selectedReason = r),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSel
                              ? AppColors.primaryLight
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSel ? AppColors.primary : AppColors.border,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isSel
                                  ? Icons.radio_button_checked_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              size: 18,
                              color: isSel
                                  ? AppColors.primary
                                  : AppColors.textMuted,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                r,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  fontWeight:
                                      isSel ? FontWeight.w700 : FontWeight.w500,
                                  color: isSel
                                      ? AppColors.primaryDark
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Keep Booking'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            final idx = _appointmentList
                                .indexWhere((a) => a.id == appt.id);
                            if (idx != -1) {
                              _appointmentList[idx] = Appointment(
                                id: appt.id,
                                doctorName: appt.doctorName,
                                specialty: appt.specialty,
                                hospital: appt.hospital,
                                date: appt.date,
                                time: appt.time,
                                status: 'Cancelled',
                                type: appt.type,
                                fee: appt.fee,
                                doctorImageUrl: appt.doctorImageUrl,
                                tokenNumber: appt.tokenNumber,
                                isLiveNow: false,
                                cancelReason: selectedReason,
                              );
                            }
                          });
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Appointment has been cancelled.'),
                              backgroundColor: Color(0xFFEF4444),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: const Size(double.infinity, 44),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Confirm Cancel',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _rescheduleAppointment(Appointment appt) {
    final doctor = _findDoctorForAppointment(appt);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AppointmentBookingScreen(
          doctor: doctor,
          initialMode: appt.type == 'Teleconsult'
              ? 'Teleconsultation'
              : 'Hospital Visit',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final upcomingCount =
        _appointmentList.where((a) => a.status == 'Upcoming').length;
    final completedCount =
        _appointmentList.where((a) => a.status == 'Completed').length;
    final cancelledCount =
        _appointmentList.where((a) => a.status == 'Cancelled').length;

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
          child: const SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Center(
                child: Text(
                  'My Appointments',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          // Clean Simple Filter Tabs (No Card Wrapper)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _buildFilterTab(0, 'Upcoming ($upcomingCount)'),
                const SizedBox(width: 8),
                _buildFilterTab(1, 'Completed ($completedCount)'),
                const SizedBox(width: 8),
                _buildFilterTab(2, 'Cancelled ($cancelledCount)'),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Tab views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAppointmentList('Upcoming'),
                _buildAppointmentList('Completed'),
                _buildAppointmentList('Cancelled'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTab(int tabIndex, String label) {
    final isSelected = _tabController.index == tabIndex;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _tabController.animateTo(tabIndex);
          });
        },
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 36,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.22),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppointmentList(String status) {
    final list = _appointmentList.where((a) => a.status == status).toList();

    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.border),
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  size: 28,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'No $status Appointments',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Book consultations with top surgeons & specialists.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final appt = list[index];
        return Column(
          children: [
            _buildAppointmentCard(appt),
            _buildDottedLine(),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildDottedLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const dashWidth = 5.0;
          const dashSpace = 4.0;
          final dashCount =
              (constraints.constrainWidth() / (dashWidth + dashSpace)).floor();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(dashCount, (_) {
              return const SizedBox(
                width: dashWidth,
                height: 1.2,
                child: DecoratedBox(
                  decoration: BoxDecoration(color: AppColors.border),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appt) {
    final isUpcoming = appt.status == 'Upcoming';
    final isCompleted = appt.status == 'Completed';
    final isCancelled = appt.status == 'Cancelled';
    final isTeleconsult = appt.type.toLowerCase().contains('tele');
    final doctorImage = appt.doctorImageUrl ??
        'https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=400&auto=format&fit=crop&q=80';

    return InkWell(
      onTap: () => _openAppointmentSlip(appt),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Mode Badge + Token + Status Badge (Zero-overflow responsive layout)
            Row(
              children: [
                // Mode Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: isTeleconsult
                        ? const Color(0xFFEFF6FF)
                        : const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                      color: isTeleconsult
                          ? const Color(0xFFBFDBFE)
                          : const Color(0xFFBBF7D0),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isTeleconsult
                            ? Icons.videocam_rounded
                            : Icons.local_hospital_rounded,
                        size: 12,
                        color: isTeleconsult
                            ? const Color(0xFF0284C7)
                            : const Color(0xFF16A34A),
                      ),
                      const SizedBox(width: 3.5),
                      Text(
                        isTeleconsult ? 'Video Call' : 'Hospital Visit',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: isTeleconsult
                              ? const Color(0xFF0369A1)
                              : const Color(0xFF15803D),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // Status Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: isUpcoming
                        ? const Color(0xFFECFDF5)
                        : isCompleted
                            ? const Color(0xFFF1F5F9)
                            : const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(
                      color: isUpcoming
                          ? const Color(0xFFA7F3D0)
                          : isCompleted
                              ? const Color(0xFFE2E8F0)
                              : const Color(0xFFFECACA),
                    ),
                  ),
                  child: Text(
                    isUpcoming
                        ? 'CONFIRMED'
                        : isCompleted
                            ? 'COMPLETED'
                            : 'CANCELLED',
                    style: TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: isUpcoming
                          ? const Color(0xFF047857)
                          : isCompleted
                              ? const Color(0xFF475569)
                              : const Color(0xFFDC2626),
                      letterSpacing: 0.2,
                    ),
                  ),
                ),

                if (isUpcoming) ...[
                  const SizedBox(width: 2),
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      iconSize: 16,
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        size: 16,
                        color: AppColors.textMuted,
                      ),
                      onSelected: (val) {
                        if (val == 'cancel') {
                          _showCancelDialog(appt);
                        } else if (val == 'reschedule') {
                          _rescheduleAppointment(appt);
                        }
                      },
                      itemBuilder: (_) => [
                        const PopupMenuItem(
                          value: 'reschedule',
                          child: Row(
                            children: [
                              Icon(Icons.edit_calendar_rounded,
                                  size: 16, color: AppColors.primary),
                              SizedBox(width: 8),
                              Text('Reschedule Slot',
                                  style: TextStyle(fontSize: 12.5)),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'cancel',
                          child: Row(
                            children: [
                              Icon(Icons.cancel_outlined,
                                  size: 16, color: Color(0xFFEF4444)),
                              SizedBox(width: 8),
                              Text('Cancel Booking',
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      color: Color(0xFFEF4444))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),

            // Row 2: Doctor Profile Row
            Row(
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        doctorImage,
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 44,
                          height: 44,
                          color: AppColors.primaryLight,
                          child: const Icon(Icons.person,
                              color: AppColors.primary, size: 24),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified_rounded,
                          size: 12,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appt.doctorName,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        appt.specialty,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        appt.hospital,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Row 3: Schedule & Fee Box
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 12,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    appt.date,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.access_time_rounded,
                    size: 12,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    appt.time,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    appt.fee,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            // Row 4: Teleconsultation Doctor Call Guard Notice
            if (isUpcoming && isTeleconsult) ...[
              const SizedBox(height: 10),
              if (appt.isLiveNow)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFFECFDF5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${appt.doctorName} is online & ready for session!',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF047857),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                InkWell(
                  onTap: () => _showDoctorCallNotice(appt),
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.lock_clock_rounded,
                          size: 14,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            'Doctor will initiate call at ${appt.time} (Patient dial disabled)',
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 13,
                          color: AppColors.textMuted,
                        ),
                      ],
                    ),
                  ),
                ),
            ],

            // Row 5: Cancelled Reason
            if (isCancelled && appt.cancelReason != null) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_rounded,
                        size: 13, color: Color(0xFFDC2626)),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Reason: ${appt.cancelReason}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFB91C1C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 12),

            // Row 6: Primary Actions
            if (isUpcoming)
              Row(
                children: [
                  // Direct Cancel Button
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showCancelDialog(appt),
                      icon: const Icon(Icons.close_rounded, size: 13),
                      label: const Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFDC2626),
                        side: const BorderSide(color: Color(0xFFFCA5A5)),
                        minimumSize: const Size(0, 32),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // E-Slip Button
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _openAppointmentSlip(appt),
                      icon: const Icon(Icons.receipt_long_rounded, size: 13),
                      label: const Text('View E-Slip'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 32),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  if (appt.isLiveNow) ...[
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Connecting live session with ${appt.doctorName}...'),
                              backgroundColor: const Color(0xFF10B981),
                            ),
                          );
                        },
                        icon: const Icon(Icons.videocam_rounded, size: 14),
                        label: const Text('Join Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(0, 32),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                          textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ],
              )
            else if (isCompleted) ...[
              if (appt.hasReviewed) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFDE68A)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, size: 15, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 4),
                      Text(
                        '${appt.patientRating!.toStringAsFixed(1)} ★ Rated',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFB45309),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        '• Verified Review',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFD97706),
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () => _openReviewScreen(appt),
                        child: const Text(
                          'Edit Review',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
              ] else ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _openReviewScreen(appt),
                    icon: const Icon(Icons.star_rounded, size: 14, color: Color(0xFFF59E0B)),
                    label: const Text('Rate Consultation (Verified)'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFFBEB),
                      foregroundColor: const Color(0xFFB45309),
                      side: const BorderSide(color: Color(0xFFFDE68A)),
                      minimumSize: const Size(double.infinity, 30),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
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
                const SizedBox(height: 6),
              ],
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _openAppointmentSlip(appt),
                      icon: const Icon(Icons.receipt_long_rounded, size: 13),
                      label: const Text('View Slip'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(0, 32),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final doctor = _findDoctorForAppointment(appt);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DoctorProfileScreen(doctor: doctor),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 32),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                      child: const Text('Book Follow-up'),
                    ),
                  ),
                ],
              ),
            ]
            else
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    final doctor = _findDoctorForAppointment(appt);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DoctorProfileScreen(doctor: doctor),
                      ),
                    );
                  },
                  icon: const Icon(Icons.refresh_rounded, size: 14),
                  label: const Text('Re-Book Appointment'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}