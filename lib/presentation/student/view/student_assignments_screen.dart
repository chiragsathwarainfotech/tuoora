import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/enums/app_enums.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
import 'package:tuoora/core/widgets/app_empty_view.dart';
import 'package:tuoora/core/widgets/common_loading.dart';
import 'package:tuoora/core/widgets/student_bottom_nav.dart';
import 'package:tuoora/presentation/student/controllers/assignments_controller.dart';
import 'package:tuoora/presentation/student/models/assignment_model.dart';
import 'package:tuoora/presentation/student/widgets/student_app_bar.dart';

class StudentAssignmentsScreen extends GetView<AssignmentsController> {
  final bool showBottomNav;

  const StudentAssignmentsScreen({super.key, this.showBottomNav = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const StudentAppBar(
              title: AppStrings.studentAssignmentsTitle,
              isRoot: true,
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primaryBrand,
                onRefresh: controller.loadAssignments,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: AppSpacing.screenPaddingTop,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Obx(
                        () => _WeeklyProgressCard(
                          remaining: controller.weeklyRemaining.value,
                          total: controller.weeklyTotal.value,
                          completed: controller.weeklyCompleted.value,
                          teacherName: controller.teacherName.value,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s16),
                      Obx(
                        () => _SegmentedTabs(
                          activeIndex: controller.activeTab.value,
                          pendingCount: controller.pending.length,
                          completedCount: controller.completed.length,
                          onChange: controller.selectTab,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s16),
                      Obx(() {
                        if (controller.isLoading.value) {
                          return const Padding(
                            padding: EdgeInsets.all(32.0),
                            child: CommonLoading(color: AppColors.primaryBrand),
                          );
                        }

                        final items = controller.activeItems;
                        if (items.isEmpty) {
                          return _EmptyState(
                            active: controller.activeTab.value,
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: _interleave(
                            items.map(
                              (a) => _AssignmentCard(
                                item: a,
                                onTap: () => controller.openAssignment(a),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.s12),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: showBottomNav
          ? const StudentBottomNav(currentIndex: 1)
          : null,
    );
  }

  static List<Widget> _interleave(Iterable<Widget> items, Widget separator) {
    final list = items.toList();
    if (list.length <= 1) return list;
    final out = <Widget>[];
    for (var i = 0; i < list.length; i++) {
      if (i > 0) out.add(separator);
      out.add(list[i]);
    }
    return out;
  }
}

class _WeeklyProgressCard extends StatelessWidget {
  final int remaining;
  final int total;
  final int completed;
  final String teacherName;

  const _WeeklyProgressCard({
    required this.remaining,
    required this.total,
    required this.completed,
    required this.teacherName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _SegmentedProgressBar(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '$remaining',
                style: AppTextStyles.outfit(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                  height: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2, top: 6),
                child: Text(
                  '/$total',
                  style: AppTextStyles.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
              AppSpacing.h12,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.studentAssignmentsStillToDo,
                      style: AppTextStyles.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$completed ${AppStrings.studentAssignmentsCompletedBy} $teacherName',
                      style: AppTextStyles.outfit(
                        fontSize: 12,
                        color: AppColors.textTertiary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              AppSpacing.h8,
              const _SubjectAvatarStack(),
            ],
          ),
        ],
      ),
    );
  }
}

class _SegmentedProgressBar extends StatelessWidget {
  const _SegmentedProgressBar();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(AppSpacing.s16),
        topRight: Radius.circular(AppSpacing.s16),
      ),
      child: SizedBox(
        height: 6,
        child: Row(
          children: const [
            Expanded(flex: 5, child: ColoredBox(color: AppColors.primaryBrand)),
            Expanded(
              flex: 4,
              child: ColoredBox(color: AppColors.subjectPhysics),
            ),
            Expanded(flex: 3, child: ColoredBox(color: AppColors.successGreen)),
          ],
        ),
      ),
    );
  }
}

class _SubjectAvatarStack extends StatelessWidget {
  const _SubjectAvatarStack();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 80,
      height: 28,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _SubjectAvatar(
            offset: 0,
            bg: AppColors.primaryBrandLight,
            icon: Icons.functions_rounded,
            iconColor: AppColors.primaryBrand,
          ),
          _SubjectAvatar(
            offset: 22,
            bg: AppColors.subjectPhysicsSoft,
            icon: Icons.science_outlined,
            iconColor: AppColors.subjectPhysics,
          ),
          _SubjectAvatar(
            offset: 44,
            bg: AppColors.successBg,
            icon: Icons.menu_book_rounded,
            iconColor: AppColors.successGreen,
          ),
        ],
      ),
    );
  }
}

class _SubjectAvatar extends StatelessWidget {
  final double offset;
  final Color bg;
  final IconData icon;
  final Color iconColor;

