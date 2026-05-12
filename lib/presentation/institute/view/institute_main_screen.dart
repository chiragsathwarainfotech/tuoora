import 'package:fee_easy/presentation/institute/controllers/institute_controller.dart';
import 'package:fee_easy/presentation/institute/view/dashboard.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InstituteMainScreen extends GetView<InstituteController> {
  const InstituteMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(child: InstituteDashboard()),
    );
  }
}

