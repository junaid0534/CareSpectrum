import 'package:flutter/material.dart';

enum WoundHealingStatus {
  normalHealing,
  mildErythema,
  infectionAlert,
  criticalDehiscence,
}

class WoundScanResult {
  final String id;
  final String procedureName;
  final int postOpDay;
  final String scanDate;
  final WoundHealingStatus status;
  final int healingScore; // 0 to 100
  final double confidencePercentage;
  final String erythemaIndex;
  final String exudateType;
  final String edgeApproximation;
  final String edemaLevel;
  final String localThermalEstimate;
  final String aiSummary;
  final List<String> clinicalObservations;
  final List<String> surgeonRecommendations;
  final List<String> warningFlags;
  final String? imageUrl;
  final Color statusColor;
  final Color statusBgColor;

  const WoundScanResult({
    required this.id,
    required this.procedureName,
    required this.postOpDay,
    required this.scanDate,
    required this.status,
    required this.healingScore,
    required this.confidencePercentage,
    required this.erythemaIndex,
    required this.exudateType,
    required this.edgeApproximation,
    required this.edemaLevel,
    required this.localThermalEstimate,
    required this.aiSummary,
    required this.clinicalObservations,
    required this.surgeonRecommendations,
    required this.warningFlags,
    this.imageUrl,
    required this.statusColor,
    required this.statusBgColor,
  });

  String get statusTitle {
    switch (status) {
      case WoundHealingStatus.normalHealing:
        return 'Normal Healing Progress';
      case WoundHealingStatus.mildErythema:
        return 'Mild Localized Erythema (Monitor)';
      case WoundHealingStatus.infectionAlert:
        return 'Potential Surgical Site Infection (SSI)';
      case WoundHealingStatus.criticalDehiscence:
        return 'Critical: Wound Dehiscence / Drainage';
    }
  }

  String get riskBadgeLabel {
    switch (status) {
      case WoundHealingStatus.normalHealing:
        return 'LOW RISK';
      case WoundHealingStatus.mildErythema:
        return 'MODERATE RISK';
      case WoundHealingStatus.infectionAlert:
        return 'HIGH RISK (SSI)';
      case WoundHealingStatus.criticalDehiscence:
        return 'CRITICAL';
    }
  }
}
