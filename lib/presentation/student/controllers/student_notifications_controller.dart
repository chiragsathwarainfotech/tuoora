import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tuoora/config/app_routes.dart';
import 'package:tuoora/core/api/api_client.dart';
import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/enums/app_enums.dart';
import 'package:tuoora/core/widgets/app_snack_bar.dart';
import 'package:tuoora/data/models/student_notification_model.dart';
import 'package:tuoora/data/repositories/student_notifications_repository.dart';
import 'package:tuoora/presentation/student/controllers/assignments_controller.dart';

/// View-model for a single notification row. Encapsulates the icon /
/// colour / time-ago decisions so the screen widget stays declarative.
class StudentNotificationDisplay {
  final StudentNotification raw;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String timeAgo;
  final bool showChevron;

  const StudentNotificationDisplay({
    required this.raw,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.timeAgo,
    required this.showChevron,
  });

  String get title => raw.title;
  String get message => raw.message;
  bool get isRead => raw.isRead;
}

class StudentNotificationsController extends GetxController {
  final RxBool isLoading = true.obs;
  final RxList<StudentNotification> items = <StudentNotification>[].obs;

  late final StudentNotificationsRepository _repository;

  @override
  void onInit() {
    super.onInit();
    _repository = StudentNotificationsRepository(Get.find<ApiClient>());
    load();
  }

  Future<void> load() async {
    try {
      isLoading.value = true;
      final list = await _repository.getNotifications();
      items.assignAll(list);
    } catch (_) {
      AppSnackBar.error('Failed to load notifications');
    } finally {
      isLoading.value = false;
    }
  }

  List<StudentNotificationDisplay> get displays =>
      items.map(_toDisplay).toList();

  /// Routes notification taps to the right screen based on [n.kind].
  /// Types we don't know how to deep-link into stay on the list (no
  /// jarring no-op navigation).
  void openNotification(StudentNotification n) {
    if (!_isDeepLinkable(n)) return;
    final refId = n.referenceIdInt;
    switch (n.kind) {
      case NotificationKind.homework:
      case NotificationKind.homeworkReminder:
        if (refId != null) _openHomework(refId);
        break;
      case NotificationKind.dailyUpdate:
        Get.toNamed(AppRoutes.studentEventDetail);
        break;
      case NotificationKind.holidays:
        Get.toNamed(AppRoutes.studentHolidayDetail);
        break;
      case NotificationKind.paymentReceiver:
        Get.toNamed(AppRoutes.studentFeeHistory);
        break;
      default:
        break;
    }
  }

  void _openHomework(int id) {
    if (!Get.isRegistered<AssignmentsController>()) {
      Get.put(AssignmentsController());
    }
    Get.find<AssignmentsController>().openAssignmentById(id);
  }

  StudentNotificationDisplay _toDisplay(StudentNotification n) {
    final v = _visualsFor(n.kind);
    return StudentNotificationDisplay(
      raw: n,
      icon: v.icon,
      iconBg: v.bg,
      iconColor: v.fg,
      timeAgo: _formatTimeAgo(n.createdAt),
      showChevron: _isDeepLinkable(n),
    );
  }

  bool _isDeepLinkable(StudentNotification n) {
    switch (n.kind) {
      case NotificationKind.dailyUpdate:
      case NotificationKind.holidays:
      case NotificationKind.paymentReceiver:
      case NotificationKind.homeworkReminder:
      case NotificationKind.homework:
        return true;
      default:
        return false;
    }
  }

  _NotificationVisuals _visualsFor(NotificationKind k) {
    switch (k) {
      case NotificationKind.homework:
      case NotificationKind.homeworkReminder:
        return const _NotificationVisuals(
          icon: Icons.chrome_reader_mode_outlined,
          bg: AppColors.errorBg,
          fg: AppColors.bohoRed,
        );
      case NotificationKind.homeworkGraded:
        return const _NotificationVisuals(
          icon: Icons.auto_awesome,
          bg: AppColors.primaryBrandLight,
          fg: AppColors.primaryBrand,
        );
      case NotificationKind.attendance:
        return const _NotificationVisuals(
          icon: Icons.calendar_today_outlined,
          bg: AppColors.successBg,
          fg: AppColors.successGreen,
        );
      case NotificationKind.resource:
        return const _NotificationVisuals(
          icon: Icons.menu_book_outlined,
          bg: AppColors.subjectPhysicsSoft,
          fg: AppColors.darkGreen,
        );
      case NotificationKind.dailyUpdate:
        return const _NotificationVisuals(
          icon: Icons.campaign_outlined,
          bg: AppColors.errorBg,
          fg: AppColors.error,
        );
      case NotificationKind.batchAssignment:
      case NotificationKind.batchRemoval:
        return const _NotificationVisuals(
          icon: Icons.groups_outlined,
          bg: AppColors.subjectPhysicsSoft,
          fg: AppColors.subjectPhysics,
        );
      case NotificationKind.holidays:
        return const _NotificationVisuals(
          icon: Icons.celebration_outlined,
          bg: AppColors.successBg,
          fg: AppColors.successGreen,
        );
      case NotificationKind.paymentReceiver:
        return const _NotificationVisuals(
          icon: Icons.currency_rupee,
          bg: AppColors.errorBg,
          fg: AppColors.bohoRed,
        );
      default:
        return const _NotificationVisuals(
          icon: Icons.notifications_none_outlined,
          bg: AppColors.borderGrey,
          fg: AppColors.textDarkGrey,
        );
    }
  }

  String _formatTimeAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dt.day} ${months[dt.month - 1]}';
  }
}

class _NotificationVisuals {
  final IconData icon;
  final Color bg;
  final Color fg;
  const _NotificationVisuals({
    required this.icon,
    required this.bg,
    required this.fg,
  });
}
