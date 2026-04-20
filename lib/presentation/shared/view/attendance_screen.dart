import 'package:fee_easy/core/widgets/parent_bottom_nav.dart';
import 'package:fee_easy/core/widgets/student_bottom_nav.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_strings.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AttendanceScreen extends StatefulWidget {
  final bool showBottomNav;
  const AttendanceScreen({super.key, this.showBottomNav = true});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime _viewDate = DateTime(
    2024,
    9,
  ); // Initializing to September 2024 as per current UI

  final List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  void _prevMonth() {
    setState(() {
      _viewDate = DateTime(_viewDate.year, _viewDate.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _viewDate = DateTime(_viewDate.year, _viewDate.month + 1);
    });
  }

  String _getProfileRoute() {
    return Get.currentRoute.contains('/parent')
        ? AppRoutes.parentStudentProfile
        : AppRoutes.studentSettings;
  }

  String _getUpdatesRoute() {
    return Get.currentRoute.contains('/parent')
        ? AppRoutes.parentUpdates
        : AppRoutes.studentNotifications;
  }

  @override
  Widget build(BuildContext context) {
    final bool isParent = Get.currentRoute.contains('/parent');

    Widget content = SingleChildScrollView(
      padding: AppSpacing.screenPadding,
      child: Column(
        children: [
          _buildAttendanceHeaderCard(),
          AppSpacing.v32,
          _buildCalendarSection(),
          AppSpacing.v32,
          _buildRecentHistorySection(),
          AppSpacing.v24,
        ],
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(_getProfileRoute()),
              child: const CircleAvatar(
                radius: AppSpacing.s18,
                backgroundImage: NetworkImage(
                  'https://i.pravatar.cc/150?img=11',
                ),
              ),
            ),
            AppSpacing.h12,
            Text(
              AppStrings.appName,
              style: AppTextStyles.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1E3A8A),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(_getUpdatesRoute()),
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF111827),
              size: AppSpacing.s26,
            ),
          ),
          AppSpacing.h8,
        ],
      ),
      body: content,
      bottomNavigationBar: widget.showBottomNav
          ? (isParent
                ? const ParentBottomNav(currentIndex: 3)
                : const StudentBottomNav(currentIndex: 1))
          : null,
    );
  }

  Widget _buildAttendanceHeaderCard() {
    return Container(
      width: double.infinity,
      padding: AppSpacing.all32,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0056D2), Color(0xFF003781)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.s32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0056D2).withValues(alpha: 0.3),
            blurRadius: AppSpacing.s20,
            offset: const Offset(0, AppSpacing.s10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            AppStrings.overallAttendance,
            style: AppTextStyles.manrope(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.1,
            ),
            textAlign: TextAlign.center,
          ),
          AppSpacing.v32,
          _buildProgressRing(),
        ],
      ),
    );
  }

  Widget _buildProgressRing() {
    return Container(
      width: AppSpacing.s160,
      height: AppSpacing.s160,
      padding: AppSpacing.all8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: AppSpacing.s12,
        ),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: AppSpacing.s144,
            height: AppSpacing.s144,
            child: CircularProgressIndicator(
              value: 0.94,
              strokeWidth: AppSpacing.s12,
              backgroundColor: Colors.transparent,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              strokeCap: StrokeCap.round,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '94%',
                style: AppTextStyles.manrope(
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              Text(
                AppStrings.thisTerm,
                style: AppTextStyles.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.white.withValues(alpha: 0.7),
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarSection() {
    final String monthName = _months[_viewDate.month - 1];
    final String year = _viewDate.year.toString();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$monthName $year',
              style: AppTextStyles.manrope(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            Row(
              children: [
                _buildCircleNavButton(Icons.chevron_left, _prevMonth),
                AppSpacing.h12,
                _buildCircleNavButton(Icons.chevron_right, _nextMonth),
              ],
            ),
          ],
        ),
        AppSpacing.v24,
        Container(
          padding: AppSpacing.all24,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppSpacing.s32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: AppSpacing.s10,
                offset: const Offset(0, AppSpacing.s4),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildDaysHeader(),
              AppSpacing.v20,
              _buildCalendarGrid(),
              AppSpacing.v24,
              const Divider(color: Color(0xFFF3F4F6)),
              AppSpacing.v24,
              _buildLegendRow(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCircleNavButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppSpacing.s40,
        height: AppSpacing.s40,
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(AppSpacing.s12),
        ),
        child: Icon(icon, color: const Color(0xFF64748B), size: AppSpacing.s20),
      ),
    );
  }

  Widget _buildDaysHeader() {
    final days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days
          .map(
            (day) => Expanded(
              child: Center(
                child: Text(
                  day,
                  style: AppTextStyles.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF94A3B8),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCalendarGrid() {
    final now = DateTime.now();
    final isCurrentMonth =
        _viewDate.year == now.year && _viewDate.month == now.month;

    // Find how many days in the current _viewDate month
    int daysInMonth = DateTime(_viewDate.year, _viewDate.month + 1, 0).day;

    // Find what weekday the 1st of the month is.
    // DateTime.weekday: Monday=1 ... Sunday=7
    int firstWeekday = DateTime(_viewDate.year, _viewDate.month, 1).weekday;

    List<Widget> rows = [];
    List<String> currentRow = [];

    // Add empty slots for days before the 1st
    for (int i = 1; i < firstWeekday; i++) {
      currentRow.add('');
    }

    for (int day = 1; day <= daysInMonth; day++) {
      String status = 'p'; // default Present

      // Determine what day of week this is
      int currentWeekday = DateTime(
        _viewDate.year,
        _viewDate.month,
        day,
      ).weekday;

      if (currentWeekday == 6 || currentWeekday == 7) {
        status = 'i'; // weekends are usually not in session or pending
      } else if (isCurrentMonth) {
        if (day == now.day) {
          status = 't'; // today
        } else if (day > now.day) {
          status = 'i';
        } else {
          if (day % 7 == 0) {
            status = 'a';
          } else if (day % 13 == 0) {
            status = 'h';
          }
        }
      } else if (_viewDate.isAfter(now)) {
        status = 'i'; // entirely in the future
      } else {
        if (day % 8 == 0) {
          status = 'a';
        } else if (day % 15 == 0) {
          status = 'h';
        }
      }

      currentRow.add('$day$status');

      if (currentRow.length == 7) {
        rows.add(_buildCalRow(currentRow));
        if (day < daysInMonth) rows.add(AppSpacing.v12);
        currentRow = [];
      }
    }

    // Fill the remainder of the last row logically
    if (currentRow.isNotEmpty) {
      while (currentRow.length < 7) {
        currentRow.add('');
      }
      rows.add(_buildCalRow(currentRow));
    }

    return Column(children: rows);
  }

  Widget _buildCalRow(List<String> days) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days
          .map((dayCode) => Expanded(child: _buildDateBubble(dayCode)))
          .toList(),
    );
  }

  Widget _dateBubble(String label, Color color, Color textColor) {
    return Center(
      child: Container(
        width: AppSpacing.s36,
        height: AppSpacing.s36,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: Center(
          child: Text(
            label,
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateBubble(String code) {
    if (code.isEmpty) {
      return const SizedBox(width: AppSpacing.s36, height: AppSpacing.s36);
    }

    final day = code.substring(0, code.length - 1);
    final type = code.characters.last;

    switch (type) {
      case 'p': // Present
        return _dateBubble(
          day,
          const Color(0xFFEFF6FF),
          const Color(0xFF1E40AF),
        );
      case 'a': // Absent
        return _dateBubble(
          day,
          const Color(0xFFFEF2F2),
          const Color(0xFFB91C1C),
        );
      case 'h': // Holiday
        return _dateBubble(
          day,
          const Color(0xFFFDF2F2),
          const Color(0xFF92400E),
        );
      case 't': // Today
        return _dateBubble(day, const Color(0xFF1E3A8A), Colors.white);
      case 'i': // Pending / Future
        return _dateBubble(
          day,
          const Color(0xFFF8FAFC),
          const Color(0xFF64748B),
        );
      default:
        return _dateBubble(day, Colors.transparent, const Color(0xFF1E293B));
    }
  }

  Widget _buildLegendRow() {
    return Wrap(
      spacing: AppSpacing.s16,
      runSpacing: AppSpacing.s12,
      alignment: WrapAlignment.center,
      children: [
        _legendItem(const Color(0xFF1E3A8A), 'PRESENT'),
        _legendItem(const Color(0xFFB91C1C), 'ABSENT'),
        _legendItem(const Color(0xFF92400E), 'HOLIDAY'),
        _legendItem(const Color(0xFF94A3B8), 'PENDING'),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: AppSpacing.s10,
          height: AppSpacing.s10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        AppSpacing.h8,
        Text(
          label,
          style: AppTextStyles.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF64748B),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildRecentHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent History',
          style: AppTextStyles.manrope(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        AppSpacing.v20,
        _buildHistoryCard(
          date: 'Sept 17, 2024',
          subtitle: AppStrings.attendanceSubtitlePresent,
          status: AppStrings.attendanceStatusPresent,
          isPresent: true,
        ),
        AppSpacing.v16,
        _buildHistoryCard(
          date: 'Sept 16, 2024',
          subtitle: AppStrings.attendanceSubtitlePresent,
          status: AppStrings.attendanceStatusPresent,
          isPresent: true,
        ),
        AppSpacing.v16,
        _buildHistoryCard(
          date: 'Sept 13, 2024',
          subtitle: AppStrings.attendanceSubtitleAbsent,
          status: AppStrings.attendanceStatusAbsent,
          isPresent: false,
        ),
        AppSpacing.v16,
        _buildHistoryCard(
          date: 'Sept 12, 2024',
          subtitle: AppStrings.attendanceSubtitlePresent,
          status: AppStrings.attendanceStatusPresent,
          isPresent: true,
        ),
        AppSpacing.v32,
        SizedBox(
          width: double.infinity,
          height: AppSpacing.s56,
          child: ElevatedButton(
            onPressed: () {
              Get.toNamed(AppRoutes.parentAttendanceHistory);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD3E3FD),
              foregroundColor: const Color(0xFF003781),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.s20),
              ),
            ),
            child: Text(
              AppStrings.viewFullStatement,
              style: AppTextStyles.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryCard({
    required String date,
    required String subtitle,
    required String status,
    required bool isPresent,
  }) {
    return Container(
      padding: AppSpacing.all20,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppSpacing.s24),
        border: !isPresent
            ? const Border(
                left: BorderSide(
                  color: Color(0xFFB91C1C),
                  width: AppSpacing.s4,
                ),
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: AppSpacing.s10,
            offset: const Offset(0, AppSpacing.s4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: AppSpacing.s44,
            height: AppSpacing.s44,
            decoration: BoxDecoration(
              color: isPresent
                  ? const Color(0xFFEFF6FF)
                  : const Color(0xFFFEF2F2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPresent ? Icons.check_circle_rounded : Icons.cancel_rounded,
              color: isPresent
                  ? const Color(0xFF1E3A8A)
                  : const Color(0xFFB91C1C),
              size: AppSpacing.s24,
            ),
          ),
          AppSpacing.h16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: AppTextStyles.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                AppSpacing.v4,
                Text(
                  subtitle,
                  style: AppTextStyles.lexend(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            status,
            style: AppTextStyles.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: isPresent
                  ? const Color(0xFF1E3A8A)
                  : const Color(0xFFB91C1C),
            ),
          ),
        ],
      ),
    );
  }
}
