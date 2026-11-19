class MedicationReminder {
  final String id;
  final String name;
  final String type; // Tablet, Capsule, Syrup, Injection
  final String dosage; // 1 tab, 5ml
  final String time; // 08:00 AM
  final String timeOfDay; // Morning, Afternoon, Evening, Night
  final String mealInstruction; // After Food, Before Food, Empty Stomach
  final int colorValue;
  final int stockLeft;
  final int totalStock;
  bool isTaken;
  String? takenTime;

  MedicationReminder({
    required this.id,
    required this.name,
    required this.type,
    required this.dosage,
    required this.time,
    required this.timeOfDay,
    required this.mealInstruction,
    required this.colorValue,
    this.stockLeft = 20,
    this.totalStock = 30,
    this.isTaken = false,
    this.takenTime,
  });

  MedicationReminder copyWith({
    String? id,
    String? name,
    String? type,
    String? dosage,
    String? time,
    String? timeOfDay,
    String? mealInstruction,
    int? colorValue,
    int? stockLeft,
    int? totalStock,
    bool? isTaken,
    String? takenTime,
  }) {
    return MedicationReminder(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      dosage: dosage ?? this.dosage,
      time: time ?? this.time,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      mealInstruction: mealInstruction ?? this.mealInstruction,
      colorValue: colorValue ?? this.colorValue,
      stockLeft: stockLeft ?? this.stockLeft,
      totalStock: totalStock ?? this.totalStock,
      isTaken: isTaken ?? this.isTaken,
      takenTime: takenTime ?? this.takenTime,
    );
  }
}
