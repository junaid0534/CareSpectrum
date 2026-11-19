import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../models/medication_reminder_model.dart';

class MedicationReminderScreen extends StatefulWidget {
  const MedicationReminderScreen({super.key});

  @override
  State<MedicationReminderScreen> createState() => _MedicationReminderScreenState();
}

class _MedicationReminderScreenState extends State<MedicationReminderScreen> {
  int _selectedDayIndex = 3; // Defaults to Today (Thursday 19)
  String _selectedFilter = 'All';

  // Sample weekly calendar days
  final List<Map<String, dynamic>> _weekDays = [
    {'day': 'Mon', 'date': '16', 'isPast': true, 'done': true},
    {'day': 'Tue', 'date': '17', 'isPast': true, 'done': true},
    {'day': 'Wed', 'date': '18', 'isPast': true, 'done': true},
    {'day': 'Thu', 'date': '19', 'isToday': true, 'done': false},
    {'day': 'Fri', 'date': '20', 'isFuture': true, 'done': false},
    {'day': 'Sat', 'date': '21', 'isFuture': true, 'done': false},
    {'day': 'Sun', 'date': '22', 'isFuture': true, 'done': false},
  ];

  late List<MedicationReminder> _medications;

  @override
  void initState() {
    super.initState();
    _medications = [
      MedicationReminder(
        id: 'med_1',
        name: 'Augmentin 625mg',
        type: 'Tablet',
        dosage: '1 tab',
        time: '08:00 AM',
        timeOfDay: 'Morning',
        mealInstruction: 'After Food',
        colorValue: 0xFF0284C7, // Blue
        stockLeft: 8,
        totalStock: 14,
        isTaken: true,
        takenTime: '08:12 AM',
      ),
      MedicationReminder(
        id: 'med_2',
        name: 'Cap. Omeprazole 20mg',
        type: 'Capsule',
        dosage: '1 cap',
        time: '08:30 AM',
        timeOfDay: 'Morning',
        mealInstruction: 'Empty Stomach',
        colorValue: 0xFF10B981, // Emerald
        stockLeft: 18,
        totalStock: 30,
        isTaken: true,
        takenTime: '08:35 AM',
      ),
      MedicationReminder(
        id: 'med_3',
        name: 'Tab. Multivitamin + Zinc',
        type: 'Tablet',
        dosage: '1 tab',
        time: '01:30 PM',
        timeOfDay: 'Afternoon',
        mealInstruction: 'After Lunch',
        colorValue: 0xFFF59E0B, // Amber
        stockLeft: 3, // Low stock alert
        totalStock: 30,
        isTaken: true,
        takenTime: '01:45 PM',
      ),
      MedicationReminder(
        id: 'med_4',
        name: 'Panadol Extra 500mg',
        type: 'Tablet',
        dosage: '1 tab',
        time: '09:30 PM',
        timeOfDay: 'Night',
        mealInstruction: 'After Dinner',
        colorValue: 0xFF8B5CF6, // Purple
        stockLeft: 22,
        totalStock: 30,
        isTaken: false,
      ),
    ];
  }

  int get _takenCount => _medications.where((m) => m.isTaken).length;
  int get _totalCount => _medications.length;
  double get _progress => _totalCount == 0 ? 0 : _takenCount / _totalCount;

  List<MedicationReminder> get _filteredMedications {
    if (_selectedFilter == 'All') return _medications;
    return _medications.where((m) => m.timeOfDay == _selectedFilter).toList();
  }

  void _toggleMedication(String id) {
    setState(() {
      final index = _medications.indexWhere((m) => m.id == id);
      if (index != -1) {
        final current = _medications[index];
        final nowTaken = !current.isTaken;
        _medications[index] = current.copyWith(
          isTaken: nowTaken,
          takenTime: nowTaken ? 'Just now' : null,
        );
      }
    });
  }

