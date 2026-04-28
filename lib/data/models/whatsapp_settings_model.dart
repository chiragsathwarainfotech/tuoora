class WhatsAppSettings {
  final int? id;
  final int? instituteId;
  final String phoneNumber;
  final String accessToken;
  final String phoneNumberId;
  final String businessAccountId;
  final bool isActive;
  final String? lastVerifiedAt;
  final String? createdAt;
  final String? updatedAt;

  WhatsAppSettings({
    this.id,
    this.instituteId,
    required this.phoneNumber,
    required this.accessToken,
    required this.phoneNumberId,
    required this.businessAccountId,
    this.isActive = false,
    this.lastVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory WhatsAppSettings.fromJson(Map<String, dynamic> json) {
    return WhatsAppSettings(
      id: json['id'],
      instituteId: json['institute_id'],
      phoneNumber: json['phone_number']?.toString() ?? '',
      accessToken: json['access_token']?.toString() ?? '',
      phoneNumberId: json['phone_number_id']?.toString() ?? '',
      businessAccountId: json['business_account_id']?.toString() ?? '',
      isActive: json['is_active'] ?? false,
      lastVerifiedAt: json['last_verified_at']?.toString(),
      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'access_token': accessToken,
      'phone_number_id': phoneNumberId,
      'business_account_id': businessAccountId,
    };
  }
}
