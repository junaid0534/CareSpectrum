class Appointment {
  final String id;
  final String doctorName;
  final String specialty;
  final String hospital;
  final String date;
  final String time;
  final String status; // 'Upcoming', 'Completed', 'Cancelled'
  final String type;   // 'Teleconsult', 'In-Person', 'Surgical'
  final String fee;

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
  });
}
