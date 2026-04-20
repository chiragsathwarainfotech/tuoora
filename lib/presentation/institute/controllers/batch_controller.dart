import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/presentation/institute/models/batch_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatchController extends GetxController {
  final batchesList = <BatchModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadMockBatches();
  }

  void _loadMockBatches() {
    batchesList.assignAll([
      BatchModel(
        id: '1',
        title: 'Mathematics - 10th Std',
        time: '08:00 AM - 09:30 AM',
        studentCount: '42 Students',
        location: 'Lab A',
        statusLabel: AppStrings.instStatusHighCapacity,
        statusBg: AppColors.instStatusHighCapacityBg,
        leftBorderColor: AppColors.instBorderHighCapacity,
      ),
      BatchModel(
        id: '2',
        title: 'Physics - Advanced',
        time: '10:30 AM - 12:00 PM',
        studentCount: '50 Students',
        location: 'Hall 3',
        statusLabel: AppStrings.instStatusFull,
        statusBg: AppColors.instStatusFullBg,
        leftBorderColor: AppColors.instBorderFull,
      ),
      BatchModel(
        id: '3',
        title: 'Literature 101',
        time: '02:00 PM - 03:30 PM',
        studentCount: '18 Students',
        location: 'Room 12',
        statusLabel: AppStrings.instStatusOpen,
        statusBg: AppColors.instStatusOpenBg,
        leftBorderColor: AppColors.instBorderOpen,
        statusTextColor: AppColors.instStatusOpenText,
      ),
    ]);
  }

  void deleteBatch(String id) {
    batchesList.removeWhere((batch) => batch.id == id);
    Get.snackbar(
      'Batch Deleted',
      'The batch has been removed successfully.',
      backgroundColor: const Color(0xFF027A48),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}
