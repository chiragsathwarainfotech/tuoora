import re

with open('lib/presentation/student/view/dashboard.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Imports
content = content.replace(
    "import 'package:tuoora/presentation/student/controllers/assignments_controller.dart';",
    "import 'package:tuoora/presentation/student/controllers/assignments_controller.dart';\nimport 'package:tuoora/presentation/student/controllers/student_dashboard_controller.dart';\nimport 'package:tuoora/data/models/student_dashboard_model.dart';\nimport 'package:tuoora/data/models/student_resource_model.dart';\nimport 'package:tuoora/presentation/student/models/assignment_model.dart';"
)

# 2. GetView
content = content.replace(
    "class StudentDashboard extends StatelessWidget {",
    "class StudentDashboard extends GetView<StudentDashboardController> {"
)

# 3. Build method body to use Obx
build_start = content.find('Widget build(BuildContext context) {')
build_end = content.find('  String _initialsFor(String name) {')
old_build = content[build_start:build_end]

new_build = '''Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.studentBg,
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.studentBrand),
            );
          }
          final data = controller.dashboardData.value;
          if (data == null) {
            return const Center(child: Text('No data found'));
          }

          final firstName = (data.studentName.split(' ').first).trim();
          final initials = _initialsFor(data.studentName);

          return Column(
            children: [
              _Header(firstName: firstName, initials: initials),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.s16,
                    AppSpacing.s8,
                    AppSpacing.s16,
                    AppSpacing.s24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (data.todayClass != null) ...[
                        _TodayClassCard(
                          todayClass: data.todayClass!,
                          weekDays: data.weekAttendanceDays,
                        ),
                        const SizedBox(height: AppSpacing.s24),
                      ],
                      
                      if (data.todayAssignments.isNotEmpty) ...[
                        StudentSectionHeader(
                          title: "TODAY'S ASSIGNMENTS",
                          showSeeAll: true,
                          onActionTap: _openAssignmentsTab,
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        ...data.todayAssignments.take(2).map((assignment) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                            child: GestureDetector(
                              onTap: () => _openAssignmentDetail(assignment),
                              child: _AssignmentTile(
                                title: assignment.title,
                                subject: assignment.subjectLabel,
                                dueLabel: assignment.dueLabel,
                                status: assignment.badge == AssignmentBadge.done ? 'Submitted' : 'Pending',
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: AppSpacing.s16),
                      ],

                      const StudentSectionHeader(title: "TODAY'S ATTENDANCE"),
                      const SizedBox(height: AppSpacing.s12),
                      GestureDetector(
                        onTap: _openAttendanceTab,
                        child: _AttendanceCard(
                          status: data.todayAttendance.status,
                          detail: data.todayAttendance.text,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s24),

                      if (data.studyMaterials.isNotEmpty) ...[
                        StudentSectionHeader(
                          title: 'STUDY MATERIAL THIS WEEK',
                          showSeeAll: true,
                          onActionTap: () =>
                              Get.toNamed(AppRoutes.studentStudyMaterial),
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        ...data.studyMaterials.take(2).map((material) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                            child: GestureDetector(
                              onTap: () => _openStudyMaterialDetail(material),
                              child: _StudyMaterialTile(
                                title: material.title,
                                meta: ' �  � ',
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: AppSpacing.s16),
                      ],

                      if (data.pendingFees.isNotEmpty) ...[
                        StudentSectionHeader(
                          title: 'PENDING FEES',
                          actionLabel: 'History',
                          onActionTap: _openFeesTab,
                        ),
                        const SizedBox(height: AppSpacing.s12),
                        ...data.pendingFees.take(2).map((fee) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: AppSpacing.s8),
                            child: GestureDetector(
                              onTap: _openFeesTab,
                              child: _PendingFeeTile(
                                title: ' � ? due',
                                detail: 'Status:  � pay at institute',
                              ),
                            ),
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
      bottomNavigationBar: showBottomNav
          ? const StudentBottomNav(currentIndex: 0)
          : null,
    );
  }

'''

content = content.replace(old_build, new_build)

# 4. _open methods
content = content.replace(
    "static void _openAssignmentDetail(int index) {",
    "static void _openAssignmentDetail(Assignment assignment) {"
)
content = content.replace(
'''    if (!Get.isRegistered<AssignmentsController>()) {
      Get.put(AssignmentsController());
    }
    final ctrl = Get.find<AssignmentsController>();
    if (ctrl.pending.length > index) {
      ctrl.openAssignment(ctrl.pending[index]);
    }''',
'''    if (!Get.isRegistered<AssignmentsController>()) {
      Get.put(AssignmentsController());
    }
    final ctrl = Get.find<AssignmentsController>();
    ctrl.openAssignment(assignment);'''
)
content = content.replace(
    "static void _openStudyMaterialDetail(Map<String, dynamic> material) {",
    "static void _openStudyMaterialDetail(StudentResourceModel material) {"
)

# 5. Fix _TodayClassCard
today_class_start = content.find('class _TodayClassCard extends StatelessWidget {')
today_class_end = content.find('class _WeekStrip extends StatelessWidget {')
old_today_class = content[today_class_start:today_class_end]

new_today_class = '''class _TodayClassCard extends StatelessWidget {
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
                          ' � ',
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
                          ' -  �  � ',
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

'''
content = content.replace(old_today_class, new_today_class)

# 6. _WeekStrip
week_strip_start = content.find('class _WeekStrip extends StatelessWidget {')
week_strip_end = content.find('class _AssignmentTile extends StatelessWidget {')
old_week_strip = content[week_strip_start:week_strip_end]

new_week_strip = '''class _WeekStrip extends StatelessWidget {
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

'''
content = content.replace(old_week_strip, new_week_strip)

# 7. Fix _AssignmentTile
assignment_tile_start = content.find('class _AssignmentTile extends StatelessWidget {')
assignment_tile_end = content.find('class _AttendanceCard extends StatelessWidget {')
old_assignment_tile = content[assignment_tile_start:assignment_tile_end]

new_assignment_tile = '''class _AssignmentTile extends StatelessWidget {
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
                  ' � ',
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

'''
content = content.replace(old_assignment_tile, new_assignment_tile)

with open('lib/presentation/student/view/dashboard.dart', 'w', encoding='utf-8') as f:
    f.write(content)
