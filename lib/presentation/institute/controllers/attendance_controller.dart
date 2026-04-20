import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AttendanceController extends GetxController {
  final selectedDate = DateTime.now().obs;
  final searchQuery = ''.obs;
  
  // Mock student list for attendance
  final allStudents = <Map<String, dynamic>>[
    {
      'name': 'Aria Smith',
      'id': 'PHY-2023-001',
      'isPresent': true,
      'avatar': 'https://i.pravatar.cc/150?u=aria',
    },
    {
      'name': 'Julian Chen',
      'id': 'PHY-2023-042',
      'isPresent': true,
      'avatar': 'https://i.pravatar.cc/150?u=julian',
    },
    {
      'name': 'Elena Rodriguez',
      'id': 'PHY-2023-115',
      'isPresent': false,
      'avatar': 'https://i.pravatar.cc/150?u=elena',
    },
    {
      'name': 'Marcus Wright',
      'id': 'PHY-2023-089',
      'isPresent': true,
      'avatar': 'https://i.pravatar.cc/150?u=marcus',
    },
    {
      'name': 'Sarah Jenkins',
      'id': 'PHY-2023-201',
      'isPresent': true,
      'avatar': 'https://i.pravatar.cc/150?u=sarah',
    },
  ].obs;

  final filteredStudents = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    filteredStudents.assignAll(allStudents);
    
    // Setup search listener
    debounce(searchQuery, (_) => filterStudents(), time: const Duration(milliseconds: 300));
  }

  String get formattedDate => DateFormat('MMMM dd, yyyy • EEEE').format(selectedDate.value);
  String get shortDate => DateFormat('dd MMMM yyyy').format(selectedDate.value);

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  void filterStudents() {
    if (searchQuery.value.isEmpty) {
      filteredStudents.assignAll(allStudents);
    } else {
      filteredStudents.assignAll(
        allStudents.where((s) => 
          s['name'].toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          s['id'].toLowerCase().contains(searchQuery.value.toLowerCase())
        ).toList()
      );
    }
  }

  void toggleStatus(Map<String, dynamic> student, bool isPresent) {
    student['isPresent'] = isPresent;
    allStudents.refresh();
    filterStudents();
  }

  void markAllPresent() {
    for (var s in allStudents) {
      s['isPresent'] = true;
    }
    allStudents.refresh();
    filterStudents();
  }
}
