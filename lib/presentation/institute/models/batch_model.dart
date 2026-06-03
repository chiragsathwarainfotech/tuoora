import 'package:tuoora/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class BatchModel {
  final String id;
  final String title;
  final String time;
  final String subject;
  final String studentCount;
  final String location;
  final String statusLabel;
  final Color statusBg;
  final Color leftBorderColor;
  final double baseFee;
  final String description;
  final Color statusTextColor;
  final dynamic totalExpected;
  final dynamic totalPaid;
  final List<String> days;
  final List<dynamic>? students;
  final String? classroom;
  final int? staffId;
  final String? staffName;

  /// Day the batch was created. Used as the lower bound on the attendance
  /// date picker so the user can't navigate to dates that pre-date the
  /// batch. Null when the API didn't return a parseable timestamp — the
  /// picker then falls back to a safe sentinel.
  final DateTime? createdAt;

  BatchModel({
    required this.id,
    required this.title,
    required this.time,
    required this.subject,
    required this.studentCount,
    required this.location,
    required this.statusLabel,
    required this.statusBg,
    required this.leftBorderColor,
    this.baseFee = 0.0,
    this.description = '',
    this.statusTextColor = AppColors.white,
    this.totalExpected,
    this.totalPaid,
    this.days = const ['Mon', 'Wed', 'Fri'],
    this.students,
    this.classroom,
    this.staffId,
    this.staffName,
    this.createdAt,
  });
}
