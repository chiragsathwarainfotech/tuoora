import 'package:flutter/material.dart';

class ExpenseModel {
  final String id;
  final String title;
  final DateTime date;
  final String category;
  final double amount;
  final IconData icon;
  final Color iconBgColor;

  ExpenseModel({
    required this.id,
    required this.title,
    required this.date,
    required this.category,
    required this.amount,
    required this.icon,
    required this.iconBgColor,
  });
}
