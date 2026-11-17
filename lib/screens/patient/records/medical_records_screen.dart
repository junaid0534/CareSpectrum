import 'package:flutter/material.dart';
import '../../../core/app_colors.dart';
import '../../../models/medical_record.dart';

class MedicalRecordsScreen extends StatefulWidget {
  const MedicalRecordsScreen({super.key});

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Prescriptions',
    'Lab Reports',
    'Surgical',
  ];

  final List<MedicalRecord> _records = const [
    MedicalRecord(
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
    MedicalRecord(
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
    MedicalRecord(
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
    MedicalRecord(
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
    MedicalRecord(
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
    MedicalRecord(
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
  ];

  List<MedicalRecord> _getFilteredRecords() {
    if (_selectedCategory == 'All') return _records;
    return _records.where((r) => r.category == _selectedCategory).toList();
  }

  void _showDocumentPreview(MedicalRecord record) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        height: MediaQuery.of(context).size.height * 0.72,
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
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
                _buildCategoryBadge(record.category),
                const Spacer(),
                Text(
                  record.date,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              record.title,
              style: const TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              record.doctorOrLab,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      record.summary,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Clinical Details & Items',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                itemCount: record.details.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (context, i) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 9),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${i + 1}.',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            record.details[i],
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textPrimary,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Downloading ${record.title} (PDF)...'),
                          backgroundColor: AppColors.primary,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.file_download_outlined, size: 16),
                    label: const Text('Download PDF'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 42),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(fontWeight: FontWeight.w700),
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

  void _showUploadBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: SafeArea(
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
              const Text(
                'Upload Medical Record',
                style: TextStyle(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Upload clinical prescriptions, diagnostic lab scans, or surgical reports.',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              _buildUploadOption(
                icon: Icons.camera_alt_outlined,
                title: 'Scan Document with Camera',
                subtitle: 'Direct high-resolution medical document scan',
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Camera document scanner ready'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              _buildUploadOption(
                icon: Icons.upload_file_rounded,
                title: 'Upload PDF / Image File',
                subtitle: 'Select from internal storage or gallery',
                onTap: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('File picker ready for upload'),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
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

  Widget _buildCategoryBadge(String category) {
    Color bg;
    Color border;
    Color text;
    IconData icon;

    switch (category) {
      case 'Prescriptions':
        bg = const Color(0xFFEFF6FF);
        border = const Color(0xFFBFDBFE);
        text = const Color(0xFF0369A1);
        icon = Icons.medication_outlined;
        break;
      case 'Lab Reports':
        bg = const Color(0xFFECFDF5);
        border = const Color(0xFFA7F3D0);
        text = const Color(0xFF047857);
        icon = Icons.science_outlined;
        break;
      case 'Surgical':
      default:
        bg = const Color(0xFFFFFBEB);
        border = const Color(0xFFFDE68A);
        text = const Color(0xFFB45309);
        icon = Icons.local_hospital_outlined;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(7),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: text),
          const SizedBox(width: 4),
          Text(
            category,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: text,
            ),
          ),
        ],
      ),
    );
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
    final filtered = _getFilteredRecords();

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
                      size: 21,
                      color: AppColors.primary,
                    ),
                    onPressed: _showUploadBottomSheet,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          // Clean Filter Pills (Simple, no card wrapper)
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                final count = cat == 'All'
                    ? _records.length
                    : _records.where((r) => r.category == cat).length;

                return InkWell(
                  onTap: () => setState(() => _selectedCategory = cat),
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
                        '$cat ($count)',
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

          // List of Records
          Expanded(
            child: filtered.isEmpty
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
                              Icons.folder_open_rounded,
                              size: 30,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'No Records Found',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'No documents found in this category.',
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
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return Column(
                        children: [
                          _buildRecordCard(item),
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

  Widget _buildRecordCard(MedicalRecord record) {
    return InkWell(
      onTap: () => _showDocumentPreview(record),
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
            // Row 1: Category Badge & Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCategoryBadge(record.category),
                Text(
                  record.date,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Row 2: Title & Doctor / Lab
            Text(
              record.title,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              record.doctorOrLab,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              record.summary,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 10),

            // Solid Divider (No dotted line inside card)
            const Divider(height: 14, color: AppColors.border),

            // Row 3: File size & Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.picture_as_pdf_rounded,
                      size: 14,
                      color: Color(0xFFEF4444),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      record.fileSize,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    OutlinedButton(
                      onPressed: () => _showDocumentPreview(record),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        minimumSize: const Size(0, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      child: const Text(
                        'View Details',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Downloading ${record.title} (PDF)...'),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        minimumSize: const Size(0, 32),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(9),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Download PDF',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w700),
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