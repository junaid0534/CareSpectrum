import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/mock_data.dart';
import '../../../models/doctor.dart';
import '../../../models/appointment.dart';
import '../doctors/doctor_profile_screen.dart';
import '../notifications/notifications_screen.dart';

class PatientHomeScreen extends StatefulWidget {
  final Function(int) onTabChange;
  final VoidCallback onOpenDrawer;

  const PatientHomeScreen({
    super.key,
    required this.onTabChange,
    required this.onOpenDrawer,
  });

  @override
  State<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _bannerController = PageController();
  int _currentBannerPage = 0;
  Timer? _bannerTimer;

  // Top 8 Specialties & Surgeons (2 rows of 4, inspired by NexaCare)
  final List<Map<String, dynamic>> _specialties = [
    {
      'name': 'General',
      'icon': '🩺',
      'color': 0xFFEFF6FF,
      'border': 0xFFBFDBFE,
    },
    {
      'name': 'Cardiology',
      'icon': '❤️',
      'color': 0xFFFFF1F2,
      'border': 0xFFFECDD3,
    },
    {
      'name': 'Neurology',
      'icon': '🧠',
      'color': 0xFFF5F3FF,
      'border': 0xFFDDD6FE,
    },
    {
      'name': 'Orthopedic',
      'icon': '🦴',
      'color': 0xFFFDF4FF,
      'border': 0xFFE9D5FF,
    },
    {
      'name': 'Pediatrics',
      'icon': '👶',
      'color': 0xFFF0FDF4,
      'border': 0xFFBBF7D0,
    },
    {
      'name': 'Pulmonology',
      'icon': '🫁',
      'color': 0xFFF0F9FF,
      'border': 0xFFBAE6FD,
    },
    {
      'name': 'Urology',
      'icon': '🔬',
      'color': 0xFFFFFBEB,
      'border': 0xFFFDE68A,
    },
    {
      'name': 'ENT',
      'icon': '👂',
      'color': 0xFFFFF7ED,
      'border': 0xFFFED7AA,
    },
  ];

  // Clinical Health Tips (inspired by NexaCare health tips)
  final List<Map<String, dynamic>> _healthTips = [
    {
      'title': 'Stay Hydrated',
      'body': 'Drink at least 8 glasses of water daily for optimal circulation & surgical recovery.',
      'icon': '💧',
      'color': 0xFFEFF6FF,
      'border': 0xFFBFDBFE,
    },
    {
      'title': 'Restful Sleep',
      'body': '7–9 hours of deep sleep accelerates post-procedure cellular tissue healing.',
      'icon': '🌙',
      'color': 0xFFF0FDFA,
      'border': 0xFF99F6E4,
    },
    {
      'title': 'Pre-Op Fasting',
      'body': 'Avoid solid foods for 8 hours prior to surgical procedures as advised by surgeons.',
      'icon': '🥗',
      'color': 0xFFFFFBEB,
      'border': 0xFFFDE68A,
    },
    {
      'title': 'Vital Tracking',
      'body': 'Log temperature and blood pressure daily to detect early post-op warnings.',
      'icon': '🩺',
      'color': 0xFFFDF4FF,
      'border': 0xFFE9D5FF,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startBannerAutoSlider();
  }

  void _startBannerAutoSlider() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_bannerController.hasClients) {
        final nextPage = (_currentBannerPage + 1) % 3;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Appointment? upcomingAppt;
    try {
      upcomingAppt = MockData.appointments.firstWhere(
        (a) => a.status == 'Upcoming',
      );
    } catch (_) {
      upcomingAppt = null;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // COMPACT TOP HEADER (Drawer, Centered Brand, Notification)
            // ==========================================
            _buildTopHeader(),

            // SCROLLABLE CONTENT
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==========================================
                    // 1. SEARCH BAR (Compact Height)
                    // ==========================================
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                      child: _buildSearchBar(),
                    ),

                    // ==========================================
                    // 2. UPCOMING APPOINTMENT & PROMO 5-SEC SLIDER
                    // ==========================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildUpcomingAndPromoSlider(upcomingAppt),
                    ),
                    const SizedBox(height: 20),

                    // ==========================================
                    // 3. SPECIALISTS & SURGEONS (Top 8, 4 in 1 Row)
                    // ==========================================
                    _buildSpecialistsSection(),
                    const SizedBox(height: 20),

                    // ==========================================
                    // 4. MY FAVORITE DOCTORS (Horizontal Carousel)
                    // ==========================================
                    _buildFavoriteDoctorsSection(),
                    const SizedBox(height: 20),

