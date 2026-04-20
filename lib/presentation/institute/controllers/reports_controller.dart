import 'package:get/get.dart';

class ReportsController extends GetxController {
  final defaulters = <Map<String, dynamic>>[
    {
      'name': 'Julian Casablancas',
      'id': 'FE-1024',
      'amount': '₹4,500',
      'daysOverdue': 12,
    },
    {
      'name': 'Albert Hammond',
      'id': 'FE-0982',
      'amount': '₹2,300',
      'daysOverdue': 5,
    },
    {
      'name': 'Fabrizio Moretti',
      'id': 'FE-0871',
      'amount': '₹1,500',
      'daysOverdue': 3,
    },
    {
      'name': 'Nick Valensi',
      'id': 'FE-1102',
      'amount': '₹5,000',
      'daysOverdue': 15,
    },
    {
      'name': 'Nikolai Fraiture',
      'id': 'FE-1005',
      'amount': '₹3,200',
      'daysOverdue': 8,
    },
  ].obs;
}
