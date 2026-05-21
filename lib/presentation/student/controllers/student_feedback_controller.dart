import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/core/enums/app_enums.dart';
import 'package:tuoora/data/repositories/student_profile_repository.dart';

extension FeedbackRatingExtension on FeedbackRating {
  String get value {
    switch (this) {
      case FeedbackRating.loveIt:
        return 'love_it';
      case FeedbackRating.useful:
        return 'useful';
      case FeedbackRating.meh:
        return 'meh';
      case FeedbackRating.broken:
        return 'broken';
    }
  }

  String get label {
    switch (this) {
      case FeedbackRating.loveIt:
        return 'Love it';
      case FeedbackRating.useful:
        return 'Useful';
      case FeedbackRating.meh:
        return 'Meh';
      case FeedbackRating.broken:
        return 'Broken';
    }
  }
}

class StudentFeedbackController extends GetxController {
  final messageController = TextEditingController();
  final Rx<FeedbackRating> selectedRating = FeedbackRating.loveIt.obs;
  final RxBool isLoading = false.obs;

  late final StudentProfileRepository _repository;

  @override
  void onInit() {
    super.onInit();
    _repository = StudentProfileRepository(Get.find<ApiClient>());
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  void setRating(FeedbackRating rating) {
    selectedRating.value = rating;
  }

  Future<void> submitFeedback() async {
    final message = messageController.text.trim();
    if (message.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter a message before submitting.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      Map<String, dynamic> data = {
        'rating': selectedRating.value.value,
        'message': message,
      };

      await _repository.submitFeedback(data);
      Get.back();
      Get.snackbar(
        'Success',
        'Thank you! Your feedback has been sent.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit feedback. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
