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
  final double? patientRating;
  final String? patientReview;
  final String? reviewDate;

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
    this.patientRating,
    this.patientReview,
    this.reviewDate,
  });

  bool get hasReviewed => patientRating != null && patientRating! > 0;

  Appointment copyWith({
    String? id,
    String? doctorName,
    String? specialty,
    String? hospital,
    String? date,
    String? time,
    String? status,
    String? type,
    String? fee,
    String? doctorImageUrl,
    String? tokenNumber,
    bool? isLiveNow,
    String? cancelReason,
    double? patientRating,
    String? patientReview,
    String? reviewDate,
  }) {
    return Appointment(
      id: id ?? this.id,
      doctorName: doctorName ?? this.doctorName,
      specialty: specialty ?? this.specialty,
      hospital: hospital ?? this.hospital,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
      type: type ?? this.type,
      fee: fee ?? this.fee,
      doctorImageUrl: doctorImageUrl ?? this.doctorImageUrl,
      tokenNumber: tokenNumber ?? this.tokenNumber,
      isLiveNow: isLiveNow ?? this.isLiveNow,
      cancelReason: cancelReason ?? this.cancelReason,
      patientRating: patientRating ?? this.patientRating,
      patientReview: patientReview ?? this.patientReview,
      reviewDate: reviewDate ?? this.reviewDate,
    );
  }
}
