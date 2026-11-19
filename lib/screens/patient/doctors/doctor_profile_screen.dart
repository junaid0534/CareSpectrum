import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../models/doctor.dart';
import '../booking/appointment_booking_screen.dart';

class DoctorProfileScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorProfileScreen({
    super.key,
    required this.doctor,
  });

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  bool _isFavorite = true;
  int _selectedDayIndex = 0;
  int _selectedSlotIndex = 1;
  String _selectedConsultType = 'Teleconsultation';

  final List<String> _availableDays = [
    'Today',
    'Tomorrow',
    'Mon, 17 Nov',
    'Tue, 18 Nov',
    'Wed, 19 Nov',
  ];

  final List<String> _availableSlots = [
    '10:30 AM',
    '02:00 PM',
    '04:30 PM',
    '06:15 PM',
  ];

  // Areas of expertise according to specialty
  List<String> _getExpertiseList(String specialty) {
    if (specialty.toLowerCase().contains('cardio')) {
      return [
        'Coronary Artery Bypass',
        'Heart Valve Repair',
        'Cardiac Catheterization',
        'Pre-Op Cardiac Triage',
        'Post-Surgical Rehab',
      ];
    } else if (specialty.toLowerCase().contains('neuro')) {
      return [
        'Cranial Microsurgery',
        'Spinal Cord Decompression',
        'Cerebrovascular Care',
        'Neuro-Endoscopy',
        'Post-Op Neuro Tracking',
      ];
    } else if (specialty.toLowerCase().contains('ortho')) {
      return [
        'Joint Replacement',
        'Arthroscopic Surgery',
        'Spine Alignment',
        'Fracture Reconstruction',
        'Sports Injury Trauma',
      ];
    } else if (specialty.toLowerCase().contains('pediatric')) {
      return [
        'Pediatric Surgery',
        'Neonatal Critical Care',
        'Congenital Anomalies',
        'Child Nutrition & Growth',
        'Post-Op Pediatric Monitoring',
      ];
    } else {
      return [
        'Laparoscopic Procedures',
        'Abdominal Surgery',
        'Pre-Operative Assessment',
        'Tele-Surgical Advisory',
        'Emergency Surgical Triage',
      ];
    }
  }

  // Patient reviews for this doctor
  List<Map<String, dynamic>> _getReviews(Doctor doc) {
    return [
      {
        'patient': 'Muhammad Bilal',
        'rating': 5.0,
        'date': 'Yesterday',
        'comment':
            '${doc.name} explained the pre-surgery procedure with great detail and empathy. Highly recommended!',
      },
      {
        'patient': 'Zainab Fatima',
        'rating': 5.0,
        'date': '3 days ago',
        'comment':
            'Excellent teleconsultation experience. Dr. joined promptly on video and gave very clear prescriptions.',
      },
      {
        'patient': 'Hamza Tariq',
        'rating': 4.8,
        'date': '1 week ago',
        'comment':
            'Very knowledgeable surgeon. Answered all post-operative recovery questions patiently.',
      },
    ];
  }



  @override
  Widget build(BuildContext context) {
    final doc = widget.doctor;
    final expertise = _getExpertiseList(doc.specialty);
    final reviews = _getReviews(doc);

    return Scaffold(
      backgroundColor: AppColors.background,
      // ==========================================
      // COMPACT ROUNDED APPBAR HEADER
      // ==========================================
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
                        'Doctor Profile',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      color: _isFavorite ? const Color(0xFFEF4444) : AppColors.textSecondary,
                      size: 21,
                    ),
                    onPressed: () {
                      setState(() => _isFavorite = !_isFavorite);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _isFavorite
                                ? '${doc.name} added to your favorites.'
                                : '${doc.name} removed from your favorites.',
                          ),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 1. DOCTOR MAIN HEADER CARD
            // ==========================================
            _buildMainInfoCard(doc),
            const SizedBox(height: 16),

            // ==========================================
            // 2. 4 METRICS TILES (Experience, Fee, Rating, Patients)
            // ==========================================
            _buildMetricsGrid(doc),
            const SizedBox(height: 20),

            // ==========================================
            // 3. CONSULTATION TYPE SELECTION (Centered Icons, Fee, Auto-Navigate)
            // ==========================================
            _buildConsultationTypeSelector(doc),
            const SizedBox(height: 20),

            // ==========================================
            // 4. BIOGRAPHY & ABOUT SECTION
            // ==========================================
            _buildAboutSection(doc),
            const SizedBox(height: 20),

            // ==========================================
            // 5. AREAS OF EXPERTISE (Lighter w500 Fonts)
            // ==========================================
            _buildExpertiseSection(expertise),
            const SizedBox(height: 20),

            // ==========================================
            // 6. CERTIFICATION BADGE (PMDC / CPSP)
            // ==========================================
            _buildCertificationBadge(),
            const SizedBox(height: 20),

            // ==========================================
            // 7. UPCOMING AVAILABILITY & SLOTS
            // ==========================================
            _buildScheduleSection(),
            const SizedBox(height: 20),

            // ==========================================
            // 8. PATIENT REVIEWS & RATINGS
            // ==========================================
            _buildReviewsSection(reviews, doc),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 1. DOCTOR MAIN HEADER CARD
  // ==========================================
  Widget _buildMainInfoCard(Doctor doc) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor Image with Verified Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  doc.imageUrl,
                  width: 86,
                  height: 86,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 86,
                    height: 86,
                    color: AppColors.primaryLight,
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -4,
                right: -4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),

          // Doctor Text Meta
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.name,
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    doc.specialty,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.apartment_rounded,
                      size: 14,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        doc.hospital,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.textMuted,
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'Clinic Suite 4B · Tele & In-Person',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 2. 4 METRICS TILES
  // ==========================================
  Widget _buildMetricsGrid(Doctor doc) {
    return Row(
      children: [
        _buildMetricItem(
          icon: Icons.work_outline_rounded,
          value: doc.experience,
          label: 'Experience',
          color: const Color(0xFF0284C7),
          bg: const Color(0xFFEFF6FF),
        ),
        const SizedBox(width: 8),
        _buildMetricItem(
          icon: Icons.payments_outlined,
          value: doc.fee,
          label: 'Consult Fee',
          color: const Color(0xFF10B981),
          bg: const Color(0xFFECFDF5),
        ),
        const SizedBox(width: 8),
        _buildMetricItem(
          icon: Icons.star_rounded,
          value: doc.rating.toString(),
          label: 'Rating',
          color: const Color(0xFFF59E0B),
          bg: const Color(0xFFFFFBEB),
        ),
        const SizedBox(width: 8),
        _buildMetricItem(
          icon: Icons.people_outline_rounded,
          value: '${doc.reviews}+',
          label: 'Patients',
          color: const Color(0xFF8B5CF6),
          bg: const Color(0xFFF5F3FF),
        ),
      ],
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required Color bg,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: bg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: AppColors.textMuted,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 3. CONSULTATION TYPE SELECTOR (Centered Icons, Fee, Auto-Navigate)
  // ==========================================
  Widget _buildConsultationTypeSelector(Doctor doc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Consultation Mode to Book',
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Teleconsultation (Video Call Icon)
            Expanded(
              child: _buildConsultModeTile(
                title: 'Teleconsultation',
                fee: doc.fee,
                icon: Icons.videocam_rounded,
                type: 'Teleconsultation',
                iconColor: const Color(0xFF0284C7),
                iconBg: const Color(0xFFEFF6FF),
              ),
            ),
            const SizedBox(width: 10),
            // Hospital Visit (Hospital Icon)
            Expanded(
              child: _buildConsultModeTile(
                title: 'Hospital Visit',
                fee: doc.fee,
                icon: Icons.local_hospital_rounded,
                type: 'Hospital Visit',
                iconColor: const Color(0xFF10B981),
                iconBg: const Color(0xFFECFDF5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConsultModeTile({
    required String title,
    required String fee,
    required IconData icon,
    required String type,
    required Color iconColor,
    required Color iconBg,
  }) {
    final isSelected = _selectedConsultType == type;
    return InkWell(
      onTap: () {
        setState(() => _selectedConsultType = type);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AppointmentBookingScreen(
              doctor: widget.doctor,
              initialMode: type,
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Centered icon container (compact)
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 18,
                  color: iconColor,
                ),
              ),
            ),
            const SizedBox(height: 6),

            // Centered Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),

            // Centered Fee Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : AppColors.background,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                fee,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 4. BIOGRAPHY & ABOUT SECTION
  // ==========================================
  Widget _buildAboutSection(Doctor doc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'About Doctor',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            '${doc.name} is a senior consultant in ${doc.specialty} with over ${doc.experience} of dedicated clinical practice. Attached with ${doc.hospital}, they specialize in patient-centric surgical triage, pre-operative evaluations, and advanced laparoscopic & clinical procedures. Providing secure encrypted teleconsultations and priority hospital appointments.',
            style: const TextStyle(
              fontSize: 12.5,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 5. AREAS OF EXPERTISE (Lighter w500 Fonts)
  // ==========================================
  Widget _buildExpertiseSection(List<String> expertise) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Clinical Specializations',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: expertise.map((item) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500, // Balanced, not overly bold
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ==========================================
  // 6. CERTIFICATION BADGE
  // ==========================================
  Widget _buildCertificationBadge() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.military_tech_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PMDC & CPSP Certified Specialist',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Licensed medical registration verified for CareSpectrum.',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.verified_user_rounded,
            color: AppColors.primary,
            size: 20,
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 7. UPCOMING AVAILABILITY & SLOTS
  // ==========================================
  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Schedule Slot',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),

        // Day Chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: List.generate(_availableDays.length, (idx) {
              final isSel = _selectedDayIndex == idx;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(_availableDays[idx]),
                  selected: isSel,
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                    color: isSel ? Colors.white : AppColors.textSecondary,
                  ),
                  side: BorderSide(
                    color: isSel ? AppColors.primary : AppColors.border,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onSelected: (_) => setState(() => _selectedDayIndex = idx),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 10),

        // Time Chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(_availableSlots.length, (idx) {
            final isSel = _selectedSlotIndex == idx;
            return InkWell(
              onTap: () {
                setState(() => _selectedSlotIndex = idx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AppointmentBookingScreen(
                      doctor: widget.doctor,
                      initialMode: _selectedConsultType,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSel ? AppColors.primaryLight : AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSel ? AppColors.primary : AppColors.border,
                    width: isSel ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 13,
                      color: isSel ? AppColors.primaryDark : AppColors.textMuted,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _availableSlots[idx],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                        color: isSel ? AppColors.primaryDark : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  // ==========================================
  // 8. PATIENT REVIEWS & RATINGS
  // ==========================================
  Widget _buildReviewsSection(List<Map<String, dynamic>> reviews, Doctor doc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Patient Reviews',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: Color(0xFFF59E0B), size: 16),
                const SizedBox(width: 3),
                Text(
                  '${doc.rating} (${doc.reviews} reviews)',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Anti-Fake Review Verification Banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFFECFDF5),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFA7F3D0)),
          ),
          child: const Row(
            children: [
              Icon(Icons.verified_user_rounded, size: 14, color: Color(0xFF059669)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Anti-Fraud Verification: Reviews are restricted to patients with a completed booking.',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF047857),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: reviews.map((r) {
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            r['patient'] as String,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFECFDF5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check, size: 10, color: Color(0xFF10B981)),
                                SizedBox(width: 2),
                                Text(
                                  'Verified',
                                  style: TextStyle(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF047857),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Text(
                        r['date'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: List.generate(5, (starIdx) {
                      return const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: Color(0xFFF59E0B),
                      );
                    }),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    r['comment'] as String,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: AppColors.textSecondary,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
