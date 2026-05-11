import 'package:fee_easy/config/app_routes.dart';
import 'package:fee_easy/core/widgets/app_snackbar.dart';
import 'package:fee_easy/data/models/staff_model.dart';
import 'package:fee_easy/data/repositories_impl/institute_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class StaffController extends GetxController {
  final InstituteRepositoryImpl _repository;

  StaffController(this._repository);

  final isLoading = false.obs;
  final isSaving = false.obs;
  final staffList = <Staff>[].obs;
  final searchQuery = ''.obs;
  final selectedStaff = Rxn<Staff>();
  final selectedImagePath = Rxn<String>();

  // Metadata
  final roles = <StaffRole>[].obs;
  final departments = <StaffDepartment>[].obs;
  final isLoadingMetadata = false.obs;

  // Pagination
  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final totalItems = 0.obs;

  // Tab index for bottom navigation
  final currentTabIndex = 0.obs;

  // Salary History State
  final salaryList = <StaffSalary>[].obs;
  final isLoadingSalary = false.obs;
  final totalSalaryAmount = '0.00'.obs;
  final salaryCurrentPage = 1.obs;
  final salaryLastPage = 1.obs;

  // Attendance History State
  final attendanceList = <StaffAttendance>[].obs;
  final isLoadingAttendance = false.obs;
  final totalPresent = 0.obs;
  final totalAbsent = 0.obs;
  final attendanceCurrentPage = 1.obs;
  final attendanceLastPage = 1.obs;
  final selectedAttendanceMonth = DateTime.now().obs;

  // Global Attendance Logs (for StaffMainScreen)
  final globalAttendanceList = <StaffAttendance>[].obs;
  final isLoadingGlobalAttendance = false.obs;
  final globalAttendanceCurrentPage = 1.obs;
  final globalAttendanceLastPage = 1.obs;

  // Global Salary State (for StaffMainScreen)
  final globalSalaryList = <StaffSalary>[].obs;
  final isLoadingGlobalSalaries = false.obs;
  final totalGlobalSalaryAmount = '0.00'.obs;
  final globalSalaryCurrentPage = 1.obs;
  final globalSalaryLastPage = 1.obs;
  final selectedSalaryMonth = DateTime.now().obs;

  // Add/Edit Staff Reactive State
  final selectedRoleId = Rxn<int>();
  final selectedDepartmentId = Rxn<int>();
  final employmentType = 'Salary'.obs;

  final staffNameController = TextEditingController();
  final staffEmailController = TextEditingController();
  final staffPhoneController = TextEditingController();
  final staffSalaryController = TextEditingController();
  final addStaffFormKey = GlobalKey<FormState>();

  // Log Attendance State
  final selectedLogStaff = Rxn<Staff>();
  final selectedLogDate = DateTime.now().obs;
  final isPresent = true.obs;
  final logSearchQuery = ''.obs;
  final logNotesController = TextEditingController();
  final filteredLogStaffs = <Staff>[].obs;

  // Add Salary State
  final selectedAddSalaryStaff = Rxn<Staff>();
  final salarySearchQuery = ''.obs;
  final selectedSalaryDate = DateTime.now().obs;
  final isOnlinePayment = true.obs;
  final salaryAmountController = TextEditingController();
  final salaryNotesController = TextEditingController();
  final filteredSalaryStaffs = <Staff>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMetadata();
    fetchStaffs();
    debounce(
      searchQuery,
      (_) => fetchStaffs(page: 1),
      time: const Duration(milliseconds: 500),
    );
  }

  void changeTab(int index) {
    currentTabIndex.value = index;
    if (index == 1) {
      fetchGlobalAttendance(page: 1);
    } else if (index == 2) {
      fetchGlobalSalaries(page: 1);
    }
  }

  Future<void> fetchMetadata() async {
    try {
      isLoadingMetadata.value = true;
      final results = await Future.wait([
        _repository.getStaffRoles(),
        _repository.getStaffDepartments(),
      ]);
      roles.assignAll(results[0] as List<StaffRole>);
      departments.assignAll(results[1] as List<StaffDepartment>);
    } catch (e) {
      AppSnackbar.error('Failed to load roles and departments: $e');
    } finally {
      isLoadingMetadata.value = false;
    }
  }

  Future<void> fetchStaffs({int page = 1}) async {
    try {
      if (page == 1) isLoading.value = true;
      final response = await _repository.listStaff(
        page: page,
        search: searchQuery.value,
      );
      if (page == 1) {
        staffList.assignAll(response.items);
      } else {
        staffList.addAll(response.items);
      }
      currentPage.value = response.currentPage;
      lastPage.value = response.lastPage;
      totalItems.value = response.total;
    } catch (e) {
      AppSnackbar.error('Failed to load staff: $e');
    } finally {
      if (page == 1) isLoading.value = false;
    }
  }

  Future<void> fetchSalaryHistory({int page = 1}) async {
    if (selectedStaff.value == null) return;
    try {
      if (page == 1) isLoadingSalary.value = true;
      final response = await _repository.getStaffSalaries(
        selectedStaff.value!.id,
        page: page,
      );
      if (page == 1) {
        salaryList.assignAll(response.items);
      } else {
        salaryList.addAll(response.items);
      }
      totalSalaryAmount.value = response.totalAmount;
      salaryCurrentPage.value = response.currentPage;
      salaryLastPage.value = response.lastPage;
    } catch (e) {
      AppSnackbar.error('Failed to load salary history: $e');
    } finally {
      if (page == 1) isLoadingSalary.value = false;
    }
  }

  Future<void> fetchAttendanceHistory({int page = 1}) async {
    if (selectedStaff.value == null) return;
    try {
      if (page == 1) isLoadingAttendance.value = true;
      final response = await _repository.getStaffAttendance(
        selectedStaff.value!.id,
        page: page,
        month: DateFormat('MM').format(selectedAttendanceMonth.value),
        year: DateFormat('yyyy').format(selectedAttendanceMonth.value),
      );
      if (page == 1) {
        attendanceList.assignAll(response.items);
      } else {
        attendanceList.addAll(response.items);
      }
      totalPresent.value = response.totalPresent;
      totalAbsent.value = response.totalAbsent;
      attendanceCurrentPage.value = response.currentPage;
      attendanceLastPage.value = response.lastPage;
    } catch (e) {
      AppSnackbar.error('Failed to load attendance history: $e');
    } finally {
      if (page == 1) isLoadingAttendance.value = false;
    }
  }

  Future<void> fetchGlobalSalaries({int? page}) async {
    final isInitialFetch = page == null || page == 1;
    try {
      if (isInitialFetch) isLoadingGlobalSalaries.value = true;
      final response = await _repository.getGlobalSalaries(
        page: page,
        month: selectedSalaryMonth.value.month.toString(),
        year: selectedSalaryMonth.value.year.toString(),
      );
      if (isInitialFetch) {
        globalSalaryList.assignAll(response.items);
      } else {
        globalSalaryList.addAll(response.items);
      }
      totalGlobalSalaryAmount.value = response.totalAmount;
      globalSalaryCurrentPage.value = response.currentPage;
      globalSalaryLastPage.value = response.lastPage;
    } catch (e) {
      AppSnackbar.error('Failed to load salary logs: $e');
    } finally {
      if (isInitialFetch) isLoadingGlobalSalaries.value = false;
    }
  }

  Future<void> saveSalaryRecord() async {
    if (selectedAddSalaryStaff.value == null) {
      AppSnackbar.error('Please select a staff member');
      return;
    }
    if (salaryAmountController.text.isEmpty) {
      AppSnackbar.error('Please enter salary amount');
      return;
    }

    try {
      isSaving.value = true;
      final data = {
        'staff_id': selectedAddSalaryStaff.value!.id,
        'base_salary': salaryAmountController.text.trim(),
        'payment_date': DateFormat(
          'yyyy-MM-dd',
        ).format(selectedSalaryDate.value),
        'status': 'Paid',
        'payment_method': isOnlinePayment.value ? 'Online' : 'Cash',
        if (salaryNotesController.text.isNotEmpty)
          'notes': salaryNotesController.text.trim(),
      };

      await _repository.logSalary(data);
      AppSnackbar.success('Salary record saved successfully');

      // Refresh global list
      fetchGlobalSalaries(page: 1);

      // If we are on a staff profile, refresh their history too
      if (selectedStaff.value != null &&
          selectedStaff.value!.id == selectedAddSalaryStaff.value!.id) {
        fetchSalaryHistory(page: 1);
      }

      Get.back();
    } catch (e) {
      AppSnackbar.error('Failed to save salary record: $e');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> fetchGlobalAttendance({int page = 1}) async {
    try {
      if (page == 1) isLoadingGlobalAttendance.value = true;
      final response = await _repository.getAttendanceLogs(page: page);
      if (page == 1) {
        globalAttendanceList.assignAll(response.items);
      } else {
        globalAttendanceList.addAll(response.items);
      }
      globalAttendanceCurrentPage.value = response.currentPage;
      globalAttendanceLastPage.value = response.lastPage;
    } catch (e) {
      AppSnackbar.error('Failed to load attendance logs: $e');
    } finally {
      if (page == 1) isLoadingGlobalAttendance.value = false;
    }
  }

  Future<void> saveAttendanceRecord() async {
    if (selectedLogStaff.value == null) {
      AppSnackbar.error('Please select a staff member');
      return;
    }

    try {
      isSaving.value = true;
      final data = {
        'date': DateFormat('yyyy-MM-dd').format(selectedLogDate.value),
        'staff_id': selectedLogStaff.value!.id,
        'status': isPresent.value ? 'Present' : 'Absent',
        'note': logNotesController.text.trim(),
      };

      await _repository.logStaffAttendance(data);
      AppSnackbar.success('Attendance logged successfully');

      // Refresh logs
      fetchGlobalAttendance(page: 1);

      // If we are on a specific staff's profile, refresh their attendance too
      if (selectedStaff.value?.id == selectedLogStaff.value!.id) {
        fetchAttendanceHistory(page: 1);
      }

      // Robust navigation: go back to StaffMainScreen and set tab to Attendance
      Get.until((route) => Get.currentRoute == AppRoutes.instituteStaffs);
      currentTabIndex.value = 1;
      fetchGlobalAttendance(page: 1); // Refresh logs to show new entry

      // Reset state
      selectedLogStaff.value = null;
      logNotesController.clear();
    } catch (e) {
      AppSnackbar.error('Failed to log attendance: $e');
    } finally {
      isSaving.value = false;
    }
  }

  void nextMonth() {
    selectedAttendanceMonth.value = DateTime(
      selectedAttendanceMonth.value.year,
      selectedAttendanceMonth.value.month + 1,
    );
    fetchAttendanceHistory(page: 1);
  }

  void previousMonth() {
    selectedAttendanceMonth.value = DateTime(
      selectedAttendanceMonth.value.year,
      selectedAttendanceMonth.value.month - 1,
    );
    fetchAttendanceHistory(page: 1);
  }

  // Local searching for Log/Add screens
  void searchLogStaff(String query) {
    logSearchQuery.value = query;
    if (query.isEmpty) {
      filteredLogStaffs.clear();
    } else {
      filteredLogStaffs.assignAll(
        staffList.where(
          (s) =>
              s.fullName.toLowerCase().contains(query.toLowerCase()) ||
              (s.role?.name ?? "").toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  void searchSalaryStaff(String query) {
    salarySearchQuery.value = query;
    if (query.isEmpty) {
      filteredSalaryStaffs.clear();
    } else {
      filteredSalaryStaffs.assignAll(
        staffList.where(
          (s) =>
              s.fullName.toLowerCase().contains(query.toLowerCase()) ||
              (s.role?.name ?? "").toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  void selectLogDate(DateTime date) => selectedLogDate.value = date;
  void toggleStatus(bool present) => isPresent.value = present;
  void setLogStaff(Staff staff) {
    selectedLogStaff.value = staff;
    logSearchQuery.value = '';
    filteredLogStaffs.clear();
  }

  void removeLogStaff() => selectedLogStaff.value = null;

  void selectSalaryMonth(DateTime date) => selectedSalaryMonth.value = date;
  void setSalaryStaff(Staff staff) {
    selectedAddSalaryStaff.value = staff;
    salarySearchQuery.value = '';
    filteredSalaryStaffs.clear();
    salaryAmountController.text = staff.baseSalary;
  }

  void removeSalaryStaff() => selectedAddSalaryStaff.value = null;
  void selectSalaryDate(DateTime date) => selectedSalaryDate.value = date;
  void togglePaymentMethod(bool isOnline) => isOnlinePayment.value = isOnline;

  Future<void> loadMoreStaff() async {
    if (currentPage.value < lastPage.value && !isLoading.value) {
      await fetchStaffs(page: currentPage.value + 1);
    }
  }

  Future<void> saveStaff() async {
    if (!addStaffFormKey.currentState!.validate()) return;
    if (selectedRoleId.value == null || selectedDepartmentId.value == null) {
      AppSnackbar.error('Please select both role and department');
      return;
    }

    try {
      isSaving.value = true;
      final data = {
        'full_name': staffNameController.text.trim(),
        'email': staffEmailController.text.trim(),
        'phone': staffPhoneController.text.trim(),
        'staff_role_id': selectedRoleId.value.toString(),
        'staff_department_id': selectedDepartmentId.value.toString(),
        'employment_type': employmentType.value,
        'base_salary': staffSalaryController.text.trim(),
      };

      if (selectedStaff.value != null) {
        final updated = await _repository.updateStaff(
          selectedStaff.value!.id,
          data,
          selectedImagePath.value,
        );
        int index = staffList.indexWhere((s) => s.id == updated.id);
        if (index != -1) staffList[index] = updated;
        selectedStaff.value = updated;
        AppSnackbar.success('Staff updated successfully');

        Get.until((route) => route.settings.name == AppRoutes.instituteStaffs);
      } else {
        final created = await _repository.createStaff(
          data,
          selectedImagePath.value,
        );
        staffList.insert(0, created);
        AppSnackbar.success('Staff created successfully');
        Get.back();
      }
    } catch (e) {
      AppSnackbar.error('Failed to save staff: $e');
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteStaff(int id) async {
    try {
      isLoading.value = true;
      await _repository.deleteStaff(id);
      staffList.removeWhere((s) => s.id == id);
      AppSnackbar.success('Staff deleted successfully');

      if (Get.currentRoute == AppRoutes.instituteStaffDetails) {
        Get.back();
      }
    } catch (e) {
      AppSnackbar.error('Failed to delete staff: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void clearStaffForm() {
    staffNameController.clear();
    staffEmailController.clear();
    staffPhoneController.clear();
    staffSalaryController.clear();
    selectedRoleId.value = null;
    selectedDepartmentId.value = null;
    employmentType.value = 'Salary';
    selectedImagePath.value = null;
    selectedStaff.value = null;
  }

  void loadStaffForEdit(Staff staff) {
    selectedStaff.value = staff;
    staffNameController.text = staff.fullName;
    staffEmailController.text = staff.email;
    staffPhoneController.text = staff.phone;
    staffSalaryController.text = staff.baseSalary;
    selectedRoleId.value = staff.staffRoleId;
    selectedDepartmentId.value = staff.staffDepartmentId;
    employmentType.value = staff.employmentType;
    selectedImagePath.value = null;
  }

  void selectStaff(Staff staff) {
    selectedStaff.value = staff;
    fetchSalaryHistory(page: 1);
    fetchAttendanceHistory(page: 1);
  }

  void prepareForAdd() => clearStaffForm();

  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 800,
      );
      if (image != null) selectedImagePath.value = image.path;
    } catch (e) {
      AppSnackbar.error('Could not pick image: $e');
    }
  }

  void showImagePickerSourceSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: AppSpacing.all32,
        decoration: const BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.camera_alt_rounded,
                color: AppColors.primaryBrand,
              ),
              title: Text(
                'Camera',
                style: AppTextStyles.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onTap: () {
                Get.back();
                pickImage(ImageSource.camera);
              },
            ),
            AppSpacing.v8,
            ListTile(
              leading: const Icon(
                Icons.photo_library_rounded,
                color: AppColors.primaryBrand,
              ),
              title: Text(
                'Gallery',
                style: AppTextStyles.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
            AppSpacing.v16,
          ],
        ),
      ),
    );
  }

  @override
  void onClose() {
    staffNameController.dispose();
    staffEmailController.dispose();
    staffPhoneController.dispose();
    staffSalaryController.dispose();
    salaryAmountController.dispose();
    salaryNotesController.dispose();
    logNotesController.dispose();
    super.onClose();
  }
}