                    // ==========================================
                    // 5. MY HEALTH VITALS (Heart Rate, BP, SpO2)
                    // ==========================================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildHealthVitalsSection(),
                    ),
                    const SizedBox(height: 20),

                    // ==========================================
                    // 6. CLINICAL HEALTH TIPS (Pastel Cards)
                    // ==========================================
                    _buildHealthTipsSection(),
                    const SizedBox(height: 32),
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
  // TOP HEADER WIDGET
  // ==========================================
  Widget _buildTopHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
          // Left: Drawer Menu Button
          InkWell(
            onTap: widget.onOpenDrawer,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(
                Icons.notes_rounded,
                size: 20,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Center: Brand Title "Care Spectrum" (Black & Brand Blue, no extra texts)
          const Expanded(
            child: Center(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Care',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    TextSpan(
                      text: 'Spectrum',
                      style: TextStyle(
                        fontSize: 20,
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

          // Right: Notification Bell with Badge (Navigates to Notifications Center)
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationsScreen(),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(
                    Icons.notifications_none_rounded,
                    size: 20,
                    color: AppColors.textPrimary,
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
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
  // 1. SEARCH BAR (Improved Height, No Double Line, No Dots)
  // ==========================================
  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1.2),
      ),
      child: TextField(
        controller: _searchController,
        style: const TextStyle(fontSize: 13.5, color: AppColors.textPrimary),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search doctors, specialties, surgeons',
          hintStyle: const TextStyle(fontSize: 13, color: AppColors.textMuted),
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 20,
            color: AppColors.textMuted,
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 42, minHeight: 42),
          suffixIcon: Container(
            margin: const EdgeInsets.all(6),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.tune_rounded,
              size: 16,
              color: AppColors.primary,
            ),
          ),
          suffixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          errorBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        ),
      ),
    );
  }

  // ==========================================
  // 2. UPCOMING APPOINTMENT & PROMO 5-SEC SLIDER
  // ==========================================
  Widget _buildUpcomingAndPromoSlider(Appointment? upcomingAppt) {
    return Column(
      children: [
        SizedBox(
          height: 128,
          child: PageView(
            controller: _bannerController,
            onPageChanged: (idx) {
              setState(() => _currentBannerPage = idx);
            },
            children: [
              // Slide 1: Upcoming Appointment Card (or Empty State)
              _buildUpcomingSlide(upcomingAppt),

              // Slide 2: Promo 30% OFF Teleconsult
              _buildPromoSlide(
                tag: 'PROMO OFFER',
                title: '30% OFF Teleconsult',
                subtitle: 'Use code CARE30 on your first surgical or specialist consult.',
                badge: 'CARE30',
                colors: const [Color(0xFF0F766E), Color(0xFF0284C7)],
                icon: Icons.local_offer_rounded,
              ),

              // Slide 3: 24/7 Surgical Advisory
              _buildPromoSlide(
                tag: 'SURGICAL ADVISORY',
                title: '24/7 Surgical Second Opinion',
                subtitle: 'Board-certified chief surgeons available for instant pre-op review.',
                badge: '24/7 ACTIVE',
                colors: const [Color(0xFF1E293B), Color(0xFF0369A1)],
                icon: Icons.health_and_safety_rounded,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // 3-Dot Indicator Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) {
            final isActive = _currentBannerPage == index;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: isActive ? 16 : 6,
              height: 5,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildUpcomingSlide(Appointment? appt) {
    if (appt == null) {
      return InkWell(
        onTap: () => widget.onTabChange(2), // Switch to Doctors tab
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'No Upcoming Appointments',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Tap to schedule a consultation with verified doctors.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.85),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white70,
                size: 14,
              ),
            ],
          ),
        ),
      );
    }

    // Active Upcoming Appointment (Clickable entire card, no action buttons)
    return InkWell(
      onTap: () => widget.onTabChange(1), // Switch to Appointments tab
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0369A1), Color(0xFF0284C7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.28),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Status & Fee Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Upcoming ${appt.type}',
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      appt.fee,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white70,
                      size: 12,
                    ),
                  ],
                ),
              ],
            ),

            // Middle Doctor Info Row
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Icon(
                    Icons.medical_services_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appt.doctorName,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 1),
                      Text(
                        appt.specialty,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Bottom Date & Time Strip
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.calendar_today_rounded,
                    size: 12,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    appt.date,
                    style: const TextStyle(fontSize: 11, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  const Icon(
                    Icons.access_time_rounded,
                    size: 12,
                    color: Colors.white70,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    appt.time,
                    style: const TextStyle(fontSize: 11, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoSlide({
    required String tag,
    required String title,
    required String subtitle,
    required String badge,
    required List<Color> colors,
    required IconData icon,
  }) {
    return InkWell(
      onTap: () => widget.onTabChange(2), // Switch to Doctors tab
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(alpha: 0.28),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.88),
                          height: 1.25,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.white, size: 20),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 3. SPECIALISTS & SURGEONS (Top 8, 4 in 1 Row)
  // ==========================================
  Widget _buildSpecialistsSection() {
    final row1 = _specialties.take(4).toList();
    final row2 = _specialties.skip(4).take(4).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Specialists & Surgeons',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              InkWell(
                onTap: () => widget.onTabChange(2), // Switch to Doctors tab
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Row 1 (4 items)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: row1.map((cat) => _buildCategoryItem(cat)).toList(),
          ),
          const SizedBox(height: 12),

          // Row 2 (4 items)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: row2.map((cat) => _buildCategoryItem(cat)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(Map<String, dynamic> cat) {
    return InkWell(
      onTap: () {
        widget.onTabChange(2); // Switch to Doctors tab
      },
      borderRadius: BorderRadius.circular(18),
      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Color(cat['color'] as int),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Color(cat['border'] as int),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                cat['icon'] as String,
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 66,
            child: Text(
              cat['name'] as String,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 4. MY FAVORITE DOCTORS (Horizontal Carousel)
  // ==========================================
  Widget _buildFavoriteDoctorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'My Favorite Doctors',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              InkWell(
                onTap: () => widget.onTabChange(2),
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 190,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: MockData.doctors.length,
            itemBuilder: (context, index) {
              final doc = MockData.doctors[index];
              return _buildFavoriteDoctorCard(doc);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteDoctorCard(Doctor doc) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DoctorProfileScreen(doctor: doc),
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 172,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Doctor Image + Heart & Rating
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    doc.imageUrl,
                    width: 44,
                    height: 44,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 44,
                      height: 44,
                      color: AppColors.primaryLight,
                      child: const Icon(Icons.person, color: AppColors.primary),
                    ),
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Favorite Heart
                    const Icon(
                      Icons.favorite_rounded,
                      size: 18,
                      color: Color(0xFFEF4444),
                    ),
                    const SizedBox(height: 4),
                    // Rating Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 11,
                            color: Color(0xFFF59E0B),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            doc.rating.toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFB45309),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Name
            Text(
              doc.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),

            // Specialty
            Text(
              doc.specialty,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
            ),
            const Spacer(),

            // Fee & Book Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  doc.fee,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DoctorProfileScreen(doctor: doc),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Book',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 5. MY HEALTH VITALS (FittedBox Scaling)
  // ==========================================
  Widget _buildHealthVitalsSection() {
    final vitals = [
      {
        'title': 'Heart Rate',
        'value': '74',
        'unit': 'bpm',
        'icon': Icons.favorite_rounded,
        'color': const Color(0xFFEF4444),
      },
      {
        'title': 'Blood Pressure',
        'value': '120/80',
        'unit': 'mmHg',
        'icon': Icons.speed_rounded,
        'color': AppColors.primary,
      },
      {
        'title': 'Oxygen (SpO2)',
        'value': '98',
        'unit': '%',
        'icon': Icons.water_drop_rounded,
        'color': const Color(0xFF06B6D4),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Health Vitals',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            InkWell(
              onTap: () => widget.onTabChange(3), // Switch to Records tab
              child: const Text(
                'View All',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: vitals.map((v) {
            return Expanded(
              child: InkWell(
                onTap: () => widget.onTabChange(3), // Switch to Records tab
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(v['icon'] as IconData, size: 18, color: v['color'] as Color),
                      const SizedBox(height: 8),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              v['value'] as String,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              v['unit'] as String,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        v['title'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ==========================================
  // 6. CLINICAL HEALTH TIPS (Pastel Cards)
  // ==========================================
  Widget _buildHealthTipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Clinical Health Tips',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 114,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _healthTips.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final tip = _healthTips[index];
              return Container(
                width: 220,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Color(tip['color'] as int),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: Color(tip['border'] as int),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          tip['icon'] as String,
                          style: const TextStyle(fontSize: 18),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            tip['title'] as String,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      tip['body'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
