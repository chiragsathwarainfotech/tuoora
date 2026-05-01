import 'package:fee_easy/presentation/institute/models/batch_model.dart';
import 'package:fee_easy/presentation/institute/models/attendance_record_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fee_easy/data/repositories_impl/institute_repository_impl.dart';
import 'package:fee_easy/core/constants/app_colors.dart';

class AttendanceStudent {
  final int id;
  final String name;
  final String? profileImageUrl;
  String status; // 'present' or 'absent'

  AttendanceStudent({
    required this.id,
    required this.name,
    this.profileImageUrl,
    this.status = 'present',
  });

  bool get isPresent => status == 'present';

  Map<String, dynamic> toMap() {
    return {
      'student_id': id,
      'status': status,
    };
  }
}

class AttendanceController extends GetxController {
  final InstituteRepositoryImpl _repository;
  
  final selectedDate = DateTime.now().obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  late BatchModel batch;

  final allStudents = <AttendanceStudent>[].obs;
  final filteredStudents = <AttendanceStudent>[].obs;

  AttendanceController(this._repository);

  bool get isToday {
    final now = DateTime.now();
    return selectedDate.value.year == now.year &&
           selectedDate.value.month == now.month &&
           selectedDate.value.day == now.day;
  }

  bool get isPastDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(selectedDate.value.year, selectedDate.value.month, selectedDate.value.day);
    return selected.isBefore(today);
  }

  // Attendance is only editable for today. Past dates are read-only.
  bool get isEditable => isToday; 

  @override
  void onInit() {
    super.onInit();
    batch = Get.arguments;
    
    fetchAttendance();

    // Setup search listener
    debounce(searchQuery, (_) => filterStudents(), time: const Duration(milliseconds: 300));
  }

  String get formattedDate => DateFormat('MMMM dd, yyyy • EEEE').format(selectedDate.value);
  String get apiDate => DateFormat('yyyy-MM-dd').format(selectedDate.value);

  Future<void> fetchAttendance() async {
    try {
      isLoading.value = true;
      final List<AttendanceRecordModel> response = await _repository.getAttendance(apiDate, int.parse(batch.id));
      
      if (response.isNotEmpty) {
        final students = response.map((record) {
          return AttendanceStudent(
            id: record.studentId,
            name: record.studentName,
            profileImageUrl: null, // API doesn't provide it in this endpoint
            status: record.status ?? 'present', // Default to present if not marked
          );
        }).toList();
        allStudents.assignAll(students);
      } else {
        allStudents.clear();
      }
      
      filterStudents();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch attendance: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitAttendance() async {
    try {
      isLoading.value = true;
      final data = {
        'batch_id': int.parse(batch.id),
        'date': apiDate,
        'attendance': allStudents.map((s) => s.toMap()).toList(),
      };
      
      await _repository.markAttendance(data);
      
      Get.back();
      Get.snackbar(
        'Success',
        'Attendance submitted successfully',
        backgroundColor: AppColors.darkGreen,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit attendance: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      fetchAttendance();
    }
  }

  void filterStudents() {
    if (searchQuery.value.isEmpty) {
      filteredStudents.assignAll(allStudents);
    } else {
      filteredStudents.assignAll(
        allStudents.where((s) => 
          s.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          s.id.toString().contains(searchQuery.value)
        ).toList()
      );
    }
  }

  void toggleStatus(AttendanceStudent student, bool isPresent) {
    if (!isEditable) return;
    student.status = isPresent ? 'present' : 'absent';
    allStudents.refresh();
    filterStudents();
  }

  void markAllPresent() {
    if (!isEditable) return;
    for (var s in allStudents) {
      s.status = 'present';
    }
    allStudents.refresh();
    filterStudents();
  }

  void markAllAbsent() {
    if (!isEditable) return;
    for (var s in allStudents) {
      s.status = 'absent';
    }
    allStudents.refresh();
    filterStudents();
  }
}
