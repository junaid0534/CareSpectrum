import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../models/health_notification.dart';
import '../records/medical_records_hub_screen.dart';
import '../appointments/patient_appointments.dart';
import '../surgical/live_ot_tracker_screen.dart';
import '../surgical/preop_readiness_screen.dart';

class NotificationDetailScreen extends StatelessWidget {
  final HealthNotification notification;

  const NotificationDetailScreen({
    super.key,
    required this.notification,
  });

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
                        'Notification Details',
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
                      Icons.delete_outline_rounded,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      Navigator.pop(context, 'deleted');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Notification removed'),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    tooltip: 'Delete Notification',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Notification Header Card
            Container(
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
                  // Category Pill & Date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: notification.bgColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(notification.icon,
                                size: 14, color: notification.themeColor),
                            const SizedBox(width: 5),
                            Text(
                              notification.category.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: notification.themeColor,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        notification.timeAgo,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Title
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Full Date
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 13,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        notification.fullDate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 14),

                  // Detailed Clinical Message
                  Text(
                    notification.detailedMessage,
                    style: const TextStyle(
                      fontSize: 13.5,
                      color: AppColors.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Associated Action Preview Card (Category-Specific)
            _buildAssociatedActionCard(context),

            const SizedBox(height: 24),

            // 3. Primary Action Button
            if (notification.actionLabel != null)
              ElevatedButton.icon(
                onPressed: () => _handlePrimaryAction(context),
                icon: Icon(
                  notification.category == 'Appointments'
                      ? Icons.calendar_month_outlined
                      : notification.category == 'Prescriptions'
                          ? Icons.medication_outlined
                          : Icons.folder_shared_outlined,
                  size: 18,
                ),
                label: Text(notification.actionLabel!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: notification.themeColor,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssociatedActionCard(BuildContext context) {
    if (notification.category == 'Appointments') {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.video_camera_front_outlined,
                    size: 16, color: Color(0xFF0284C7)),
                SizedBox(width: 8),
                Text(
                  'Teleconsultation Information',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildMetaRow('Doctor', 'Dr. Tariq Mahmood (Cardiothoracic)'),
            const SizedBox(height: 6),
            _buildMetaRow('Session Time', '18 Nov, 2026 • 10:15 AM'),
            const SizedBox(height: 6),
            _buildMetaRow('Consultation Mode', 'End-to-End HD Video Room'),
          ],
        ),
      );
    }

    if (notification.category == 'Prescriptions') {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.medication_liquid_outlined,
                    size: 16, color: Color(0xFF059669)),
                SizedBox(width: 8),
                Text(
                  'Medication Dosage Reminder',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _buildMetaRow('Medicine', 'Tab. Concor 5mg (Bisoprolol)'),
            const SizedBox(height: 6),
            _buildMetaRow('Dosage Schedule', '1 Tablet Daily (Morning after food)'),
            const SizedBox(height: 6),
            _buildMetaRow('Prescribed By', 'Dr. Tariq Mahmood • NICVD'),
          ],
        ),
      );
    }

    // Default Surgical / Vault Card
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.health_and_safety_outlined,
                  size: 16, color: notification.themeColor),
              const SizedBox(width: 8),
              const Text(
                'Digital Health Vault Sync',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildMetaRow('Record Title', 'Complete Blood Picture (CP & ESR)'),
          const SizedBox(height: 6),
          _buildMetaRow('Diagnostic Center', 'Chughtai Healthcare Lab'),
          const SizedBox(height: 6),
          _buildMetaRow('File Security', 'Cryptographically Signed PDF (2.4 MB)'),
        ],
      ),
    );
  }

  Widget _buildMetaRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }

  void _handlePrimaryAction(BuildContext context) {
    if (notification.actionType == 'ot_live') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const LiveOtTrackerScreen(),
        ),
      );
    } else if (notification.actionType == 'surgical') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PreOpReadinessScreen(),
        ),
      );
    } else if (notification.category == 'Appointments') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const PatientAppointmentsScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const MedicalRecordsHubScreen(),
        ),
      );
    }
  }
}
