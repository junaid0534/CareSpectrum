import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../models/medical_record.dart';
import 'category_records_screen.dart';
import '../surgical/wound_scanner_screen.dart';
import '../surgical/live_ot_tracker_screen.dart';
import '../surgical/preop_readiness_screen.dart';

class MedicalRecordsHubScreen extends StatefulWidget {
  final bool? showBackButton;

  const MedicalRecordsHubScreen({
    super.key,
    this.showBackButton,
  });

  @override
  State<MedicalRecordsHubScreen> createState() =>
      _MedicalRecordsHubScreenState();
}

class _MedicalRecordsHubScreenState extends State<MedicalRecordsHubScreen> {
  // Master list of patient clinical documents
  late List<MedicalRecord> _records;

  @override
  void initState() {
    super.initState();
    _records = [
      const MedicalRecord(
        id: 'rec_1',
        title: 'Cardiology Teleconsult Prescription',
        category: 'Prescriptions',
        doctorOrLab: 'Dr. Tariq Mahmood • NICVD',
        date: '14 Nov, 2026',
        fileSize: '1.2 MB PDF',
        summary: 'Daily beta-blocker maintenance & sodium reduction guidance.',
        details: [
          'Tab. Concor 5mg — 1 tablet daily morning (after meal)',
          'Tab. Cardiprin 100mg — 1 tablet after lunch',
          'Cap. Lipiget 20mg — 1 capsule at bedtime',
          'Follow-up in 4 weeks with fresh lipid profile test',
        ],
      ),
      const MedicalRecord(
        id: 'rec_2',
        title: 'Complete Blood Picture (CP & ESR)',
        category: 'Lab Reports',
        doctorOrLab: 'Chughtai Healthcare Diagnostic Lab',
        date: '10 Nov, 2026',
        fileSize: '2.4 MB PDF',
        summary: 'Normal hemoglobin levels (14.2 g/dL), no acute inflammation.',
        details: [
          'Hemoglobin (Hb): 14.2 g/dL (Normal range: 13.0 - 17.0)',
          'Total Leukocyte Count (TLC): 6,800 /uL (Normal)',
          'Platelet Count: 245,000 /uL (Normal)',
          'Erythrocyte Sedimentation Rate (ESR): 12 mm/1st hr',
        ],
      ),
      const MedicalRecord(
        id: 'rec_3',
        title: 'Laparoscopic Cholecystectomy Discharge Summary',
        category: 'Surgical',
        doctorOrLab: 'Dr. Salman Haider • Shifa International',
        date: '02 Nov, 2026',
        fileSize: '3.1 MB PDF',
        summary: 'Elective laparoscopic surgery completed with zero complications.',
        details: [
          'Procedure: Laparoscopic Gallbladder Removal (Cholecystectomy)',
          'Anesthesia: General Endotracheal Anesthesia',
          'Operative Findings: Chronic cholecystitis with multiple calculi',
          'Post-Op Recovery: Smooth, incision sites clean, sutures removed',
        ],
      ),
      const MedicalRecord(
        id: 'rec_v1',
        title: '24-Hour Ambulatory Blood Pressure Log',
        category: 'Vitals',
        doctorOrLab: 'Dr. Tariq Mahmood • CareSpectrum IoT Monitor',
        date: '12 Nov, 2026',
        fileSize: '1.0 MB PDF',
        summary: 'Mean arterial pressure within acceptable hemodynamic bounds.',
        details: [
          'Average Daytime BP: 124 / 82 mmHg (Controlled)',
          'Average Nighttime BP: 114 / 74 mmHg (Normal nocturnal dipping)',
          'Mean Resting Heart Rate: 72 bpm (Normal sinus rhythm)',
          'Compliance Rate: 98% reading intervals captured successfully',
        ],
      ),
      const MedicalRecord(
        id: 'rec_4',
        title: 'Neuro-Consultation & Brain MRI Scan Report',
        category: 'Lab Reports',
        doctorOrLab: 'Aga Khan University Diagnostic Center',
        date: '28 Oct, 2026',
        fileSize: '4.8 MB PDF',
        summary: 'High-resolution contrast brain scan: No intracranial lesions detected.',
        details: [
          'Study: MRI Brain with / without IV Gadolinium Contrast',
          'Vascular status: Symmetrical cerebral hemispheres, no acute infarct',
          'Ventricular system: Normal in size and configuration for age',
          'Impression: Normal neuro-radiological study',
        ],
      ),
      const MedicalRecord(
        id: 'rec_5',
        title: 'Pediatric Care & Allergy Prescription',
        category: 'Prescriptions',
        doctorOrLab: 'Dr. Fatima Noor • Children\'s Hospital',
        date: '20 Oct, 2026',
        fileSize: '850 KB PDF',
        summary: 'Seasonal rhinitis & pediatric anti-histamine regimen.',
        details: [
          'Syp. Zyrtec 5ml — Once daily before bedtime for 5 days',
          'Nasal Saline Spray — 2 sprays in each nostril twice daily',
          'Avoid cold drinks and high-dust exposure',
        ],
      ),
      const MedicalRecord(
        id: 'rec_6',
        title: 'Orthopedic Knee Arthroscopy Surgical Plan',
        category: 'Surgical',
        doctorOrLab: 'Dr. Usman Farooq • Doctors Hospital',
        date: '15 Oct, 2026',
        fileSize: '2.7 MB PDF',
        summary: 'Minimally invasive diagnostic arthroscopy for meniscus repair.',
        details: [
          'Pre-Op Diagnosis: Grade 2 Medial Meniscal Tear',
          'Planned Procedure: Right Knee Diagnostic Arthroscopy & Debridement',
          'Estimated Duration: 45 minutes under spinal anesthesia',
        ],
      ),
      const MedicalRecord(
        id: 'rec_7',
        title: 'Post-Op Analgesic & Antibiotic Regimen',
        category: 'Prescriptions',
        doctorOrLab: 'Dr. Salman Haider • Shifa International',
        date: '03 Nov, 2026',
        fileSize: '920 KB PDF',
        summary: 'Post-laparoscopic antimicrobial cover and pain management.',
        details: [
          'Tab. Augmentin 625mg — 1 tablet every 12 hours for 5 days',
          'Tab. Panadol Extra 500mg — 1 tablet every 8 hours as needed',
          'Cap. Risek 20mg — 1 capsule before breakfast daily',
        ],
      ),
      const MedicalRecord(
        id: 'rec_8',
        title: 'Fasting Blood Sugar & HbA1c Profile',
        category: 'Lab Reports',
        doctorOrLab: 'IDC Islamabad Diagnostic Centre',
        date: '18 Oct, 2026',
        fileSize: '1.1 MB PDF',
        summary: 'Glycemic control profile: HbA1c 5.6% (Non-diabetic range).',
        details: [
          'Fasting Plasma Glucose: 92 mg/dL (Normal: 70 - 100)',
          'Estimated Average Glucose (eAG): 114 mg/dL',
          'HbA1c Level: 5.6% (Ideal clinical baseline)',
        ],
      ),
      const MedicalRecord(
        id: 'rec_9',
        title: 'Pre-Anesthesia Medical Fitness Certificate',
        category: 'Surgical',
        doctorOrLab: 'Dr. Amina Khalid • Shifa International',
        date: '29 Oct, 2026',
        fileSize: '1.5 MB PDF',
        summary: 'ASA Class I fitness clearance confirmed for elective procedures.',
        details: [
          'Airway Assessment: Mallampati Class I (Easy intubation profile)',
          'Cardiovascular Fitness: Cleared, ECG shows normal sinus rhythm',
          'ASA Grade: ASA-I (Fit for general anesthesia)',
        ],
      ),
      const MedicalRecord(
        id: 'rec_v2',
        title: 'Post-Op SpO2 & Hemodynamic Telemetry',
        category: 'Vitals',
        doctorOrLab: 'Recovery ICU Unit • Shifa International',
        date: '03 Nov, 2026',
        fileSize: '750 KB PDF',
        summary: 'Continuous 12-hour continuous saturation tracking post-procedure.',
        details: [
          'Oxygen Saturation (SpO2): Constant 99% on room air',
          'Respiration Rate: 16 breaths/min (Eupneic)',
          'Body Temperature: 36.8°C (Afebrile state)',
        ],
      ),
    ];
  }

