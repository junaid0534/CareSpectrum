import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'home/patient_home.dart';
import 'appointments/patient_appointments.dart';
import 'doctors/patient_doctors.dart';
import 'records/medical_records_hub_screen.dart';
import 'profile/patient_profile.dart';
import 'ai_assistant/ai_assistant_screen.dart';
import 'medication/medication_reminder_screen.dart';
import 'surgical/wound_scanner_screen.dart';
import '../doctor/doctor_shell.dart';
import '../login_screen.dart';

class PatientShell extends StatefulWidget {
  final int initialIndex;

  const PatientShell({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<PatientShell> createState() => _PatientShellState();
}

class _PatientShellState extends State<PatientShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      PatientHomeScreen(
        onTabChange: _onTabTapped,
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      ),
      const PatientAppointmentsScreen(),
      const PatientDoctorsScreen(),
      const MedicalRecordsHubScreen(showBackButton: false),
      const PatientProfileScreen(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      drawer: _buildDrawer(context),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(22),
            topRight: Radius.circular(22),
          ),
          border: Border(
            top: BorderSide(
              color: AppColors.border.withValues(alpha: 0.8),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 18,
              offset: const Offset(0, -4),
            ),
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
            child: Row(
              children: [
                _buildBottomNavItem(
                  index: 0,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: 'Home',
                ),
                _buildBottomNavItem(
                  index: 1,
                  icon: Icons.calendar_today_outlined,
                  activeIcon: Icons.calendar_month_rounded,
                  label: 'Appointments',
                ),
                _buildBottomNavItem(
                  index: 2,
                  icon: Icons.people_outline_rounded,
                  activeIcon: Icons.people_rounded,
                  label: 'Doctors',
                ),
                _buildBottomNavItem(
                  index: 3,
                  icon: Icons.folder_shared_outlined,
                  activeIcon: Icons.folder_shared_rounded,
                  label: 'Records',
                ),
                _buildBottomNavItem(
                  index: 4,
                  icon: Icons.person_outline_rounded,
                  activeIcon: Icons.person_rounded,
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0284C7).withValues(alpha: 0.35),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const AiAssistantScreen(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: const Center(
              child: Icon(
                Icons.smart_toy_outlined,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onTabTapped(index),
          splashColor: AppColors.primary.withValues(alpha: 0.08),
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSelected ? 16 : 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFEFF6FF)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    size: 21,
                    color: isSelected
                        ? AppColors.primary
                        : const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 3),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.primary
                          : const Color(0xFF64748B),
                      letterSpacing: isSelected ? -0.1 : 0,
                    ),
                    child: Text(label),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          // Drawer Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 56, bottom: 24, left: 20, right: 20),
            decoration: const BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Center(
                    child: Text(
                      'J',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Junaid',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'patient@carespectrum.com',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),

          // Drawer Menu List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              children: [
                _buildDrawerTile(
                  icon: Icons.home_rounded,
                  title: 'Home Dashboard',
                  isSelected: _currentIndex == 0,
                  onTap: () {
                    Navigator.pop(context);
                    _onTabTapped(0);
                  },
                ),
                _buildDrawerTile(
                  icon: Icons.calendar_month_rounded,
                  title: 'My Appointments',
                  isSelected: _currentIndex == 1,
                  onTap: () {
                    Navigator.pop(context);
                    _onTabTapped(1);
                  },
                ),
                _buildDrawerTile(
                  icon: Icons.medical_services_rounded,
                  title: 'Surgeons & Doctors',
                  isSelected: _currentIndex == 2,
                  onTap: () {
                    Navigator.pop(context);
                    _onTabTapped(2);
                  },
                ),
                _buildDrawerTile(
                  icon: Icons.folder_shared_rounded,
                  title: 'Medical Records',
                  isSelected: _currentIndex == 3,
                  onTap: () {
                    Navigator.pop(context);
                    _onTabTapped(3);
                  },
                ),
                _buildDrawerTile(
                  icon: Icons.person_rounded,
                  title: 'Health Profile',
                  isSelected: _currentIndex == 4,
                  onTap: () {
                    Navigator.pop(context);
                    _onTabTapped(4);
                  },
                ),
                const Divider(height: 18, color: AppColors.border),
                _buildDrawerTile(
                  icon: Icons.alarm_on_rounded,
                  title: 'Medication Reminder',
                  iconColor: const Color(0xFF9333EA),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MedicationReminderScreen(),
                      ),
                    );
                  },
                ),
                _buildDrawerTile(
                  icon: Icons.camera_enhance_rounded,
                  title: 'AI Wound Scanner',
                  iconColor: const Color(0xFF10B981),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const WoundScannerScreen(),
                      ),
                    );
                  },
                ),
                const Divider(height: 18, color: AppColors.border),
                _buildDrawerTile(
                  icon: Icons.emergency_rounded,
                  title: 'Emergency SOS',
                  iconColor: AppColors.error,
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('CareSpectrum Emergency Helpline: 1122'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  },
                ),
                _buildDrawerTile(
                  icon: Icons.help_outline_rounded,
                  title: 'Help & Support',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                _buildDrawerTile(
                  icon: Icons.swap_horiz_rounded,
                  title: 'Switch to Doctor Portal',
                  iconColor: const Color(0xFF0284C7),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DoctorShell(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Sign Out Button
          Padding(
            padding: const EdgeInsets.all(16),
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout_rounded, size: 16, color: AppColors.error),
              label: const Text(
                'Sign Out',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.error,
                ),
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 44),
                side: const BorderSide(color: Color(0xFFFCA5A5)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerTile({
    required IconData icon,
    required String title,
    bool isSelected = false,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: isSelected ? AppColors.primaryLight : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: onTap,
          dense: true,
          leading: Icon(
            icon,
            size: 20,
            color: isSelected
                ? AppColors.primary
                : iconColor ?? AppColors.textSecondary,
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
            ),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
