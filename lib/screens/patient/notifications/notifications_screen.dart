import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../models/health_notification.dart';
import 'notification_detail_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Appointments',
    'Prescriptions',
    'Surgical & Vault',
  ];

  late List<HealthNotification> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = [
      const HealthNotification(
        id: 'notif_ot',
        title: 'Live OT Milestone Update: Suite #03 Active',
        message: 'Dr. Salman Haider: Laparoscopic dissection complete with stable hemodynamics.',
        detailedMessage:
            'Active surgery broadcast from Modular OT Suite #03. Vitals are completely stable (HR 74 bpm, BP 118/76, SpO2 99%). Dissection of gallbladder successfully concluded. Estimated transfer to Recovery Room at 12:15 PM.',
        category: 'Surgical & Vault',
        timeAgo: 'Just now',
        fullDate: 'Today, 16 Nov 2026 • 11:45 AM',
        isRead: false,
        icon: Icons.meeting_room_outlined,
        themeColor: Color(0xFF0284C7),
        bgColor: Color(0xFFEFF6FF),
        actionLabel: 'Track Live OT Status',
        actionType: 'ot_live',
      ),
      const HealthNotification(
        id: 'notif_1',
        title: 'Teleconsultation Confirmed with Dr. Tariq Mahmood',
        message: 'Your HD video consultation slot is locked for 18 Nov at 10:15 AM.',
        detailedMessage:
            'Dr. Tariq Mahmood (Cardiothoracic Surgeon) has confirmed your appointment. Please ensure you are in a quiet room with a stable internet connection 10 minutes prior to the consultation session.',
        category: 'Appointments',
        timeAgo: '12m ago',
        fullDate: 'Today, 16 Nov 2026 • 10:45 AM',
        isRead: false,
        icon: Icons.video_camera_front_outlined,
        themeColor: Color(0xFF0284C7),
        bgColor: Color(0xFFEFF6FF),
        actionLabel: 'View Appointment Slip',
        actionType: 'appointment',
      ),
      const HealthNotification(
        id: 'notif_2',
        title: 'Morning Medication Dose Reminder: Tab. Concor 5mg',
        message: 'Time for your daily morning beta-blocker dose with water after breakfast.',
        detailedMessage:
            'Clinical dosage alert for Tab. Concor 5mg. Take 1 tablet after food as prescribed by Dr. Tariq Mahmood. Do not skip or alter dosage without medical consultation.',
        category: 'Prescriptions',
        timeAgo: '1h ago',
        fullDate: 'Today, 16 Nov 2026 • 09:30 AM',
        isRead: false,
        icon: Icons.medication_outlined,
        themeColor: Color(0xFF059669),
        bgColor: Color(0xFFECFDF5),
        actionLabel: 'View Medication Schedule',
        actionType: 'prescription',
      ),
      const HealthNotification(
        id: 'notif_3',
        title: 'Pre-Operative Fasting Protocol Checklist Ready',
        message: 'Please review guidelines for solid foods and fluid restriction before surgery.',
        detailedMessage:
            'For your upcoming elective procedure with Dr. Salman Haider, observe strict solid food restriction 8 hours prior. Clear water is permitted up to 2 hours before general anesthesia.',
        category: 'Surgical & Vault',
        timeAgo: '3h ago',
        fullDate: 'Today, 16 Nov 2026 • 07:15 AM',
        isRead: false,
        icon: Icons.medical_services_outlined,
        themeColor: Color(0xFFD97706),
        bgColor: Color(0xFFFFFBEB),
        actionLabel: 'Review Pre-Op Guide',
        actionType: 'surgical',
      ),
      const HealthNotification(
        id: 'notif_4',
        title: 'Diagnostic Lab Report Synced: Blood Picture (CBC)',
        message: 'Chughtai Healthcare Lab has uploaded your verified PDF test results.',
        detailedMessage:
            'Your Complete Blood Picture (CP & ESR) has been cryptographically signed and archived into your encrypted CareSpectrum Health Vault. All tested parameters are within normal baseline.',
        category: 'Surgical & Vault',
        timeAgo: 'Yesterday',
        fullDate: '15 Nov 2026 • 04:20 PM',
        isRead: true,
        icon: Icons.science_outlined,
        themeColor: Color(0xFF6366F1),
        bgColor: Color(0xFFEEF2FF),
        actionLabel: 'Open Report in Vault',
        actionType: 'record',
      ),
      const HealthNotification(
        id: 'notif_5',
        title: 'Post-Op Follow-up Slot Reminder (Shifa International)',
        message: 'Laparoscopic incision checkup scheduled for Thursday morning.',
        detailedMessage:
            'In-person clinical inspection of trocar incision sites and suture healing with Dr. Salman Haider. Bring your previous discharge summary pass.',
        category: 'Appointments',
        timeAgo: '2 days ago',
        fullDate: '14 Nov 2026 • 02:10 PM',
        isRead: true,
        icon: Icons.calendar_month_outlined,
        themeColor: Color(0xFF0284C7),
        bgColor: Color(0xFFEFF6FF),
        actionLabel: 'View Booking Details',
        actionType: 'appointment',
      ),
      const HealthNotification(
        id: 'notif_6',
        title: 'Prescription Refill Approved: Cap. Lipiget 20mg',
        message: 'Your 30-day lipid maintenance therapy refill has been validated.',
        detailedMessage:
            'Your routine follow-up lipid control prescription for Cap. Lipiget 20mg has been authorized for 30 days. Maintain regular bedtime administration.',
        category: 'Prescriptions',
        timeAgo: '3 days ago',
        fullDate: '13 Nov 2026 • 11:00 AM',
        isRead: true,
        icon: Icons.medication_liquid_outlined,
        themeColor: Color(0xFF059669),
        bgColor: Color(0xFFECFDF5),
        actionLabel: 'View Digital Prescription',
        actionType: 'prescription',
      ),
    ];
  }

  List<HealthNotification> _getFilteredNotifications() {
    if (_selectedCategory == 'All') return _notifications;
    return _notifications
        .where((n) => n.category == _selectedCategory)
        .toList();
  }

  void _markAllAsRead() {
    setState(() {
      _notifications = _notifications.map((n) => n.copyWith(isRead: true)).toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            Icon(Icons.done_all_rounded, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('All notifications marked as read'),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildDottedLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
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

  void _openNotification(HealthNotification notif) async {
    // Mark as read in state
    final index = _notifications.indexWhere((n) => n.id == notif.id);
    if (index != -1 && !notif.isRead) {
      setState(() {
        _notifications[index] = notif.copyWith(isRead: true);
      });
    }

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => NotificationDetailScreen(notification: notif),
      ),
    );

    if (result == 'deleted') {
      setState(() {
        _notifications.removeWhere((n) => n.id == notif.id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _getFilteredNotifications();
    final unreadCount = _notifications.where((n) => !n.isRead).length;

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
                        'Notifications',
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
                      Icons.done_all_rounded,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    onPressed: _markAllAsRead,
                    tooltip: 'Mark all as read',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // 1. Category Filter Pills
          Container(
            height: 38,
            margin: const EdgeInsets.fromLTRB(0, 12, 0, 8),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;

                return InkWell(
                  onTap: () => setState(() => _selectedCategory = cat),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. Unread Status Strip (if any unread exists)
          if (unreadCount > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$unreadCount unread health alerts',
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

          // 3. Notifications List
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState()
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => _buildDottedLine(),
                    itemBuilder: (context, index) {
                      final notif = filtered[index];
                      return _buildNotificationCard(notif);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(HealthNotification notif) {
    return InkWell(
      onTap: () => _openNotification(notif),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: notif.isRead
              ? AppColors.surface
              : const Color(0xFFF0F9FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: notif.isRead
                ? AppColors.border
                : const Color(0xFFBAE6FD),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Icon Container
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: notif.bgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                notif.icon,
                color: notif.themeColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: notif.bgColor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          notif.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: notif.themeColor,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          if (!notif.isRead) ...[
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: Color(0xFF0284C7),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 5),
                          ],
                          Text(
                            notif.timeAgo,
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),

                  // Notification Title
                  Text(
                    notif.title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                          notif.isRead ? FontWeight.w600 : FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Message Preview
                  Text(
                    notif.message,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFF1F5F9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_off_outlined,
              size: 32,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'No Notifications Found',
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'You are all caught up in this category',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
