import 'package:fee_easy/data/models/lead_model.dart';

class LeadsRepositoryImpl {
  // Simulating data for now. In a real app, this would call an API.
  final List<Lead> _mockLeads = [
    Lead(
      id: '1',
      name: 'Jane Doe',
      email: 'jane.doe@example.com',
      phone: '+1 (555) 123-4567',
      course: 'UX Design Masterclass',
      appliedDate: 'April 20, 2026',
      status: 'ACTIVE PROSPECT',
      address: '123 Business Way, Suite 100, City, State 12345',
      reference: 'LinkedIn Ad Campaign',
      notes: 'Interested in the Figma token workflow.',
      interactionHistory: [
        InteractionHistory(
          title: 'Initial Screening Call',
          description:
              'Discussed course syllabus and career goals. Jane is very interested in the Figma token workflow.',
          date: 'TODAY',
        ),
      ],
    ),
    Lead(
      id: '2',
      name: 'Marcus Smith',
      email: 'marcus.smith@example.com',
      phone: '+1 (555) 987-6543',
      course: 'Full Stack Development',
      appliedDate: 'April 19, 2026',
      status: 'ACTIVE PROSPECT',
    ),
    Lead(
      id: '3',
      name: 'Alex Lawson',
      email: 'alex.lawson@example.com',
      phone: '+1 (555) 456-7890',
      course: 'Digital Marketing Pro',
      appliedDate: 'April 18, 2026',
      status: 'ACTIVE PROSPECT',
    ),
    Lead(
      id: '4',
      name: 'Kelly White',
      email: 'kelly.white@example.com',
      phone: '+1 (555) 111-2222',
      course: 'Python for Analytics',
      appliedDate: 'April 17, 2026',
      status: 'ACTIVE PROSPECT',
    ),
    Lead(
      id: '5',
      name: 'Robert Brown',
      email: 'robert.b@example.com',
      phone: '+1 (555) 222-3333',
      course: 'Cybersecurity Basics',
      appliedDate: 'April 16, 2026',
      status: 'ACTIVE PROSPECT',
    ),
    Lead(
      id: '6',
      name: 'Sarah Connor',
      email: 's.connor@example.com',
      phone: '+1 (555) 444-5555',
      course: 'AI & Machine Learning',
      appliedDate: 'April 15, 2026',
      status: 'ACTIVE PROSPECT',
    ),
    Lead(
      id: '7',
      name: 'John Wick',
      email: 'j.wick@example.com',
      phone: '+1 (555) 666-7777',
      course: 'Advanced Java',
      appliedDate: 'April 14, 2026',
      status: 'ACTIVE PROSPECT',
    ),
    Lead(
      id: '8',
      name: 'Emma Watson',
      email: 'emma.w@example.com',
      phone: '+1 (555) 888-9999',
      course: 'React Native Development',
      appliedDate: 'April 13, 2026',
      status: 'ACTIVE PROSPECT',
    ),
  ];

  Future<List<Lead>> getLeads() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockLeads;
  }

  Future<Lead> getLeadById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockLeads.firstWhere((l) => l.id == id);
  }

  Future<void> createLead(Map<String, dynamic> leadData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newLead = Lead.fromJson({
      ...leadData,
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'applied_date': 'Today',
      'status': 'ACTIVE PROSPECT',
    });
    _mockLeads.insert(0, newLead);
  }

  Future<void> updateLead(String id, Map<String, dynamic> leadData) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _mockLeads.indexWhere((l) => l.id == id);
    if (index != -1) {
      _mockLeads[index] = _mockLeads[index].copyWith(
        name: leadData['name'],
        email: leadData['email'],
        phone: leadData['phone'],
        course: leadData['course'],
        address: leadData['address'],
        reference: leadData['reference'],
        notes: leadData['notes'],
      );
    }
  }

  Future<void> deleteLead(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _mockLeads.removeWhere((l) => l.id == id);
  }
}
