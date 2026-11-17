import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../models/doctor.dart';
import 'booking_details_screen.dart';

class AppointmentBookingScreen extends StatefulWidget {
  final Doctor doctor;
  final String initialMode;

  const AppointmentBookingScreen({
    super.key,
    required this.doctor,
    this.initialMode = 'Teleconsultation',
  });

  @override
  State<AppointmentBookingScreen> createState() =>
      _AppointmentBookingScreenState();
}

class _AppointmentBookingScreenState extends State<AppointmentBookingScreen> {
  late String _consultMode;
  late DateTime _selectedDate;
  String _selectedSlot = '10:15 AM';

  // Next 14 days generated dynamically
  late final List<DateTime> _daysList;

  // 4 slots in 1 row per session
  final Map<String, List<Map<String, dynamic>>> _slotGroups = {
    'Morning Session': [
      {'time': '09:30 AM', 'available': true},
      {'time': '10:15 AM', 'available': true},
      {'time': '11:00 AM', 'available': false},
      {'time': '11:45 AM', 'available': true},
    ],
    'Afternoon Session': [
      {'time': '02:00 PM', 'available': true},
      {'time': '02:45 PM', 'available': true},
      {'time': '03:30 PM', 'available': false},
      {'time': '04:15 PM', 'available': true},
    ],
    'Evening Session': [
      {'time': '05:30 PM', 'available': true},
      {'time': '06:15 PM', 'available': true},
      {'time': '07:00 PM', 'available': true},
      {'time': '07:45 PM', 'available': false},
    ],
  };

  @override
  void initState() {
    super.initState();
    _consultMode = widget.initialMode;
    final now = DateTime.now();
    _daysList = List.generate(14, (i) => now.add(Duration(days: i)));
    _selectedDate = _daysList.first;
  }

  String _getWeekdayName(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    }
    final tomorrow = now.add(const Duration(days: 1));
    if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Tomorrow';
    }
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  String _getMonthAbbr(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }

  String _getMonthFullName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }

  void _navigateToBookingDetails() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingDetailsScreen(
          doctor: widget.doctor,
          consultMode: _consultMode,
          selectedDate: _selectedDate,
          selectedSlot: _selectedSlot,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                        'Select Date & Time',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance leading back button
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==========================================
            // 1. DOCTOR CARD (Name, Spec & Fee on Right - No Subtexts)
            // ==========================================
            _buildDoctorHeaderCard(),
            const SizedBox(height: 16),

            // ==========================================
            // 2. CONSULTATION MODE TOGGLE
            // ==========================================
            _buildConsultationModeToggle(),
            const SizedBox(height: 18),

            // ==========================================
            // 3. HORIZONTAL DATE SELECTOR
            // ==========================================
            _buildDateSelector(),
            const SizedBox(height: 20),

            // ==========================================
            // 4. TIME SLOTS (4 in 1 Row)
            // ==========================================
            _buildSlotsSection(),
            const SizedBox(height: 24),

            // ==========================================
            // 5. CONTINUE BUTTON IN FLOW (No fixed footer)
            // ==========================================
            _buildContinueButton(),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // 1. DOCTOR CARD (Name + Spec only, Fee on Right)
  // ==========================================
  Widget _buildDoctorHeaderCard() {
    final doc = widget.doctor;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Doctor Image with Verified Badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  doc.imageUrl,
                  width: 46,
                  height: 46,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 46,
                    height: 46,
                    color: AppColors.primaryLight,
                    child: const Icon(Icons.person, color: AppColors.primary),
                  ),
                ),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.verified_rounded,
                    color: AppColors.primary,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // Name and Specialty only (no small texts)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc.name,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
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
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Right: Fee Badge (Replacing Rating)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Text(
              doc.fee,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 2. CONSULTATION MODE TOGGLE
  // ==========================================
  Widget _buildConsultationModeToggle() {
    final modes = [
      {
        'label': 'Teleconsultation',
        'icon': Icons.videocam_rounded,
      },
      {
        'label': 'Hospital Visit',
        'icon': Icons.local_hospital_rounded,
      },
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.border.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: modes.map((m) {
          final isSelected = _consultMode == m['label'];
          return Expanded(
            child: InkWell(
              onTap: () {
                setState(() => _consultMode = m['label'] as String);
              },
              borderRadius: BorderRadius.circular(10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.surface : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      m['icon'] as IconData,
                      size: 16,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      m['label'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ==========================================
  // 3. HORIZONTAL DATE SELECTOR
  // ==========================================
  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Select Date',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Row(
              children: [
                const Icon(Icons.calendar_month_rounded,
                    size: 14, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  '${_getMonthFullName(_selectedDate.month)} ${_selectedDate.year}',
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 76,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _daysList.length,
            itemBuilder: (context, index) {
              final date = _daysList[index];
              final isSelected = date.year == _selectedDate.year &&
                  date.month == _selectedDate.month &&
                  date.day == _selectedDate.day;

              return InkWell(
                onTap: () => setState(() => _selectedDate = date),
                borderRadius: BorderRadius.circular(14),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 56,
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                      width: 1.2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.28),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getWeekdayName(date),
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.9)
                              : AppColors.textMuted,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${date.day}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        _getMonthAbbr(date.month),
                        style: TextStyle(
                          fontSize: 9.5,
                          color: isSelected
                              ? Colors.white.withValues(alpha: 0.8)
                              : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 4. TIME SLOTS (4 in 1 Row)
  // ==========================================
  Widget _buildSlotsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Time Slot',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              '30 min per slot',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Session slots with 4 in 1 row grid
        ..._slotGroups.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),

                // 4 IN 1 ROW GRID
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 2.1,
                  ),
                  itemCount: entry.value.length,
                  itemBuilder: (context, idx) {
                    final slot = entry.value[idx];
                    final String time = slot['time'] as String;
                    final bool isAvailable = slot['available'] as bool;
                    final isSelected = _selectedSlot == time && isAvailable;

                    return InkWell(
                      onTap: isAvailable
                          ? () => setState(() => _selectedSlot = time)
                          : null,
                      borderRadius: BorderRadius.circular(10),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : (isAvailable
                                  ? AppColors.surface
                                  : AppColors.border.withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : (isAvailable
                                    ? AppColors.border
                                    : Colors.transparent),
                            width: 1.2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            time,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight:
                                  isSelected ? FontWeight.w700 : FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : (isAvailable
                                      ? AppColors.textPrimary
                                      : AppColors.textMuted),
                              decoration:
                                  isAvailable ? null : TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ==========================================
  // 5. CONTINUE BUTTON IN FLOW (No fixed footer)
  // ==========================================
  Widget _buildContinueButton() {
    final dateStr =
        '${_getWeekdayName(_selectedDate)}, ${_selectedDate.day} ${_getMonthAbbr(_selectedDate.month)}';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selected Slot',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '$dateStr • $_selectedSlot',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Fee',
                    style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.doctor.fee,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _navigateToBookingDetails,
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text(
                'Continue to Patient Details',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
