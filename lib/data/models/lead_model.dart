import 'package:fee_easy/core/constants/app_strings.dart';

class Lead {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String course;
  final String appliedDate;
  final String status;
  final String? address;
  final String? reference;
  final String? notes;
  final List<InteractionHistory>? interactionHistory;

  Lead({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.course,
    required this.appliedDate,
    required this.status,
    this.address,
    this.reference,
    this.notes,
    this.interactionHistory,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      course: json['course'] ?? '',
      appliedDate: json['applied_date'] ?? '',
      status: json['status'] ?? AppStrings.instActiveProspectTag,
      address: json['address'],
      reference: json['reference'],
      notes: json['notes'],
      interactionHistory: json['interaction_history'] != null
          ? (json['interaction_history'] as List)
              .map((i) => InteractionHistory.fromJson(i))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'course': course,
      'applied_date': appliedDate,
      'status': status,
      'address': address,
      'reference': reference,
      'notes': notes,
      'interaction_history': interactionHistory?.map((i) => i.toJson()).toList(),
    };
  }

  Lead copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? course,
    String? appliedDate,
    String? status,
    String? address,
    String? reference,
    String? notes,
    List<InteractionHistory>? interactionHistory,
  }) {
    return Lead(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      course: course ?? this.course,
      appliedDate: appliedDate ?? this.appliedDate,
      status: status ?? this.status,
      address: address ?? this.address,
      reference: reference ?? this.reference,
      notes: notes ?? this.notes,
      interactionHistory: interactionHistory ?? this.interactionHistory,
    );
  }
}

class InteractionHistory {
  final String title;
  final String description;
  final String date;

  InteractionHistory({
    required this.title,
    required this.description,
    required this.date,
  });

  factory InteractionHistory.fromJson(Map<String, dynamic> json) {
    return InteractionHistory(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date,
    };
  }
}
