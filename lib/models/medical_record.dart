class MedicalRecord {
  final String id;
  final String title;
  final String category; // 'Prescription', 'Lab Report', 'Surgical'
  final String doctorOrLab;
  final String date;
  final String fileSize;
  final String summary;
  final List<String> details;

  const MedicalRecord({
    required this.id,
    required this.title,
    required this.category,
    required this.doctorOrLab,
    required this.date,
    required this.fileSize,
    required this.summary,
    required this.details,
  });
}