  const _SubjectAvatar({
    required this.offset,
    required this.bg,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: offset,
      top: 0,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.white, width: 2),
        ),
        child: Icon(icon, size: 14, color: iconColor),
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  final int activeIndex;
  final int pendingCount;
  final int completedCount;
  final ValueChanged<int> onChange;

  const _SegmentedTabs({
    required this.activeIndex,
    required this.pendingCount,
    required this.completedCount,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label:
                  '${AppStrings.studentAssignmentsTabPending} ($pendingCount)',
              isActive: activeIndex == 0,
              onTap: () => onChange(0),
            ),
          ),
          Expanded(
            child: _TabButton(
              label:
                  '${AppStrings.studentAssignmentsTabCompleted} ($completedCount)',
              isActive: activeIndex == 1,
              onTap: () => onChange(1),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.s10,
          horizontal: AppSpacing.s12,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryBrand : AppColors.fieldBg,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: isActive ? AppColors.white : AppColors.textTertiary,
            ),
          ),
        ),
      ),
    );
  }
}

class _AssignmentCard extends StatelessWidget {
  final Assignment item;
  final VoidCallback? onTap;

  const _AssignmentCard({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Overdue rows stay tappable — the detail screen still opens; it just
    // disables the Submit action. We dim the card slightly so the user
    // still gets a visual cue that no action is possible.
    final bool dimmed = item.isOverdue;

    final card = Material(
      color: AppColors.white,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(width: 5, color: item.stripe),
                  Expanded(
                    child: Padding(
                      padding: AppSpacing.cardPadding,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: AppSpacing.s40,
                            height: AppSpacing.s40,
                            decoration: BoxDecoration(
                              color: item.iconBg,
                              borderRadius: BorderRadius.circular(
                                AppSpacing.s12,
                              ),
                            ),
                            child: Icon(
                              item.icon,
                              color: item.iconColor,
                              size: 20,
                            ),
                          ),
                          AppSpacing.h12,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.title,
                                  style:
                                      AppTextStyles.outfit(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: item.isCompleted
                                            ? AppColors.textMuted
                                            : AppColors.textPrimary,
                                      ).copyWith(
                                        decoration: item.isCompleted
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                        decorationColor: AppColors.textMuted,
                                        decorationThickness: 1.5,
                                      ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: item.subjectLabel,
                                        style: AppTextStyles.outfit(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w800,
                                          color: item.stripe,
                                          letterSpacing: 0.6,
                                        ),
                                      ),
                                      TextSpan(
                                        text: _statusSuffix(item),
                                        style: AppTextStyles.outfit(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: _statusColor(item),
                                          letterSpacing: 0.6,
                                        ),
                                      ),
                                    ],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          if (item.isCompleted) ...[
                            AppSpacing.h8,
                            _DuePill(badge: item.badge),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    if (dimmed) {
      return Opacity(opacity: 0.7, child: card);
    }
    return card;
  }

  static String _statusSuffix(Assignment item) {
    if (item.isCompleted) return '  ·  Submitted';
    if (item.isOverdue) return '  ·  Was due on ${item.dueLabel}';
    return '  ·  Due: ${item.dueLabel}';
  }

  static Color _statusColor(Assignment item) {
    if (item.isCompleted) return AppColors.successGreen;
    if (item.isOverdue) return AppColors.bohoRed;
    return AppColors.textTertiary;
  }
}

class _DuePill extends StatelessWidget {
  final AssignmentBadge badge;

  const _DuePill({required this.badge});

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final String label;
    switch (badge) {
      case AssignmentBadge.today:
        bg = AppColors.primaryBrand;
        label = AppStrings.studentTodayPill;
        break;
      case AssignmentBadge.tomorrow:
        bg = AppColors.orangeTag;
        label = AppStrings.studentTomorrowPill;
        break;
      case AssignmentBadge.done:
        bg = AppColors.successGreen;
        label = AppStrings.studentDonePill;
        break;
    }
    const fg = AppColors.white;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
      ),
      child: Text(
        label,
        style: AppTextStyles.outfit(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────────── Empty state

class _EmptyState extends StatelessWidget {
  final int active;

  const _EmptyState({required this.active});

  @override
  Widget build(BuildContext context) {
    return AppEmptyView(
      icon: Icons.task_alt_rounded,
      title: active == 0
          ? 'No pending assignments'
          : 'No completed assignments',
      message: active == 0
          ? AppStrings.studentAssignmentsEmptyPending
          : AppStrings.studentAssignmentsEmptyCompleted,
    );
  }
}
