import 'package:fee_easy/core/widgets/app_snackbar.dart';
import 'package:fee_easy/data/models/lead_model.dart';
import 'package:fee_easy/data/repositories_impl/leads_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeadsController extends GetxController {
  final LeadsRepositoryImpl _leadsRepository = Get.find<LeadsRepositoryImpl>();

  final leadsList = <Lead>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final triedToSave = false.obs;

  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final referenceController = TextEditingController();
  final courseController = TextEditingController();
  final notesController = TextEditingController();

  // Selected lead for details/edit
  final selectedLead = Rxn<Lead>();
  final editingLeadId = RxnString();

  @override
  void onInit() {
    super.onInit();
    fetchLeads();
  }

  Future<void> fetchLeads() async {
    try {
      isLoading.value = true;
      final leads = await _leadsRepository.getLeads();
      leadsList.assignAll(leads);
    } catch (e) {
      AppSnackbar.error('Failed to load leads: $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<Lead> get filteredLeads {
    List<Lead> filtered = leadsList;

    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      filtered = filtered.where((lead) {
        return lead.name.toLowerCase().contains(query) ||
            lead.course.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }

  void prepareForAdd() {
    editingLeadId.value = null;
    selectedLead.value = null;
    _clearForm();
  }

  void prepareForEdit(Lead lead) {
    editingLeadId.value = lead.id;
    selectedLead.value = lead;
    nameController.text = lead.name;
    emailController.text = lead.email;
    phoneController.text = lead.phone;
    addressController.text = lead.address ?? '';
    referenceController.text = lead.reference ?? '';
    courseController.text = lead.course;
    notesController.text = lead.notes ?? '';
    triedToSave.value = false;
  }

  void _clearForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
    referenceController.clear();
    courseController.clear();
    notesController.clear();
    triedToSave.value = false;
  }

  Future<void> saveLead() async {
    triedToSave.value = true;
    if (!_validateForm()) return;

    try {
      isLoading.value = true;
      final leadData = {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'reference': referenceController.text.trim(),
        'course': courseController.text.trim(),
        'notes': notesController.text.trim(),
      };

      if (editingLeadId.value != null) {
        await _leadsRepository.updateLead(editingLeadId.value!, leadData);
        AppSnackbar.success('Lead updated successfully');
      } else {
        await _leadsRepository.createLead(leadData);
        AppSnackbar.success('Lead added successfully');
      }

      fetchLeads();
      Get.back();
    } catch (e) {
      AppSnackbar.error('Failed to save lead: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateForm() {
    return nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        courseController.text.isNotEmpty;
  }

  Future<void> deleteLead(String id) async {
    try {
      await _leadsRepository.deleteLead(id);
      leadsList.removeWhere((l) => l.id == id);
      AppSnackbar.success('Lead deleted successfully');
    } catch (e) {
      AppSnackbar.error('Failed to delete lead: $e');
    }
  }

  void callLead(String phone) {
    AppSnackbar.success('Initiating call to $phone');
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    referenceController.dispose();
    courseController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
