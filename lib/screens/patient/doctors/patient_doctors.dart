import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../core/mock_data.dart';
import '../../../models/doctor.dart';
import '../booking/appointment_booking_screen.dart';
import 'doctor_profile_screen.dart';

class PatientDoctorsScreen extends StatefulWidget {
  const PatientDoctorsScreen({super.key});

  @override
  State<PatientDoctorsScreen> createState() => _PatientDoctorsScreenState();
}

class _PatientDoctorsScreenState extends State<PatientDoctorsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSpecialty = 'All';
  String _sortBy = 'Recommended'; // 'Recommended', 'Rating', 'Fee'

  final List<String> _specialties = [
    'All',
    'General',
    'Cardiothoracic',
    'Neurosurgery',
    'Orthopedic',
    'Pediatrics',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Doctor> _getFilteredDoctors() {
    final query = _searchController.text.toLowerCase().trim();
    var list = MockData.doctors.where((doc) {
      final matchesQuery = query.isEmpty ||
          doc.name.toLowerCase().contains(query) ||
          doc.specialty.toLowerCase().contains(query) ||
          doc.hospital.toLowerCase().contains(query);

      final matchesSpecialty = _selectedSpecialty == 'All' ||
          doc.specialty.toLowerCase().contains(_selectedSpecialty.toLowerCase());

      return matchesQuery && matchesSpecialty;
    }).toList();

    if (_sortBy == 'Rating') {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (_sortBy == 'Fee') {
      int parseFee(String fee) {
        final digits = fee.replaceAll(RegExp(r'[^0-9]'), '');
        return int.tryParse(digits) ?? 0;
      }

      list.sort((a, b) => parseFee(a.fee).compareTo(parseFee(b.fee)));
    }

    return list;
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

  @override
  Widget build(BuildContext context) {
    final doctors = _getFilteredDoctors();

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
                  'Find Specialists',
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
          // 1. Modern Compact Search Bar (Zero Clipping & Clean Placeholder)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border, width: 1.2),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(
                  fontSize: 13.5,
                  color: AppColors.textPrimary,
                ),
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Search doctors, surgeons...',
                  hintStyle: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  prefixIconConstraints:
                      const BoxConstraints(minWidth: 42, minHeight: 42),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear_rounded,
                            size: 18,
                            color: AppColors.textMuted,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),

          // 2. Specialty Filter Pills (Simple, no card wrapper)
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _specialties.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final spec = _specialties[index];
                final isSelected = _selectedSpecialty == spec;

                return InkWell(
                  onTap: () => setState(() => _selectedSpecialty = spec),
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color:
                            isSelected ? AppColors.primary : AppColors.border,
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
                        spec,
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
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),

          // 3. Results Count & Sort Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${doctors.length} Specialists Available',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  initialValue: _sortBy,
                  onSelected: (val) => setState(() => _sortBy = val),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.sort_rounded,
                          size: 15, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        _sortBy,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down_rounded,
                          size: 18, color: AppColors.primary),
                    ],
                  ),
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'Recommended',
                      child: Text('Recommended', style: TextStyle(fontSize: 12)),
                    ),
                    const PopupMenuItem(
                      value: 'Rating',
                      child: Text('Highest Rating', style: TextStyle(fontSize: 12)),
                    ),
                    const PopupMenuItem(
                      value: 'Fee',
                      child: Text('Lowest Fee', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // 4. Doctor Cards List
          Expanded(
            child: doctors.isEmpty
                ? Center(
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
                              Icons.search_off_rounded,
                              size: 30,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'No Specialists Found',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Try adjusting your search query or specialty filter.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    itemCount: doctors.length,
                    itemBuilder: (context, index) {
                      final doc = doctors[index];
                      return Column(
                        children: [
                          _buildDoctorCard(doc),
                          _buildDottedLine(),
                          const SizedBox(height: 8),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(Doctor doc) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DoctorProfileScreen(doctor: doc),
          ),
        );
      },
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
            // Row 1: Doctor Profile Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with Verified Checkmark
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        doc.imageUrl,
                        width: 54,
                        height: 54,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 54,
                          height: 54,
                          color: AppColors.primaryLight,
                          child: const Icon(Icons.person,
                              color: AppColors.primary, size: 28),
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
                          size: 13,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),

                // Name, Specialty, Hospital
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              doc.name,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          // Rating Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFFBEB),
                              borderRadius: BorderRadius.circular(6),
                              border:
                                  Border.all(color: const Color(0xFFFDE68A)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.star_rounded,
                                    size: 12, color: Color(0xFFF59E0B)),
                                const SizedBox(width: 2.5),
                                Text(
                                  doc.rating.toString(),
                                  style: const TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFB45309),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        doc.specialty,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        doc.hospital,
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
            const SizedBox(height: 10),

            // Row 2: Badges (Experience + Consultation Modes)
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                // Experience Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.workspace_premium_outlined,
                          size: 11, color: AppColors.textSecondary),
                      const SizedBox(width: 3.5),
                      Text(
                        doc.experience,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Video Call Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.videocam_rounded,
                          size: 11, color: Color(0xFF0284C7)),
                      SizedBox(width: 3.5),
                      Text(
                        'Video Call',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0369A1),
                        ),
                      ),
                    ],
                  ),
                ),

                // Hospital Visit Badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_hospital_rounded,
                          size: 11, color: Color(0xFF16A34A)),
                      SizedBox(width: 3.5),
                      Text(
                        'Hospital Visit',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF15803D),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            const Divider(height: 18, color: AppColors.border),

            // Row 3: Fee & Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Consultation Fee',
                      style:
                          TextStyle(fontSize: 10.5, color: AppColors.textMuted),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      doc.fee,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DoctorProfileScreen(doctor: doc),
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        minimumSize: const Size(0, 34),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'View Profile',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AppointmentBookingScreen(doctor: doc),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        minimumSize: const Size(0, 34),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Book Slot',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}