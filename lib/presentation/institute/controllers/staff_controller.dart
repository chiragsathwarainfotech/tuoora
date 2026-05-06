import 'package:fee_easy/core/widgets/app_snackbar.dart';
import 'package:fee_easy/data/models/staff_model.dart';
import 'package:fee_easy/data/repositories_impl/staff_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fee_easy/core/theme/app_spacing.dart';
import 'package:fee_easy/core/constants/app_colors.dart';
import 'package:fee_easy/core/constants/app_text_styles.dart';
import 'package:get/get.dart';

class StaffController extends GetxController {
  final StaffRepository _staffRepository;

  StaffController(this._staffRepository);

  final isLoading = false.obs;
  final staffList = <Staff>[].obs;
  final filteredStaffs = <Staff>[].obs;
  final searchQuery = ''.obs;
  final selectedStaff = Rxn<Staff>();
  final selectedImagePath = Rxn<String>();
  
  // Tab index for bottom navigation
  final currentTabIndex = 0.obs;

  // Reactive variables for Add/Edit Staff
  final selectedRole = 'Senior Designer'.obs;
  final selectedDepartment = 'Product'.obs;
  final isSalaryType = true.obs; // true for Salary, false for Hourly
  
  // Attendance Month Navigation
  final selectedAttendanceMonth = DateTime.now().obs;

  void nextMonth() {
    selectedAttendanceMonth.value = DateTime(
      selectedAttendanceMonth.value.year,
      selectedAttendanceMonth.value.month + 1,
    );
  }

  void previousMonth() {
    selectedAttendanceMonth.value = DateTime(
      selectedAttendanceMonth.value.year,
      selectedAttendanceMonth.value.month - 1,
    );
  }

  final roles = [
    'Senior Designer',
    'Product Mgr',
    'Sr. Engineer',
    'Operations',
    'HR Specialist',
    'Sales Lead',
    'QA Analyst',
    'Backend Dev',
    'Accountant',
    'Admin Faculty',
  ];

  final departments = [
    'Product',
    'Design',
    'Engineering',
    'Operations',
    'HR',
    'Sales',
    'Finance',
    'Academic',
  ];

  @override
  void onInit() {
    super.onInit();
    fetchStaffs();
    debounce(searchQuery, (_) => _filterStaffs(), time: const Duration(milliseconds: 300));
  }

  Future<void> fetchStaffs() async {
    try {
      isLoading.value = true;
      final staffs = await _staffRepository.getStaffs();
      staffList.assignAll(staffs);
      _filterStaffs();
    } catch (e) {
      AppSnackbar.error('Failed to load staffs: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _filterStaffs() {
    if (searchQuery.value.isEmpty) {
      filteredStaffs.assignAll(staffList);
    } else {
      final query = searchQuery.value.toLowerCase();
      filteredStaffs.assignAll(
        staffList.where((staff) =>
            staff.name.toLowerCase().contains(query) ||
            staff.role.toLowerCase().contains(query)).toList(),
      );
    }
  }

  void selectStaff(Staff staff) {
    selectedStaff.value = staff;
    selectedRole.value = staff.role;
    selectedDepartment.value = 'Product'; 
    isSalaryType.value = true;
    selectedImagePath.value = null;
  }
  
  void prepareForAdd() {
    selectedStaff.value = null;
    selectedRole.value = roles[0];
    selectedDepartment.value = departments[0];
    isSalaryType.value = true;
    selectedImagePath.value = null;
  }
  
  void changeTab(int index) {
    currentTabIndex.value = index;
  }

  Future<void> pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 800,
      );
      if (image != null) {
        selectedImagePath.value = image.path;
      }
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
                  color: AppColors.textPrimary,
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
                  color: AppColors.textPrimary,
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
}
