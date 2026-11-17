import 'package:flutter/material.dart';

class PreOpChecklistItem {
  final String title;
  final String statusValue;
  final bool isCleared;
  final String clearedBy;
  final IconData icon;

  const PreOpChecklistItem({
    required this.title,
    required this.statusValue,
    required this.isCleared,
    required this.clearedBy,
    required this.icon,
  });
}

class PreOpMedicationAlert {
  final String medicineName;
  final String category;
  final String instruction;
  final bool isPaused;
  final String pausedSince;

  const PreOpMedicationAlert({
    required this.medicineName,
    required this.category,
    required this.instruction,
    required this.isPaused,
    required this.pausedSince,
  });
}

class PreOpCaseModel {
  final String procedureName;
  final String surgeryDate;
  final String surgeryTime;
  final String hospital;
  final String leadSurgeon;
  final String anesthesiologist;
  final String solidFoodCutoff;
  final String clearWaterCutoff;
  final int hoursUntilSurgery;
  final bool isConsentSigned;
  final List<PreOpMedicationAlert> medicationAlerts;
  final List<PreOpChecklistItem> fitnessClearances;

  const PreOpCaseModel({
    required this.procedureName,
    required this.surgeryDate,
    required this.surgeryTime,
    required this.hospital,
    required this.leadSurgeon,
    required this.anesthesiologist,
    required this.solidFoodCutoff,
    required this.clearWaterCutoff,
    required this.hoursUntilSurgery,
    required this.isConsentSigned,
    required this.medicationAlerts,
    required this.fitnessClearances,
  });
}
