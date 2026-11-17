import 'package:flutter/material.dart';

class HealthNotification {
  final String id;
  final String title;
  final String message;
  final String detailedMessage;
  final String category; // 'Appointments', 'Prescriptions', 'Surgical', 'Reports'
  final String timeAgo;
  final String fullDate;
  final bool isRead;
  final IconData icon;
  final Color themeColor;
  final Color bgColor;
  final String? actionLabel;
  final String? actionType;
  final Map<String, dynamic>? metaData;

  const HealthNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.detailedMessage,
    required this.category,
    required this.timeAgo,
    required this.fullDate,
    this.isRead = false,
    required this.icon,
    required this.themeColor,
    required this.bgColor,
    this.actionLabel,
    this.actionType,
    this.metaData,
  });

  HealthNotification copyWith({
    bool? isRead,
  }) {
    return HealthNotification(
      id: id,
      title: title,
      message: message,
      detailedMessage: detailedMessage,
      category: category,
      timeAgo: timeAgo,
      fullDate: fullDate,
      isRead: isRead ?? this.isRead,
      icon: icon,
      themeColor: themeColor,
      bgColor: bgColor,
      actionLabel: actionLabel,
      actionType: actionType,
      metaData: metaData,
    );
  }
}
