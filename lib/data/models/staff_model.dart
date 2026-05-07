class Staff {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String role;
  final String department;
  final double salary;
  final String joinDate;
  final String status;
  final String address;
  final String reference;
  final List<StaffInteraction> interactionHistory;

  Staff({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    required this.department,
    required this.salary,
    required this.joinDate,
    required this.status,
    required this.address,
    required this.reference,
    required this.interactionHistory,
  });
}

class StaffInteraction {
  final String title;
  final String description;
  final String date;

  StaffInteraction({
    required this.title,
    required this.description,
    required this.date,
  });
}
