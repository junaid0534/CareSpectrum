import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import 'dashboard/doctor_dashboard_screen.dart';
import 'bookings/doctor_bookings_screen.dart';
import 'surgical/surgeon_ot_control_screen.dart';
import '../patient/surgical/wound_scanner_screen.dart';
import '../patient/patient_shell.dart';
import '../login_screen.dart';

class DoctorShell extends StatefulWidget {
  final int initialIndex;

  const DoctorShell({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<DoctorShell> createState() => _DoctorShellState();
}

class _DoctorShellState extends State<DoctorShell> {
  late int _currentIndex;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabTapped(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      DoctorDashboardScreen(
        onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
        onNavigateToBookings: () => _onTabTapped(1),
      ),
      const DoctorBookingsScreen(),
      const SurgeonOtControlScreen(),
      const WoundScannerScreen(),
      _buildDoctorProfilePlaceholder(),
    ];

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.background,
      drawer: _buildDoctorDrawer(),
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
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
            child: Row(
              children: [
                _buildNavItem(
                  index: 0,
                  icon: Icons.dashboard_outlined,
                  activeIcon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                ),
                _buildNavItem(
                  index: 1,
                  icon: Icons.calendar_month_outlined,
                  activeIcon: Icons.calendar_month_rounded,
                  label: 'Bookings',
                ),
                _buildNavItem(
                  index: 2,
                  icon: Icons.meeting_room_outlined,
                  activeIcon: Icons.meeting_room_rounded,
                  label: 'Live OT',
                ),
                _buildNavItem(
                  index: 3,
                  icon: Icons.camera_enhance_outlined,
                  activeIcon: Icons.camera_enhance_rounded,
                  label: 'AI Triage',
                ),
                _buildNavItem(
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
    );
  }

  Widget _buildNavItem({
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isSelected = _currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => _onTabTapped(index),
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFEFF6FF) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected ? AppColors.primary : AppColors.textMuted,
                size: 20,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================
  // DOCTOR SIDE DRAWER
  // ==========================================
  Widget _buildDoctorDrawer() {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            // Header Profile
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: const Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=400&auto=format&fit=crop&q=80',
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Dr. Salman Haider',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Consultant Surgeon • Shifa',
                          style: TextStyle(
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

            // Navigation Options
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  ListTile(
                    leading: const Icon(Icons.dashboard_rounded, color: AppColors.primary, size: 20),
                    title: const Text('Dashboard', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                    onTap: () {
                      Navigator.pop(context);
                      _onTabTapped(0);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 20),
                    title: const Text('Patient Bookings', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                    onTap: () {
                      Navigator.pop(context);
                      _onTabTapped(1);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.meeting_room_rounded, color: Color(0xFF0284C7), size: 20),
                    title: const Text('Live OT Telemetry', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                    onTap: () {
                      Navigator.pop(context);
                      _onTabTapped(2);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.camera_enhance_rounded, color: Color(0xFF10B981), size: 20),
                    title: const Text('AI SSI Triage Scanner', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                    onTap: () {
                      Navigator.pop(context);
                      _onTabTapped(3);
                    },
                  ),
                  const Divider(height: 16, color: AppColors.border),
                  ListTile(
                    leading: const Icon(Icons.swap_horiz_rounded, color: Color(0xFF0284C7), size: 20),
                    title: const Text('Switch to Patient Portal', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                    subtitle: const Text('View patient-facing app view', style: TextStyle(fontSize: 10.5, color: AppColors.textMuted)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const PatientShell()),
                      );
                    },
                  ),
                ],
              ),
            ),

            // Sign Out
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  icon: const Icon(Icons.logout_rounded, size: 16, color: Color(0xFFDC2626)),
                  label: const Text('Sign Out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFDC2626),
                    side: const BorderSide(color: Color(0xFFFCA5A5)),
                    minimumSize: const Size(0, 38),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorProfilePlaceholder() {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
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
          child: const SafeArea(
            bottom: false,
            child: Center(
              child: Text(
                'Doctor Profile & Schedule',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 36,
                    backgroundImage: NetworkImage(
                      'https://images.unsplash.com/photo-1537368910025-700350fe46c7?w=400&auto=format&fit=crop&q=80',
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Dr. Salman Haider',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                  ),
                  const Text(
                    'MBBS, FCPS (Surgery), FACS • Shifa International',
                    style: TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 14),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildProfileStat('Experience', '14 Yrs'),
                      _buildProfileStat('Consult Fee', 'PKR 2,500'),
                      _buildProfileStat('Rating', '4.9 ★ (128)'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                icon: const Icon(Icons.logout_rounded, size: 16, color: Color(0xFFDC2626)),
                label: const Text('Switch Role / Sign Out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFDC2626),
                  side: const BorderSide(color: Color(0xFFFCA5A5)),
                  minimumSize: const Size(0, 42),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileStat(String label, String val) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 2),
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
}
