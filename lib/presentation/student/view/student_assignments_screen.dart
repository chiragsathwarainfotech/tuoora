import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_strings.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';
import 'package:tuoora/core/enums/app_enums.dart';
import 'package:tuoora/core/theme/app_spacing.dart';
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s16,
                  AppSpacing.s16,
                  AppSpacing.s16,
                  AppSpacing.s24,
                ),
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
                          child: CommonLoading(color: AppColors.studentBrand),
                        );
                      }

                      final items = controller.activeItems;
                      if (items.isEmpty) {
                        return _EmptyState(active: controller.activeTab.value);
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
          ],
        ),
      ),
      bottomNavigationBar: showBottomNav
          ? const StudentBottomNav(currentIndex: 1)
          : null,
    );
  }

  /// Inserts [separator] between each element of [items]. Returns a new
  /// list; safe to call with an empty iterable.
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

// ─────────────────────────────────────────────────────────── Progress card

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
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s14),
            child: Row(
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
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$completed ${AppStrings.studentAssignmentsCompletedBy} $teacherName',
                        style: AppTextStyles.outfit(
                          fontSize: 11,
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
            Expanded(
              flex: 5,
              child: ColoredBox(color: AppColors.studentProgressOrange),
            ),
            Expanded(
              flex: 4,
              child: ColoredBox(color: AppColors.studentProgressBlue),
            ),
            Expanded(
              flex: 3,
              child: ColoredBox(color: AppColors.successGreen),
            ),
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
            bg: AppColors.studentBrandSoft,
            icon: Icons.functions_rounded,
            iconColor: AppColors.studentProgressOrange,
          ),
          _SubjectAvatar(
            offset: 22,
            bg: AppColors.studentUpdateIconBg,
            icon: Icons.science_outlined,
            iconColor: AppColors.studentUpdateIconColor,
          ),
          _SubjectAvatar(
            offset: 44,
            bg: AppColors.studentPresentBg,
            icon: Icons.menu_book_rounded,
            iconColor: AppColors.studentPresentText,
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
        color: AppColors.studentTabInactiveBg,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
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
          color: isActive ? AppColors.white : AppColors.studentTabInactiveBg,
          borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.outfit(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: isActive
                  ? AppColors.textPrimary
                  : AppColors.textTertiary,
            ),
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────────────────────────────────── Assignment card

class _AssignmentCard extends StatelessWidget {
  final Assignment item;
  final VoidCallback? onTap;

  const _AssignmentCard({required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    // Overdue rows: nothing the student can do anymore — disable tap so
    // the InkWell shows no ripple, and dull the whole card so it visually
    // reads as inactive (like an expired offer tile).
    final bool disabled = item.isOverdue;
    final VoidCallback? effectiveOnTap = disabled ? null : onTap;

    final card = Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(AppSpacing.s16),
      child: InkWell(
        onTap: effectiveOnTap,
        borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
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
            borderRadius: BorderRadius.circular(AppSpacing.s16),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(width: 5, color: item.stripe),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.s14),
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
                                        decorationColor:
                                            AppColors.textMuted,
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
                          // Right-side pill: shown ONLY for completed items
                          // ("Done"). Pending items now communicate their
                          // due-ness inline via "Due: <date>" on the line
                          // above, so a separate Today/Tomorrow pill is
                          // redundant.
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

    // "Expired offer" look: knock the whole row's opacity down so it
    // visually reads as inactive. AbsorbPointer guarantees no tap or
    // hover effect lands even if a child has its own GestureDetector.
    if (disabled) {
      return AbsorbPointer(
        child: Opacity(opacity: 0.55, child: card),
      );
    }
    return card;
  }

  /// Inline suffix after the subject label. Three buckets:
  ///   - Completed → "Submitted" (no date — completion is the message)
  ///   - Overdue   → `Was due on …` (past-tense, signals missed)
  ///   - Active    → `Due: …` (action-oriented, keeps urgency)
  static String _statusSuffix(Assignment item) {
    if (item.isCompleted) return '  ·  Submitted';
    if (item.isOverdue) return '  ·  Was due on ${item.dueLabel}';
    return '  ·  Due: ${item.dueLabel}';
  }

  static Color _statusColor(Assignment item) {
    if (item.isCompleted) return AppColors.studentPresentText;
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
    late final Color fg;
    late final String label;
    switch (badge) {
      case AssignmentBadge.today:
        bg = AppColors.studentBrandSoft;
        fg = AppColors.studentBrand;
        label = AppStrings.studentTodayPill;
        break;
      case AssignmentBadge.tomorrow:
        bg = AppColors.amberLight;
        fg = AppColors.studentTomorrowPillText;
        label = AppStrings.studentTomorrowPill;
        break;
      case AssignmentBadge.done:
        bg = AppColors.studentPresentBg;
        fg = AppColors.studentPresentText;
        label = AppStrings.studentDonePill;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s12,
        vertical: AppSpacing.s4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.s12),
      ),
      child: Text(
        label,
        style: AppTextStyles.outfit(
          fontSize: 11,
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
    final msg = active == 0
        ? AppStrings.studentAssignmentsEmptyPending
        : AppStrings.studentAssignmentsEmptyCompleted;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s40),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.studentBrandSoft,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.task_alt_rounded,
              color: AppColors.studentBrand,
              size: 32,
            ),
          ),
          const SizedBox(height: AppSpacing.s16),
          Text(
            msg,
            textAlign: TextAlign.center,
            style: AppTextStyles.outfit(
              fontSize: 13,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