  void _showAddMedicationSheet() {
    final nameCtrl = TextEditingController();
    final dosageCtrl = TextEditingController(text: '1 tablet');
    String selectedPeriod = 'Morning';
    String selectedMeal = 'After Food';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.fromLTRB(
            20,
            16,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Row(
                children: [
                  Icon(Icons.add_circle_outline_rounded,
                      size: 20, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Add Medication Reminder',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Name Field
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Medicine Name',
                  hintText: 'e.g., Panadol 500mg',
                  prefixIcon: const Icon(Icons.medication_outlined, size: 20),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Dosage
              TextField(
                controller: dosageCtrl,
                decoration: InputDecoration(
                  labelText: 'Dosage',
                  hintText: '1 tablet / 5ml',
                  prefixIcon: const Icon(Icons.scale_outlined, size: 20),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Timing Pill Selector
              const Text(
                'TIME OF DAY',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: ['Morning', 'Afternoon', 'Evening', 'Night'].map((period) {
                  final isSel = selectedPeriod == period;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: InkWell(
                        onTap: () => setModalState(() => selectedPeriod = period),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSel ? AppColors.primary : AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSel ? AppColors.primary : AppColors.border,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              period,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isSel ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 14),

              // Meal Relation
              const Text(
                'MEAL INSTRUCTION',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: ['After Food', 'Before Food', 'Empty Stomach'].map((meal) {
                  final isSel = selectedMeal == meal;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: InkWell(
                        onTap: () => setModalState(() => selectedMeal = meal),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSel ? const Color(0xFFEFF6FF) : AppColors.background,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSel ? AppColors.primary : AppColors.border,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              meal,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: isSel ? AppColors.primary : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 18),

              // Save Button
              ElevatedButton(
                onPressed: () {
                  final name = nameCtrl.text.trim();
                  if (name.isEmpty) return;

                  final String defaultTime;
                  switch (selectedPeriod) {
                    case 'Morning':
                      defaultTime = '08:00 AM';
                      break;
                    case 'Afternoon':
                      defaultTime = '01:30 PM';
                      break;
                    case 'Evening':
                      defaultTime = '06:00 PM';
                      break;
                    default:
                      defaultTime = '09:30 PM';
                  }

                  setState(() {
                    _medications.add(
                      MedicationReminder(
                        id: 'med_${DateTime.now().millisecondsSinceEpoch}',
                        name: name,
                        type: 'Tablet',
                        dosage: dosageCtrl.text.trim().isEmpty ? '1 tab' : dosageCtrl.text.trim(),
                        time: defaultTime,
                        timeOfDay: selectedPeriod,
                        mealInstruction: selectedMeal,
                        colorValue: 0xFF0284C7,
                        stockLeft: 14,
                        totalStock: 30,
                        isTaken: false,
                      ),
                    );
                  });

                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Set Reminder',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
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
                        'Medication Reminder',
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
                      Icons.add_rounded,
                      size: 22,
                      color: AppColors.primary,
                    ),
                    onPressed: _showAddMedicationSheet,
                    tooltip: 'Add',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Horizontal Weekly Calendar Strip
            _buildWeekCalendarStrip(),

            const SizedBox(height: 12),

            // 2. Daily Adherence Progress Hero Card
            _buildAdherenceCard(),

            const SizedBox(height: 14),

            // 3. Time Filter Chips
            _buildFilterRow(),

            const SizedBox(height: 10),

            // 4. Medications List
            if (_filteredMedications.isEmpty)
              _buildEmptyState()
            else
              ..._filteredMedications.map((med) => _buildMedicationCard(med)),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekCalendarStrip() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_weekDays.length, (index) {
          final item = _weekDays[index];
          final isSelected = _selectedDayIndex == index;
          final isToday = item['isToday'] == true;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => _selectedDayIndex = index);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 2),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      item['day'],
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : (isToday ? AppColors.primary : AppColors.textMuted),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['date'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: isSelected
                            ? Colors.white
                            : (isToday ? AppColors.primary : AppColors.textPrimary),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? Colors.white
                            : (item['done'] == true
                                ? const Color(0xFF10B981)
                                : Colors.transparent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAdherenceCard() {
    final percent = (_progress * 100).toInt();

    return Container(
      padding: const EdgeInsets.all(14),
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
          // Circular Progress Gauge
          SizedBox(
            width: 54,
            height: 54,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: _progress,
                  strokeWidth: 5.5,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    percent == 100 ? const Color(0xFF10B981) : AppColors.primary,
                  ),
                ),
                Center(
                  child: Text(
                    '$percent%',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),

          // Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$_takenCount of $_totalCount Taken',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.local_fire_department_rounded,
                              size: 11, color: Color(0xFFD97706)),
                          SizedBox(width: 3),
                          Text(
                            '6d Streak',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFFB45309),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _takenCount == _totalCount
                      ? 'All done for today! 🎉'
                      : 'Next: Panadol Extra at 09:30 PM',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: _takenCount == _totalCount
                        ? const Color(0xFF047857)
                        : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow() {
    final filters = ['All', 'Morning', 'Afternoon', 'Night'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((f) {
          final isSel = _selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: ChoiceChip(
              label: Text(f),
              selected: isSel,
              onSelected: (_) => setState(() => _selectedFilter = f),
              selectedColor: AppColors.primary,
              backgroundColor: AppColors.surface,
              labelStyle: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isSel ? Colors.white : AppColors.textSecondary,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(
                  color: isSel ? AppColors.primary : AppColors.border,
                ),
              ),
              showCheckmark: false,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMedicationCard(MedicationReminder med) {
    final isLowStock = med.stockLeft <= 5;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: med.isTaken ? const Color(0xFFD1FAE5) : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon Pill
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Color(med.colorValue).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              med.type == 'Capsule'
                  ? Icons.medication_liquid_rounded
                  : Icons.medication_rounded,
              color: Color(med.colorValue),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Med Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        med.name,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isLowStock && !med.isTaken)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${med.stockLeft} left',
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFDC2626),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),

                // Subtitle Row: Time • Meal • Dosage
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded,
                        size: 11, color: AppColors.textMuted),
                    const SizedBox(width: 3),
                    Text(
                      med.time,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('•',
                        style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        med.mealInstruction,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Text('•',
                        style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                    const SizedBox(width: 6),
                    Text(
                      med.dosage,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Action Button: Take / Taken
          InkWell(
            onTap: () => _toggleMedication(med.id),
            borderRadius: BorderRadius.circular(20),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: med.isTaken
                    ? const Color(0xFFECFDF5)
                    : AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: med.isTaken
                      ? const Color(0xFF10B981)
                      : AppColors.primary,
                  width: 1.2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    med.isTaken
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    size: 13,
                    color: med.isTaken
                        ? const Color(0xFF10B981)
                        : AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    med.isTaken ? 'Taken' : 'Take',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: med.isTaken
                          ? const Color(0xFF047857)
                          : AppColors.primary,
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

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(28),
      alignment: Alignment.center,
      child: const Column(
        children: [
          Icon(Icons.done_all_rounded, size: 40, color: AppColors.textMuted),
          SizedBox(height: 8),
          Text(
            'No medicines scheduled',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