  List<MedicalRecord> _getRecordsByCategory(String category) {
    return _records.where((r) => r.category == category).toList();
  }

  void _navigateToCategory({
    required String title,
    required String categoryKey,
    required IconData icon,
    required Color color,
  }) {
    final categoryRecords = _getRecordsByCategory(categoryKey);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoryRecordsScreen(
          categoryTitle: title,
          categoryKey: categoryKey,
          icon: icon,
          themeColor: color,
          records: categoryRecords,
        ),
      ),
    );
  }

  void _showUploadRecordSheet() {
    final titleController = TextEditingController();
    final doctorController = TextEditingController();
    final summaryController = TextEditingController();
    String selectedCategory = 'Prescriptions';
    bool fileSelected = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 18,
              bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.cloud_upload_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Upload Medical Record',
                            style: TextStyle(
                              fontSize: 16.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Add to your encrypted health vault',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Category Picker
                  const Text(
                    'Record Category',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      'Prescriptions',
                      'Lab Reports',
                      'Surgical',
                      'Vitals',
                    ].map((cat) {
                      final isSelected = selectedCategory == cat;
                      return ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (val) {
                          if (val) setSheetState(() => selectedCategory = cat);
                        },
                        selectedColor: AppColors.primaryLight,
                        backgroundColor: AppColors.background,
                        labelStyle: TextStyle(
                          fontSize: 11.5,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  // Document Title Input
                  const Text(
                    'Document Title',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: titleController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: 'e.g., Cardiology Prescription / Blood CBC',
                        hintStyle: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textMuted,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Doctor or Hospital Name Input
                  const Text(
                    'Doctor or Diagnostic Lab',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: doctorController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: 'e.g., Dr. Tariq Mahmood / Chughtai Lab',
                        hintStyle: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textMuted,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Summary Input
                  const Text(
                    'Brief Summary / Diagnosis',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: TextField(
                      controller: summaryController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        isDense: true,
                        hintText: 'Key notes or medicine instructions...',
                        hintStyle: TextStyle(
                          fontSize: 12.5,
                          color: AppColors.textMuted,
                        ),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Simulated File Attachment
                  InkWell(
                    onTap: () {
                      setSheetState(() => fileSelected = !fileSelected);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: fileSelected
                            ? const Color(0xFFECFDF5)
                            : AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: fileSelected
                              ? const Color(0xFF10B981)
                              : AppColors.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            fileSelected
                                ? Icons.check_circle_rounded
                                : Icons.attach_file_rounded,
                            size: 18,
                            color: fileSelected
                                ? const Color(0xFF10B981)
                                : AppColors.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              fileSelected
                                  ? 'document_scan_final.pdf attached (1.8 MB)'
                                  : 'Attach PDF document or photo scan',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: fileSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: fileSelected
                                    ? const Color(0xFF047857)
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                          if (!fileSelected)
                            const Text(
                              'Browse',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Submit Button
                  ElevatedButton(
                    onPressed: () {
                      final title = titleController.text.trim();
                      if (title.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please enter a document title'),
                            backgroundColor: Color(0xFFEF4444),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      final newDoc = MedicalRecord(
                        id: 'rec_${DateTime.now().millisecondsSinceEpoch}',
                        title: title,
                        category: selectedCategory,
                        doctorOrLab: doctorController.text.trim().isEmpty
                            ? 'CareSpectrum Health Network'
                            : doctorController.text.trim(),
                        date: 'Today, 16 Nov 2026',
                        fileSize: '1.8 MB PDF',
                        summary: summaryController.text.trim().isEmpty
                            ? 'Patient uploaded clinical record'
                            : summaryController.text.trim(),
                        details: [
                          'Uploaded via CareSpectrum Patient Mobile Portal',
                          'Document verified and signed cryptographically',
                          'Indexed into $selectedCategory vault',
                        ],
                      );

                      setState(() {
                        _records.insert(0, newDoc);
                      });

                      Navigator.pop(sheetCtx);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(Icons.check_circle_rounded,
                                  color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text('"$title" added to $selectedCategory'),
                            ],
                          ),
                          backgroundColor: const Color(0xFF059669),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Save to Health Vault',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final prescriptionCount = _getRecordsByCategory('Prescriptions').length;
    final labCount = _getRecordsByCategory('Lab Reports').length;
    final surgicalCount = _getRecordsByCategory('Surgical').length;
    final vitalsCount = _getRecordsByCategory('Vitals').length;

    final canPop =
        widget.showBackButton ?? (ModalRoute.of(context)?.canPop ?? false);

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
                  if (canPop)
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                      onPressed: () => Navigator.pop(context),
                    )
                  else
                    const SizedBox(width: 44),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Medical Records',
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
                      Icons.add_circle_outline_rounded,
                      size: 20,
                      color: AppColors.primary,
                    ),
                    onPressed: _showUploadRecordSheet,
                    tooltip: 'Upload Document',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Clean, Minimal Typography Introduction (No Black Card)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.folder_shared_outlined,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Organize All Your Records',
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFECFDF5),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.lock_outline_rounded,
                              size: 11,
                              color: Color(0xFF059669),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Encrypted',
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF059669),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Select a category below to view, manage, and download your verified prescriptions, diagnostic lab reports, and surgical summaries.',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: AppColors.textSecondary,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 2. Section Header: 2x2 Categories
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'SELECT CATEGORY',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 3. 2 by 2 Category Menu with Big Clear Icons & Name Underneath
            Row(
              children: [
                // Prescriptions
                Expanded(
                  child: _buildBigIconCategoryCard(
                    title: 'Prescriptions',
                    categoryKey: 'Prescriptions',
                    countText: '$prescriptionCount Files',
                    icon: Icons.medication_outlined,
                    iconColor: const Color(0xFF0284C7),
                    iconBgColor: const Color(0xFFEFF6FF),
                  ),
                ),
                const SizedBox(width: 14),
                // Lab Reports
                Expanded(
                  child: _buildBigIconCategoryCard(
                    title: 'Lab Reports',
                    categoryKey: 'Lab Reports',
                    countText: '$labCount Files',
                    icon: Icons.science_outlined,
                    iconColor: const Color(0xFF059669),
                    iconBgColor: const Color(0xFFECFDF5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                // Surgical Records
                Expanded(
                  child: _buildBigIconCategoryCard(
                    title: 'Surgical Records',
                    categoryKey: 'Surgical',
                    countText: '$surgicalCount Files',
                    icon: Icons.medical_services_outlined,
                    iconColor: const Color(0xFFD97706),
                    iconBgColor: const Color(0xFFFFFBEB),
                  ),
                ),
                const SizedBox(width: 14),
                // Vitals & Logs
                Expanded(
                  child: _buildBigIconCategoryCard(
                    title: 'Vitals & Logs',
                    categoryKey: 'Vitals',
                    countText: '$vitalsCount Files',
                    icon: Icons.monitor_heart_outlined,
                    iconColor: const Color(0xFFE11D48),
                    iconBgColor: const Color(0xFFFFF1F2),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // 3.5 AI Surgical Wound Scanner Shortcut (FYP Core Feature)
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WoundScannerScreen(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.camera_enhance_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Surgical Wound Monitor',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF065F46),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Scan incision stitches to track SSI & healing',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF047857),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                      color: Color(0xFF059669),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 3.6 Live OT Tracker Shortcut (FYP Core Feature)
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LiveOtTrackerScreen(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.meeting_room_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Live Operation Theater (OT) Tracker',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0369A1),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Real-time surgical milestones & family alerts',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF0284C7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                      color: Color(0xFF0284C7),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 3.7 Pre-Op Readiness Shortcut (FYP Core Feature)
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PreOpReadinessScreen(),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD97706),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.timer_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pre-Op Fasting (NPO) & Safety Guard',
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF92400E),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Fasting countdown, blood thinners & clearances',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFFB45309),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                      color: Color(0xFFD97706),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            // 4. Quick Action Button (Clean and uncluttered; no records on this screen)
            OutlinedButton.icon(
              onPressed: _showUploadRecordSheet,
              icon: const Icon(Icons.cloud_upload_outlined, size: 18),
              label: const Text('Upload New Medical Document'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                side: const BorderSide(color: AppColors.primary),
                foregroundColor: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2x2 Category Card with Big, Prominent Icon and Name Underneath
  Widget _buildBigIconCategoryCard({
    required String title,
    required String categoryKey,
    required String countText,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
  }) {
    return InkWell(
      onTap: () => _navigateToCategory(
        title: title,
        categoryKey: categoryKey,
        icon: icon,
        color: iconColor,
      ),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Big Clear Icon Container
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 14),

            // Category Name Underneath
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Clean Count Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                countText,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: iconColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
