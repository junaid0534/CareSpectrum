import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../login_screen.dart';
import '../records/medical_records_hub_screen.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Confirm Sign Out',
          style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Are you sure you want to log out of your CareSpectrum account?',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogCtx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogCtx);
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text('Sign Out'),
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
          child: const SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Center(
                child: Text(
                  'My Profile',
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
        child: Column(
          children: [
            // 1. Clean Patient Profile Card
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
                children: [
                  Row(
                    children: [
                      // Avatar
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDark],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'J',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),

                      // User Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Junaid',
                              style: TextStyle(
                                fontSize: 16.5,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'patient@carespectrum.com',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Patient ID: #CS-9402',
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

                      // Edit Button
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          size: 19,
                          color: AppColors.primary,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Edit Profile details'),
                              backgroundColor: AppColors.primary,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 20, color: AppColors.border),

                  // 4-Stat Demographics Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildQuickStat('Blood Group', 'B+'),
                      _buildStatDivider(),
                      _buildQuickStat('Age', '24 Yrs'),
                      _buildStatDivider(),
                      _buildQuickStat('Gender', 'Male'),
                      _buildStatDivider(),
                      _buildQuickStat('Weight', '68 kg'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 2. Health & Records Section
            _buildSectionHeader('HEALTH & RECORDS'),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildMenuTile(
                    icon: Icons.folder_shared_outlined,
                    iconBg: const Color(0xFFEFF6FF),
                    iconColor: const Color(0xFF0284C7),
                    title: 'Medical Records & Reports',
                    subtitle: 'Prescriptions, lab tests & surgical notes',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MedicalRecordsHubScreen(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.border),
                  _buildMenuTile(
                    icon: Icons.favorite_border_rounded,
                    iconBg: const Color(0xFFFEF2F2),
                    iconColor: const Color(0xFFEF4444),
                    title: 'My Favorite Doctors',
                    subtitle: 'Quick access to consulted surgeons',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Viewing Favorite Doctors'),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.border),
                  _buildMenuTile(
                    icon: Icons.alarm_rounded,
                    iconBg: const Color(0xFFECFDF5),
                    iconColor: const Color(0xFF10B981),
                    title: 'Health Reminders & Vitals',
                    subtitle: 'Daily medication alerts & vitals log',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Health Reminders schedule'),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 3. Account & Security Section
            _buildSectionHeader('ACCOUNT & SETTINGS'),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildMenuTile(
                    icon: Icons.person_outline_rounded,
                    iconBg: const Color(0xFFF1F5F9),
                    iconColor: AppColors.textPrimary,
                    title: 'Personal Information',
                    subtitle: 'CNIC, mobile number & emergency contact',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.border),
                  _buildMenuTile(
                    icon: Icons.credit_card_rounded,
                    iconBg: const Color(0xFFFFFBEB),
                    iconColor: const Color(0xFFF59E0B),
                    title: 'Saved Payment Methods',
                    subtitle: 'EasyPaisa, JazzCash, Debit Cards',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.border),
                  _buildMenuTile(
                    icon: Icons.lock_outline_rounded,
                    iconBg: const Color(0xFFF8FAFC),
                    iconColor: const Color(0xFF64748B),
                    title: 'Security & Change Password',
                    subtitle: 'Manage login credentials & privacy',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4. Support & Info Section
            _buildSectionHeader('SUPPORT & ABOUT'),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _buildMenuTile(
                    icon: Icons.headset_mic_outlined,
                    iconBg: const Color(0xFFEFF6FF),
                    iconColor: AppColors.primary,
                    title: '24/7 Clinical Help & Support',
                    subtitle: 'CareSpectrum emergency patient helpline',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56, color: AppColors.border),
                  _buildMenuTile(
                    icon: Icons.info_outline_rounded,
                    iconBg: const Color(0xFFF1F5F9),
                    iconColor: AppColors.textMuted,
                    title: 'About CareSpectrum Platform',
                    subtitle: 'Version 1.0.0 • Connected Healthcare',
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 5. Clean Log Out Button
            SizedBox(
              width: double.infinity,
              height: 46,
              child: OutlinedButton.icon(
                onPressed: () => _showLogoutDialog(context),
                icon: const Icon(
                  Icons.logout_rounded,
                  size: 18,
                  color: Color(0xFFEF4444),
                ),
                label: const Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFEF4444),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFFECACA)),
                  backgroundColor: const Color(0xFFFEF2F2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 22,
      color: AppColors.border,
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 19, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}