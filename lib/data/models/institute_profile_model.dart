class InstituteProfile {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? instituteName;
  final String? address;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? country;
  final String? pincode;
  final String? website;
  final String? youtube;
  final String? instagram;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? logoUrl;

  InstituteProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.instituteName,
    this.address,
    this.addressLine2,
    this.city,
    this.state,
    this.country,
    this.pincode,
    this.website,
    this.youtube,
    this.instagram,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.logoUrl,
  });

  factory InstituteProfile.fromJson(Map<String, dynamic> json) {
    return InstituteProfile(
      id: json['id'],
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      instituteName: json['institute_name']?.toString(),
      address: json['address']?.toString(),
      addressLine2: json['address_line_2']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      country: json['country']?.toString(),
      pincode: json['pincode']?.toString(),
      website: json['website']?.toString(),
      youtube: json['youtube']?.toString(),
      instagram: json['instagram']?.toString(),
      status: json['status']?.toString() ?? 'active',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
      logoUrl: json['logo_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'institute_name': instituteName,
      'address': address,
      'address_line_2': addressLine2,
      'city': city,
      'state': state,
      'country': country,
      'pincode': pincode,
      'website': website,
      'youtube': youtube,
      'instagram': instagram,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'logo_url': logoUrl,
    };
  }
}

