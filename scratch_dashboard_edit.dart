import 'dart:io';

void main() {
  final file = File('lib/presentation/student/view/dashboard.dart');
  var content = file.readAsStringSync();

  final buildStart = content.indexOf('  @override\n  Widget build(BuildContext context) {');
  final buildEnd = content.indexOf('  String _initialsFor(String name) {');
  
  if (buildStart != -1 && buildEnd != -1) {
    final newBuild = '''  @override
  Widget build(BuildContext context) {
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
            return const Center(child: Text('No dashboard data found'));
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
                                meta: '\ · \ · \',
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
                                title: '\ · ?\ due',
                                detail: 'Status: \ · pay at institute',
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

''';
    content = content.replaceRange(buildStart, buildEnd, newBuild);
  }

  // update _open methods
  content = content.replaceAll(
      'static void _openAssignmentDetail(int index) {',
      'static void _openAssignmentDetail(Assignment assignment) {');
  
  content = content.replaceAll(
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
    ctrl.openAssignment(assignment);''');

  content = content.replaceAll(
      'static void _openStudyMaterialDetail(Map<String, dynamic> material) {',
      'static void _openStudyMaterialDetail(StudentResourceModel material) {');

  file.writeAsStringSync(content);
}
