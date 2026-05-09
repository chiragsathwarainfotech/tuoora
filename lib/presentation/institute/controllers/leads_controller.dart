import 'package:fee_easy/core/utils/validation_utils.dart';
import 'package:fee_easy/core/widgets/app_snackbar.dart';
import 'package:fee_easy/data/models/lead_model.dart';
import 'package:fee_easy/data/repositories_impl/leads_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadsController extends GetxController {
  final LeadsRepositoryImpl _leadsRepository = Get.find<LeadsRepositoryImpl>();

  final leadsList = <Lead>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;
  final triedToSave = false.obs;

  // Pagination
  final currentPage = 1.obs;
  final lastPage = 1.obs;
  final totalItems = 0.obs;

  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final referenceController = TextEditingController();
  final courseController = TextEditingController();
  final notesController = TextEditingController();
  final noteTitleController = TextEditingController();

  // Field-specific errors
  final nameError = RxnString();
  final phoneError = RxnString();
  final emailError = RxnString();
  final courseError = RxnString();
  final addressError = RxnString();
  final referenceError = RxnString();
  final noteError = RxnString();
  final noteTitleError = RxnString();

  // Selected lead for details/edit
  final selectedLead = Rxn<Lead>();
  final editingLeadId = RxnInt();

  @override
  void onInit() {
    super.onInit();
    fetchLeads();

    // Search debouncing
    debounce(
      searchQuery,
      (_) => fetchLeads(page: 1),
      time: const Duration(milliseconds: 500),
    );

    // Validation listeners
    nameController.addListener(() => _clearError(nameError));
    phoneController.addListener(() => _clearError(phoneError));
    emailController.addListener(() => _clearError(emailError));
    courseController.addListener(() => _clearError(courseError));
    addressController.addListener(() => _clearError(addressError));
    referenceController.addListener(() => _clearError(referenceError));
  }

  void _clearError(RxnString error) {
    if (triedToSave.value && error.value != null) {
      error.value = null;
    }
  }

  Future<void> fetchLeads({int page = 1}) async {
    try {
      if (page == 1) isLoading.value = true;
      final response = await _leadsRepository.getLeads(
        page: page,
        search: searchQuery.value,
      );

      if (page == 1) {
        leadsList.assignAll(response.data);
      } else {
        leadsList.addAll(response.data);
      }

      currentPage.value = response.currentPage;
      lastPage.value = response.lastPage;
      totalItems.value = response.total;
    } catch (e) {
      AppSnackbar.error('Failed to load leads: $e');
    } finally {
      if (page == 1) isLoading.value = false;
    }
  }

  Future<void> loadMoreLeads() async {
    if (currentPage.value < lastPage.value && !isLoading.value) {
      await fetchLeads(page: currentPage.value + 1);
    }
  }

  void prepareForAdd() {
    editingLeadId.value = null;
    selectedLead.value = null;
    _clearForm();
  }

  void prepareForEdit(Lead lead) {
    editingLeadId.value = lead.id;
    selectedLead.value = lead;
    nameController.text = lead.fullName;
    emailController.text = lead.email;
    phoneController.text = lead.phone;
    addressController.text = lead.address ?? '';
    referenceController.text = lead.reference ?? '';
    courseController.text = lead.courseSelection ?? '';

    noteTitleController.clear();
    notesController.clear();

    triedToSave.value = false;
    _resetErrors();
  }

  void _clearForm() {
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    addressController.clear();
    referenceController.clear();
    courseController.clear();
    notesController.clear();
    noteTitleController.clear();
    triedToSave.value = false;
    _resetErrors();
  }

  void _resetErrors() {
    nameError.value = null;
    phoneError.value = null;
    emailError.value = null;
    courseError.value = null;
    addressError.value = null;
    referenceError.value = null;
    noteError.value = null;
    noteTitleError.value = null;
  }

  Future<void> saveLead() async {
    triedToSave.value = true;
    if (!_validateForm()) return;

    try {
      isLoading.value = true;
      final leadData = {
        'full_name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': addressController.text.trim(),
        'reference': referenceController.text.trim(),
        'course_selection': courseController.text.trim(),
      };

      if (editingLeadId.value == null) {
        leadData['title'] = noteTitleController.text.trim();
        leadData['note'] = notesController.text.trim();
        await _leadsRepository.createLead(leadData);
        searchQuery.value = '';
        Get.back();
        AppSnackbar.success('Lead created successfully');
      } else {
        await _leadsRepository.updateLead(editingLeadId.value!, leadData);
        Get.back();
        AppSnackbar.success('Lead updated successfully');
      }
      fetchLeads(page: 1);
    } catch (e) {
      AppSnackbar.error('Failed to save lead: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateForm() {
    bool isValid = true;

    final nErr = ValidationUtils.validateRequired(
      nameController.text,
      'Full Name',
    );
    nameError.value = nErr;
    if (nErr != null) isValid = false;

    final pErr = ValidationUtils.validatePhone(phoneController.text);
    phoneError.value = pErr;
    if (pErr != null) isValid = false;

    final eErr = ValidationUtils.validateEmail(emailController.text);
    emailError.value = eErr;
    if (eErr != null) isValid = false;

    final cErr = ValidationUtils.validateRequired(
      courseController.text,
      'Course',
    );
    courseError.value = cErr;
    if (cErr != null) isValid = false;

    final aErr = ValidationUtils.validateRequired(
      addressController.text,
      'Address',
    );
    addressError.value = aErr;
    if (aErr != null) isValid = false;

    final rErr = ValidationUtils.validateRequired(
      referenceController.text,
      'Reference',
    );
    referenceError.value = rErr;
    if (rErr != null) isValid = false;

    if (editingLeadId.value == null) {
      final ntErr = ValidationUtils.validateRequired(
        noteTitleController.text,
        'Note Title',
      );
      noteTitleError.value = ntErr;
      if (ntErr != null) isValid = false;

      final nCerr = ValidationUtils.validateRequired(
        notesController.text,
        'Note',
      );
      noteError.value = nCerr;
      if (nCerr != null) isValid = false;
    }

    return isValid;
  }

  Future<void> deleteLead(int id) async {
    try {
      isLoading.value = true;
      await _leadsRepository.deleteLead(id);
      leadsList.removeWhere((l) => l.id == id);
      AppSnackbar.success('Lead deleted successfully');
    } catch (e) {
      AppSnackbar.error('Failed to delete lead: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> callLead(String phone) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      AppSnackbar.error('Could not launch dialer for $phone');
    }
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
    noteTitleController.dispose();
    super.onClose();
  }
}
