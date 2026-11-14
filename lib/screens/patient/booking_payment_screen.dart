import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../models/doctor.dart';
import 'booking_slip_screen.dart';

class BookingPaymentScreen extends StatefulWidget {
  final Doctor doctor;
  final String consultMode;
  final DateTime selectedDate;
  final String selectedSlot;
  final String patientName;
  final String patientAge;
  final String patientCnic;
  final String patientPhone;
  final String reasonForVisit;

  const BookingPaymentScreen({
    super.key,
    required this.doctor,
    required this.consultMode,
    required this.selectedDate,
    required this.selectedSlot,
    required this.patientName,
    required this.patientAge,
    required this.patientCnic,
    required this.patientPhone,
    required this.reasonForVisit,
  });

  @override
  State<BookingPaymentScreen> createState() => _BookingPaymentScreenState();
}

class _BookingPaymentScreenState extends State<BookingPaymentScreen> {
  int _selectedMethodIndex = 0;
  final TextEditingController _walletPhoneController =
      TextEditingController(text: '03014025346');
  final TextEditingController _cardNumberController =
      TextEditingController(text: '4214 •••• •••• 8920');

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'easypaisa',
      'title': 'EasyPaisa',
      'sub': 'Mobile Wallet Account',
      'asset': 'assets/icons/easypaisa.png',
      'color': const Color(0xFF00AA4F),
      'bg': const Color(0xFFECFDF5),
    },
    {
      'id': 'jazzcash',
      'title': 'JazzCash',
      'sub': 'Mobile Wallet Account',
      'asset': 'assets/icons/jazzcash.png',
      'color': const Color(0xFFE51B24),
      'bg': const Color(0xFFFEF2F2),
    },
    {
      'id': 'card',
      'title': 'Credit / Debit Card',
      'sub': 'Visa, Mastercard, UnionPay',
      'asset': 'assets/icons/card_payment.png',
      'color': const Color(0xFF1A1F71),
      'bg': const Color(0xFFF8FAFC),
    },
    {
      'id': 'cash',
      'title': 'Cash on Visit',
      'sub': 'Pay at hospital reception',
      'asset': 'assets/icons/cash_payment.png',
      'color': const Color(0xFF0F766E),
      'bg': const Color(0xFFF0FDFA),
    },
  ];

  Widget _buildPaymentLogo(Map<String, dynamic> method, {double size = 42}) {
    final assetPath = method['asset'] as String?;
    final methodId = method['id'] as String? ?? '';

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(9),
        child: assetPath != null
            ? Image.asset(
                assetPath,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    _buildFallbackVectorLogo(methodId, size),
              )
            : _buildFallbackVectorLogo(methodId, size),
      ),
    );
  }

  Widget _buildFallbackVectorLogo(String methodId, double size) {
    switch (methodId) {
      case 'easypaisa':
        return Container(
          color: const Color(0xFF00AA4F),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: size * 0.42,
                      height: size * 0.42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                    Container(
                      width: size * 0.16,
                      height: size * 0.16,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                Text(
                  'easypaisa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        );

      case 'jazzcash':
        return Container(
          color: const Color(0xFF141414),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size * 0.22,
                      height: size * 0.22,
                      decoration: const BoxDecoration(
                        color: Color(0xFFED1C24),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(-size * 0.08, 0),
                      child: Container(
                        width: size * 0.22,
                        height: size * 0.22,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD100),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Jazz',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size * 0.17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: 'cash',
                        style: TextStyle(
                          color: const Color(0xFFFFD100),
                          fontSize: size * 0.17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );

      case 'card':
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: size * 0.28,
                    height: size * 0.28,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEB001B),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(-size * 0.1, 0),
                    child: Container(
                      width: size * 0.28,
                      height: size * 0.28,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF79E1B).withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 1),
              Text(
                'VISA',
                style: TextStyle(
                  color: const Color(0xFF1A1F71),
                  fontSize: size * 0.2,
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );

      case 'cash':
      default:
        return Container(
          color: const Color(0xFF0F766E),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.payments_rounded,
                  color: Colors.white,
                  size: size * 0.42,
                ),
                Text(
                  'CASH',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        );
    }
  }

  @override
  void dispose() {
    _walletPhoneController.dispose();
    _cardNumberController.dispose();
    super.dispose();
  }

  void _confirmBooking() {
    final selectedMethod =
        _paymentMethods[_selectedMethodIndex]['title'] as String;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BookingSlipScreen(
          doctor: widget.doctor,
          consultMode: widget.consultMode,
          selectedDate: widget.selectedDate,
          selectedSlot: widget.selectedSlot,
          patientName: widget.patientName,
          patientAge: widget.patientAge,
          patientCnic: widget.patientCnic,
          patientPhone: widget.patientPhone,
          reasonForVisit: widget.reasonForVisit,
          paymentMethod: selectedMethod,
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
                        'Payment & Review',
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
            // 1. APPOINTMENT MINI RECAP
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
                    ],
                  ),
                  const Divider(height: 18, color: AppColors.border),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Patient: ${widget.patientName} (${widget.patientAge} yrs)',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary),
                      ),
                      Text(
                        widget.selectedSlot,
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // ==========================================
            // 2. PAYMENT METHODS LIST
            // ==========================================
            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: List.generate(_paymentMethods.length, (idx) {
                final m = _paymentMethods[idx];
                final isSelected = _selectedMethodIndex == idx;

                return InkWell(
                  onTap: () => setState(() => _selectedMethodIndex = idx),
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primaryLight : AppColors.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        _buildPaymentLogo(m, size: 44),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m['title'] as String,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: isSelected
                                      ? AppColors.primaryDark
                                      : AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                m['sub'] as String,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.textMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? Center(
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 18),

            // ==========================================
            // 3. BILLING BREAKDOWN
            // ==========================================
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Consultation Fee',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Text(widget.doctor.fee,
                          style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Platform Service Fee',
                          style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      Text('FREE',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondary)),
                    ],
                  ),
                  const Divider(height: 16, color: AppColors.border),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount',
                          style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary)),
                      Text(widget.doctor.fee,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ==========================================
            // 4. CONFIRM BOOKING BUTTON
            // ==========================================
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
