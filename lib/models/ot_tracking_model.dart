import 'package:flutter/material.dart';

class OtMilestone {
  final String title;
  final String description;
  final String time;
  final bool isCompleted;
  final bool isCurrent;
  final String? clinicalNote;
  final IconData icon;

  const OtMilestone({
    required this.title,
    required this.description,
    required this.time,
    required this.isCompleted,
    required this.isCurrent,
    this.clinicalNote,
    required this.icon,
  });
}

class OtCaseDetails {
  final String caseId;
  final String patientName;
  final String procedureName;
  final String hospitalName;
  final String otSuite;
  final String leadSurgeon;
  final String anesthesiologist;
  final String nurseInCharge;
  final String startTime;
  final String estimatedEndTime;
  final String estimatedDuration;
  final int currentStageIndex;
  final String liveSurgeryNote;
  final Map<String, String> currentVitals;
  final List<OtMilestone> milestones;

  const OtCaseDetails({
    required this.caseId,
    required this.patientName,
    required this.procedureName,
    required this.hospitalName,
    required this.otSuite,
    required this.leadSurgeon,
    required this.anesthesiologist,
    required this.nurseInCharge,
    required this.startTime,
    required this.estimatedEndTime,
    required this.estimatedDuration,
    required this.currentStageIndex,
    required this.liveSurgeryNote,
    required this.currentVitals,
    required this.milestones,
  });
}
