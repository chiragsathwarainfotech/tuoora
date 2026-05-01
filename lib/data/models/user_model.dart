class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String token;
  final String role; // 'INSTITUTE', 'STUDENT', 'PARENT'
  
  // Institute specific
  final String? instituteName;
  final String? logo;
  final String? address;
  
  // Student specific
  final int? instituteId;
  final int? batchId;
  final String? standard;
  final String? idHash;
  
  final String? city;
  final String? state;
  final String? pincode;
  final String? website;
  final String? youtube;
  final String? instagram;
  
  // Parent specific
  final String? relation;

  final bool isProfileSetup;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.token,
    required this.role,
    this.instituteName,
    this.logo,
    this.address,
    this.instituteId,
    this.batchId,
    this.standard,
    this.idHash,
    this.city,
    this.state,
    this.pincode,
    this.website,
    this.youtube,
    this.instagram,
    this.relation,
    this.isProfileSetup = true,
  });

  factory User.fromJson(Map<String, dynamic> json, String token, String role) {
    return User(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      token: token,
      role: role,
      instituteName: json['institute_name'],
      logo: json['logo'],
      address: json['address'],
      instituteId: json['institute_id'],
      batchId: json['batch_id'],
      standard: json['standard'],
      idHash: json['id_hash'],
      city: json['city'],
      state: json['state'],
      pincode: json['pincode'],
      website: json['website'],
      youtube: json['youtube'],
      instagram: json['instagram'],
      relation: json['relation'],
      isProfileSetup: json['is_profile_setup'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'token': token,
      'role': role,
      'institute_name': instituteName,
      'logo': logo,
      'address': address,
      'institute_id': instituteId,
      'batch_id': batchId,
      'standard': standard,
      'id_hash': idHash,
      'city': city,
      'state': state,
      'pincode': pincode,
      'website': website,
      'youtube': youtube,
      'instagram': instagram,
      'relation': relation,
      'is_profile_setup': isProfileSetup,
    };
  }
}
