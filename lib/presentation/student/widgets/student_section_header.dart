import 'package:flutter/material.dart';

import 'package:tuoora/core/constants/app_colors.dart';
import 'package:tuoora/core/constants/app_text_styles.dart';

/// Small uppercase caption used to label grouped tiles on student screens
/// (e.g. the dashboard sections, "PENDING FEES", "STUDY MATERIAL THIS
/// WEEK"). Optionally renders a plain-text action label on the right
/// (`See all`, `History`, etc.).
///
/// This is intentionally student-local because the institute side uses a
/// different visual treatment — see `lib/core/widgets/section_header.dart`.
class StudentSectionHeader extends StatelessWidget {
  /// Uppercase label rendered on the left.
  final String title;

  /// Shortcut for the most common case — equivalent to
  /// `actionLabel: 'See all'`. Ignored if [actionLabel] is also provided.
  final bool showSeeAll;

  /// Custom right-side label (e.g. `History`, `Filter`). Takes precedence
  /// over [showSeeAll].
  final String? actionLabel;

  /// Tap handler for the right-side label. When `null` the label is still
  /// rendered (so layout doesn't shift) but ignores taps.
  final VoidCallback? onActionTap;

  /// Override the action label's text colour. Defaults to the student
  /// brand accent.
  final Color? actionColor;

  const StudentSectionHeader({
    super.key,
    required this.title,
    this.showSeeAll = false,
    this.actionLabel,
    this.onActionTap,
    this.actionColor,
  });

  @override
  Widget build(BuildContext context) {
    final label = actionLabel ?? (showSeeAll ? 'See all' : null);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: AppColors.textTertiary,
            letterSpacing: 1.2,
          ),
        ),
        if (label != null)
          GestureDetector(
            onTap: onActionTap,
            behavior: HitTestBehavior.opaque,
            child: Text(
              label,
              style: AppTextStyles.outfit(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: actionColor ?? AppColors.orangeTag,
              ),
            ),
          ),
      ],
    );
  }
}
