import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../consultation/doctor_video_consultation_screen.dart';

class DoctorBookingsScreen extends StatefulWidget {
  const DoctorBookingsScreen({super.key});

  @override
  State<DoctorBookingsScreen> createState() => _DoctorBookingsScreenState();
}

class _DoctorBookingsScreenState extends State<DoctorBookingsScreen> {
  int _selectedDayIndex = 0;
  String _activeFilter = 'All'; // 'All', 'Upcoming', 'Teleconsult', 'Completed'
  String _searchQuery = '';
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();

  // Date strip sample days
  final List<Map<String, String>> _days = [
    {'day': 'Today', 'date': '19', 'month': 'Nov', 'count': '6'},
    {'day': 'Fri', 'date': '20', 'month': 'Nov', 'count': '8'},
    {'day': 'Sat', 'date': '21', 'month': 'Nov', 'count': '5'},
    {'day': 'Sun', 'date': '22', 'month': 'Nov', 'count': '2'},
    {'day': 'Mon', 'date': '23', 'month': 'Nov', 'count': '9'},
  ];

  // Sample Doctor Bookings
  final List<Map<String, dynamic>> _bookings = [
    {
      'id': 'BK-101',
      'name': 'Junaid Tariq',
      'ageGender': '24 Y • Male',
      'token': 'Token #03',
      'time': '02:30 PM',
      'type': 'Teleconsult',
      'case': 'Cholecystectomy Post-Op Review',
      'status': 'Upcoming',
      'initials': 'JT',
      'isTeleconsult': true,
    },
    {
      'id': 'BK-102',
      'name': 'Amina Bibi',
      'ageGender': '32 Y • Female',
      'token': 'Token #04',
      'time': '03:15 PM',
      'type': 'Teleconsult',
      'case': 'Appendectomy Incision Check',
      'status': 'Upcoming',
      'initials': 'AB',
      'isTeleconsult': true,
    },
    {
      'id': 'BK-103',
      'name': 'Usman Farooq',
      'ageGender': '45 Y • Male',
      'token': 'Token #05',
      'time': '03:45 PM',
      'type': 'In-Clinic',
      'case': 'Hernia Surgical Follow-up',
      'status': 'Upcoming',
      'initials': 'UF',
      'isTeleconsult': false,
    },
    {
      'id': 'BK-104',
      'name': 'Zainab Fatima',
      'ageGender': '28 Y • Female',
      'token': 'Token #06',
      'time': '04:15 PM',
      'type': 'In-Clinic',
      'case': 'Thyroidectomy Stitch Removal',
      'status': 'Upcoming',
      'initials': 'ZF',
      'isTeleconsult': false,
    },
    {
      'id': 'BK-105',
      'name': 'Bilal Ahmed',
      'ageGender': '38 Y • Male',
      'token': 'Token #01',
      'time': '11:00 AM',
      'type': 'In-Clinic',
      'case': 'Laparoscopy Pre-Op Consultation',
      'status': 'Completed',
      'initials': 'BA',
      'isTeleconsult': false,
    },
    {
      'id': 'BK-106',
      'name': 'Sadia Noor',
      'ageGender': '29 Y • Female',
      'token': 'Token #02',
      'time': '11:30 AM',
      'type': 'Teleconsult',
      'case': 'Wound AI Scan Consultation',
      'status': 'Completed',
      'initials': 'SN',
      'isTeleconsult': true,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredBookings {
    return _bookings.where((b) {
      // 1. Tab Filter
      if (_activeFilter == 'Upcoming' && b['status'] != 'Upcoming') return false;
      if (_activeFilter == 'Completed' && b['status'] != 'Completed') return false;
      if (_activeFilter == 'Teleconsult' && b['isTeleconsult'] != true) return false;

      // 2. Search Query
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final name = (b['name'] as String).toLowerCase();
        final token = (b['token'] as String).toLowerCase();
        final caseTitle = (b['case'] as String).toLowerCase();
        if (!name.contains(q) && !token.contains(q) && !caseTitle.contains(q)) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ==========================================
            // 1. BRAND HEADER (CareSpectrum 48px standard)
            // ==========================================
            _buildHeader(),

            // ==========================================
            // 2. SEARCH BAR (Optional slide-down)
            // ==========================================
            if (_isSearchVisible) _buildSearchBar(),

            // ==========================================
            // 3. HORIZONTAL DAY CALENDAR STRIP
            // ==========================================
            _buildDayStrip(),

            const SizedBox(height: 6),

            // ==========================================
            // 4. FILTER CAPSULE ROW
            // ==========================================
            _buildFilterRow(),

            const SizedBox(height: 8),

            // ==========================================
            // 5. BOOKINGS LIST
            // ==========================================
            Expanded(
              child: _buildBookingsList(),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // 1. HEADER
  // =========================================================================
  Widget _buildHeader() {
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
        children: [
          // Left: Balanced spacing (No drawer on bookings!)
          const SizedBox(width: 32),

          // Title
          const Text(
            'Patient Bookings',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.2,
            ),
          ),

          // Search Toggle Button
          InkWell(
            onTap: () {
              setState(() {
                _isSearchVisible = !_isSearchVisible;
                if (!_isSearchVisible) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _isSearchVisible ? AppColors.primaryLight : AppColors.background,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _isSearchVisible ? AppColors.primary : AppColors.border),
              ),
              child: Icon(
                _isSearchVisible ? Icons.close_rounded : Icons.search_rounded,
                size: 18,
                color: _isSearchVisible ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // 2. SEARCH BAR
  // =========================================================================
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
      color: AppColors.surface,
      child: Container(
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (val) {
            setState(() {
              _searchQuery = val.trim();
            });
          },
          decoration: const InputDecoration(
            hintText: 'Search patient, token, or diagnosis...',
            hintStyle: TextStyle(fontSize: 11.5, color: AppColors.textMuted),
            prefixIcon: Icon(Icons.search, size: 16, color: AppColors.textMuted),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 9),
          ),
        ),
      ),
    );
  }

  // =========================================================================
  // 3. HORIZONTAL DAY STRIP
  // =========================================================================
  Widget _buildDayStrip() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: AppColors.surface,
      child: SizedBox(
        height: 56,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          scrollDirection: Axis.horizontal,
          itemCount: _days.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final day = _days[index];
            final isSelected = _selectedDayIndex == index;

            return InkWell(
              onTap: () {
                setState(() {
                  _selectedDayIndex = index;
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 62,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      day['day']!,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white70 : AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      day['date']!,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: isSelected ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // =========================================================================
  // 4. FILTER CAPSULE ROW
  // =========================================================================
  Widget _buildFilterRow() {
    final filters = ['All', 'Upcoming', 'Teleconsult', 'Completed'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (context, idx) {
          final f = filters[idx];
          final isSelected = _activeFilter == f;

          return InkWell(
            onTap: () {
              setState(() {
                _activeFilter = f;
              });
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Center(
                child: Text(
                  f,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // =========================================================================
  // 5. BOOKINGS LIST
  // =========================================================================
  Widget _buildBookingsList() {
    final list = _filteredBookings;

    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_month_outlined, size: 42, color: AppColors.textMuted.withValues(alpha: 0.6)),
            const SizedBox(height: 8),
            const Text(
              'No bookings found',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: list.length,
      separatorBuilder: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: _buildDottedLine(color: const Color(0xFFCBD5E1), dotWidth: 5, spacing: 3.5),
      ),
      itemBuilder: (context, index) {
        final b = list[index];
        final bool isUpcoming = b['status'] == 'Upcoming';
        final bool isTeleconsult = b['isTeleconsult'] == true;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Token & Status Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          b['token'],
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                        decoration: BoxDecoration(
                          color: isTeleconsult ? const Color(0xFFECFDF5) : AppColors.surface,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isTeleconsult ? Icons.videocam_rounded : Icons.local_hospital_rounded,
                              size: 11,
                              color: isTeleconsult ? const Color(0xFF047857) : AppColors.textSecondary,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              b['type'],
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: isTeleconsult ? const Color(0xFF047857) : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    b['time'],
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Patient Avatar & Info Row
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        b['initials'],
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.primaryDark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          b['name'],
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${b['ageGender']} • ${b['case']}',
                          style: const TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // Actions Row (30px compact buttons)
              Row(
                children: [
                  if (isUpcoming && isTeleconsult) ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DoctorVideoConsultationScreen(
                                patientName: b['name'],
                                patientAgeGender: b['ageGender'],
                                clinicalNote: b['case'],
                                tokenNumber: b['token'],
                                initials: b['initials'],
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.videocam_rounded, size: 13),
                        label: const Text('Start Call'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(0, 30),
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
                  ],

                  if (isUpcoming) ...[
                    OutlinedButton(
                      onPressed: () {
                        setState(() {
                          b['status'] = 'Completed';
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${b['name']} marked as Completed.'),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.surface,
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.border),
                        minimumSize: const Size(0, 30),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      child: const Text('Mark Done ✓'),
                    ),
                    const SizedBox(width: 8),
                  ],

                  // Details / Chart Button
                  OutlinedButton(
                    onPressed: () => _showPatientBriefSheet(b),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: AppColors.surface,
                      foregroundColor: AppColors.textSecondary,
                      side: const BorderSide(color: AppColors.border),
                      minimumSize: const Size(0, 30),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('Details'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================================
  // PATIENT BRIEF SHEET
  // =========================================================================
  void _showPatientBriefSheet(Map<String, dynamic> b) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(18),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 32,
                  height: 3,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    b['name'],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  Text(
                    b['token'],
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${b['ageGender']} • ${b['case']}',
                style: const TextStyle(fontSize: 11.5, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 14),
              const Divider(height: 1, color: AppColors.border),
              const SizedBox(height: 12),
              const Text(
                'Clinical History & Notes',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: const Text(
                  'Patient undergoing routine post-surgical follow-up. No fever reported. Wound AI scanner indicates normal granulation with low SSI risk.',
                  style: TextStyle(fontSize: 11, height: 1.4, color: AppColors.textSecondary),
                ),
              ),
              const SizedBox(height: 14),
            ],
          ),
        );
      },
    );
  }

  // =========================================================================
  // DOTTED LINE WIDGET
  // =========================================================================
  Widget _buildDottedLine({
    Color color = const Color(0xFFCBD5E1),
    double height = 1.0,
    double dotWidth = 4.0,
    double spacing = 3.0,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        if (boxWidth <= 0) return const SizedBox.shrink();
        final count = (boxWidth / (dotWidth + spacing)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(count, (_) {
            return SizedBox(
              width: dotWidth,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
