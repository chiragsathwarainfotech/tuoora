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
  final Color statusTextColor;

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
    this.statusTextColor = Colors.white,
  });
}
