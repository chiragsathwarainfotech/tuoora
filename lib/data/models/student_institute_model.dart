class StudentInstituteModel {
  final int id;
  final String name;
  final String initials;
  final String? logoUrl;
  final String contactPerson;
  final String phone;
  final String? email;
  final String? website;
  final InstituteLocation location;
  final InstituteSocial social;

  /// Payee VPA (e.g. `merchant@bank`). Surfaced on the student Pay Fees
  /// screen so the student can copy it / type it into their UPI app.
  final String? upiId;

  /// Hosted QR-code PNG/JPG the institute uploaded; null when the
  /// institute hasn't configured payments yet.
  final String? upiQrCodeUrl;

  StudentInstituteModel({
    required this.id,
    required this.name,
    required this.initials,
    this.logoUrl,
    required this.contactPerson,
    required this.phone,
    this.email,
    this.website,
    required this.location,
    required this.social,
    this.upiId,
    this.upiQrCodeUrl,
  });

  /// Convenience: true when the institute has configured at least the
  /// QR code (the backend currently requires QR; UPI ID is optional).
  bool get hasUpiPayment =>
      (upiQrCodeUrl != null && upiQrCodeUrl!.isNotEmpty) ||
      (upiId != null && upiId!.isNotEmpty);

  factory StudentInstituteModel.fromJson(Map<String, dynamic> json) {
    return StudentInstituteModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      initials: json['initials'] ?? '',
      logoUrl: json['logo_url'],
      contactPerson: json['contact_person'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'],
      website: json['website'],
      location: InstituteLocation.fromJson(json['location'] ?? {}),
      social: InstituteSocial.fromJson(json['social'] ?? {}),
      upiId: json['upi_id']?.toString(),
      upiQrCodeUrl: json['upi_qr_code_url']?.toString(),
    );
  }
}

class InstituteLocation {
  final String? address;
  final String? address2;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;
  final String? fullAddress;

  InstituteLocation({
    this.address,
    this.address2,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.fullAddress,
  });

  factory InstituteLocation.fromJson(Map<String, dynamic> json) {
    return InstituteLocation(
      address: json['address'],
      address2: json['address_2'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      pincode: json['pincode'],
      fullAddress: json['full_address'],
    );
  }
}

class InstituteSocial {
  final String? youtube;
  final String? instagram;

  InstituteSocial({
    this.youtube,
    this.instagram,
  });

  factory InstituteSocial.fromJson(Map<String, dynamic> json) {
    return InstituteSocial(
      youtube: json['youtube'],
      instagram: json['instagram'],
    );
  }
}
