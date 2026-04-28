import 'package:fee_easy/data/models/institute_profile_model.dart';
import 'package:fee_easy/data/models/whatsapp_settings_model.dart';
import 'package:fee_easy/presentation/institute/models/fee_record.dart';

abstract class InstituteRepositoryImpl {
  Future<InstituteProfile> getProfile();
  Future<void> updateProfile(Map<String, dynamic> data);

  // WhatsApp Settings
  Future<WhatsAppSettings?> getWhatsAppSettings();
  Future<WhatsAppSettings> saveWhatsAppSettings(Map<String, dynamic> data);
  Future<WhatsAppSettings> updateWhatsAppSettings(Map<String, dynamic> data);

  // Password Management
  Future<void> changePassword(Map<String, dynamic> data);

  // Fees Management
  Future<FeeListResponse> listFees({int page = 1});
  Future<FeeRecord> createFee(Map<String, dynamic> data);
  Future<List<int>> exportFees();
}
