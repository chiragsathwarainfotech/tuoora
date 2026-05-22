import 'dart:io';

void main() {
  final file = File('lib/presentation/student/view/dashboard.dart');
  var content = file.readAsStringSync(
    encoding: const SystemEncoding(),
  ); // or utf8

  final todayStart = content.indexOf(
    'class _TodayClassCard extends StatelessWidget {',
  );
  final todayEnd = content.indexOf(
    'class _WeekStrip extends StatelessWidget {',
  );
  if (todayStart != -1 && todayEnd != -1) {
    final newToday = '''class _TodayClassCard extends StatelessWidget {
  final TodayClass todayClass;
  final List<WeekAttendanceDay> weekDays;

  const _TodayClassCard({
    required this.todayClass,
    required this.weekDays,
  });

  @override
  Widget build(BuildContext context) {
    final dayTokens = todayClass.startTime.split(' ');
    final month = todayClass.dayLabel;
    final weekdayLabel = todayClass.dayShort;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -8,
            top: 8,
            bottom: 8,
            child: Opacity(
              opacity: 0.08,
              child: Text(
                'S',
                style: AppTextStyles.manrope(
                  fontSize: 160,
                  fontWeight: FontWeight.w800,
                  color: AppColors.studentBrand,
                  height: 1,
                ),
              ),
            ),
          ),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 72,
                  decoration: BoxDecoration(
                    color: AppColors.studentBrand,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(AppSpacing.s20),
                      bottomLeft: Radius.circular(AppSpacing.s20),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.s16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayTokens.isNotEmpty ? dayTokens[0] : '',
                        style: AppTextStyles.manrope(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dayTokens.length > 1 ? dayTokens[1] : '',
                        style: AppTextStyles.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.s16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '\ � \',
                          style: AppTextStyles.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textTertiary,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          todayClass.subject,
                          style: AppTextStyles.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '\ - \ � \ � \',
                          style: AppTextStyles.lexend(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.s16),
                        _WeekStrip(weekDays: weekDays),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

''';
    content = content.replaceRange(todayStart, todayEnd, newToday);
  }

  final weekStart = content.indexOf(
    'class _WeekStrip extends StatelessWidget {',
  );
  final weekEnd = content.indexOf(
    'class _AssignmentTile extends StatelessWidget {',
  );
  if (weekStart != -1 && weekEnd != -1) {
    final newWeek = '''class _WeekStrip extends StatelessWidget {
  final List<WeekAttendanceDay> weekDays;
  const _WeekStrip({required this.weekDays});

  @override
  Widget build(BuildContext context) {
    if (weekDays.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: weekDays.map((day) {
        final isActive = day.date == DateTime.now().toString().substring(0, 10);
        final isPresent = day.status.toLowerCase() == 'present';
        final isAbsent = day.status.toLowerCase() == 'absent';
        
        Color dotColor = AppColors.borderGrey;
        if (isPresent) dotColor = AppColors.successGreen;
        else if (isAbsent) dotColor = AppColors.bohoRed;
        else if (isActive) dotColor = AppColors.orangeTag;

        return Column(
          children: [
            Text(
              day.day,
              style: AppTextStyles.manrope(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.textTertiary,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        );
      }).toList(),
    );
  }
}

''';
    content = content.replaceRange(weekStart, weekEnd, newWeek);
  }

  final assignStart = content.indexOf(
    'class _AssignmentTile extends StatelessWidget {',
  );
  final assignEnd = content.indexOf(
    'class _AttendanceCard extends StatelessWidget {',
  );
  if (assignStart != -1 && assignEnd != -1) {
    final newAssign = '''class _AssignmentTile extends StatelessWidget {
  final String title;
  final String subject;
  final String dueLabel;
  final String status;
  const _AssignmentTile({
    required this.title,
    required this.subject,
    required this.dueLabel,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isSubmitted = status.toLowerCase() == 'submitted';
    final pillBg = isSubmitted
        ? AppColors.studentBrandSoft
        : AppColors.studentTomorrowPillBg;
    final pillText = isSubmitted
        ? AppColors.studentTodayPillText
        : AppColors.studentTomorrowPillText;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.s14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.s40,
            height: AppSpacing.s40,
            decoration: BoxDecoration(
              color: AppColors.studentBrandSoft,
              borderRadius: BorderRadius.circular(AppSpacing.s12),
            ),
            child: Icon(
              Icons.menu_book_rounded,
              color: AppColors.studentBrand,
              size: 20,
            ),
          ),
          AppSpacing.h12,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '\ � \',
                  style: AppTextStyles.lexend(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          AppSpacing.h8,
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s12,
              vertical: AppSpacing.s4,
            ),
            decoration: BoxDecoration(
              color: pillBg,
              borderRadius: BorderRadius.circular(AppSpacing.s12),
            ),
            child: Text(
              status,
              style: AppTextStyles.manrope(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: pillText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

''';
    content = content.replaceRange(assignStart, assignEnd, newAssign);
  }

  file.writeAsStringSync(content);
}
