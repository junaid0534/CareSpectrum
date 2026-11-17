class Appointment {
  final String id;
  final String doctorName;
  final String specialty;
  final String hospital;
  final String date;
  final String time;
  final String status; // 'Upcoming', 'Completed', 'Cancelled'
  final String type; // 'Teleconsult', 'In-Person', 'Surgical'
  final String fee;
  final String? doctorImageUrl;
  final String? tokenNumber;
  final bool isLiveNow;
  final String? cancelReason;

  const Appointment({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.hospital,
    required this.date,
    required this.time,
    required this.status,
    required this.type,
    required this.fee,
    this.doctorImageUrl,
    this.tokenNumber,
    this.isLiveNow = false,
    this.cancelReason,
  });
}
