import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/doctor.dart';
import 'booking_payment_screen.dart';

class BookingDetailsScreen extends StatefulWidget {
  final Doctor doctor;
  final String consultMode;
  final DateTime selectedDate;
  final String selectedSlot;

  const BookingDetailsScreen({
    super.key,
    required this.doctor,
    required this.consultMode,
    required this.selectedDate,
    required this.selectedSlot,
  });

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  bool _isForSelf = true;
  final TextEditingController _nameController =
      TextEditingController(text: 'Muhammad Junaid');
  final TextEditingController _ageController =
      TextEditingController(text: '25');
  final TextEditingController _cnicController =
      TextEditingController(text: '35201-4920145-3');
  final TextEditingController _phoneController =
      TextEditingController(text: '+92 301 4025346');
  final TextEditingController _reasonController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _cnicController.dispose();
    _phoneController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  String _getWeekdayName(DateTime date) {
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

  void _proceedToPayment() {
    final name = _nameController.text.trim();
    final age = _ageController.text.trim();
    final cnic = _cnicController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty || age.isEmpty || cnic.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields marked with *'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingPaymentScreen(
          doctor: widget.doctor,
          consultMode: widget.consultMode,
          selectedDate: widget.selectedDate,
          selectedSlot: widget.selectedSlot,
          patientName: name,
          patientAge: age,
          patientCnic: cnic,
          patientPhone: phone,
          reasonForVisit: _reasonController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${_getWeekdayName(widget.selectedDate)}, ${widget.selectedDate.day} ${_getMonthAbbr(widget.selectedDate.month)}';

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
                        'Patient Details',
                        style: TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
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
            // 1. APPOINTMENT SUMMARY MINI CARD
            // ==========================================
            Container(
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
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.doctor.imageUrl,
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
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.doctor.name,
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.doctor.specialty,
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.doctor.fee,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 18, color: AppColors.border),
                  Row(
                    children: [
                      Icon(
                        widget.consultMode.contains('Tele')
                            ? Icons.videocam_rounded
                            : Icons.local_hospital_rounded,
                        size: 15,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.consultMode,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.calendar_today_rounded,
                          size: 13, color: AppColors.textMuted),
                      const SizedBox(width: 5),
                      Text(
                        '$dateStr • ${widget.selectedSlot}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ==========================================
            // 2. FOR MYSELF VS FAMILY TOGGLE
            // ==========================================
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isForSelf = true;
                        _nameController.text = 'Muhammad Junaid';
                        _ageController.text = '25';
                        _cnicController.text = '35201-4920145-3';
                        _phoneController.text = '+92 301 4025346';
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: _isForSelf ? AppColors.primaryLight : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isForSelf ? AppColors.primary : AppColors.border,
                          width: _isForSelf ? 1.4 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Myself (Junaid)',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: _isForSelf
                                ? AppColors.primaryDark
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _isForSelf = false;
                        _nameController.clear();
                        _ageController.clear();
                        _cnicController.clear();
                        _phoneController.clear();
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: !_isForSelf ? AppColors.primaryLight : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: !_isForSelf ? AppColors.primary : AppColors.border,
                          width: !_isForSelf ? 1.4 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Family Member',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: !_isForSelf
                                ? AppColors.primaryDark
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // ==========================================
            // 3. REQUIRED FIELDS (Name, Age, CNIC, Mobile)
            // ==========================================
            // Field 1: Patient Name
            _buildFieldLabel('Patient Name', isRequired: true),
            _buildInputField(_nameController, keyboardType: TextInputType.name),
            const SizedBox(height: 14),

            // Field 2: Age
            _buildFieldLabel('Age', isRequired: true),
            _buildInputField(_ageController, keyboardType: TextInputType.number),
            const SizedBox(height: 14),

            // Field 3: CNIC
            _buildFieldLabel('CNIC Number', isRequired: true),
            _buildInputField(_cnicController, keyboardType: TextInputType.number),
            const SizedBox(height: 14),

            // Field 4: Mobile Number
            _buildFieldLabel('Mobile Number', isRequired: true),
            _buildInputField(_phoneController, keyboardType: TextInputType.phone),
            const SizedBox(height: 18),

            // ==========================================
            // 4. REASON FOR VISIT (OPTIONAL) - NO PLACEHOLDER
            // ==========================================
            _buildFieldLabel('Reason for Visit (Optional)', isRequired: false),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: TextField(
                controller: _reasonController,
                maxLines: 3,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // ==========================================
            // 5. CONTINUE TO PAYMENT BUTTON
            // ==========================================
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _proceedToPayment,
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: const Text(
                  'Continue to Payment',
                  style: TextStyle(
                    fontSize: 14.5,
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
      ),
    );
  }

  // Label placed neatly above the box with required red star
  Widget _buildFieldLabel(String label, {bool isRequired = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          children: isRequired
              ? const [
                  TextSpan(
                    text: ' *',
                    style: TextStyle(
                      color: AppColors.error,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ]
              : null,
        ),
      ),
    );
  }

  // Clean, spacious input box with no placeholder and zero overlap
  Widget _buildInputField(
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        ),
      ),
    );
  }
}
