import 'package:get/get.dart';

class StudentStudyMaterialController extends GetxController {
  final selectedSubject = 'All subjects'.obs;
  
  final List<String> subjects = [
    'All subjects',
    'Mathematics',
    'Physics',
    'Chemistry',
  ];

  final List<Map<String, dynamic>> materials = [
    {
      'subject': 'Mathematics',
      'date': 'Today',
      'title': 'Trigonometry — quick reference',
      'description': 'All Class X trig identities, complementary-angle formulas, and sign chart on one page. Print and stick inside your...',
      'fileCount': 1,
      'isVideo': false,
      'teacher': 'Mr. R. Verma',
      'subjectBgColor': 0xFFFEF2F2,
      'subjectTextColor': 0xFF991B1B,
    },
    {
      'subject': 'Physics',
      'date': 'Wed',
      'title': 'Reflection — concept video',
      'description': 'A 6-minute walkthrough of plane mirrors, the angle of incidence/reflection, and image formation. Watch befor...',
      'fileCount': 1,
      'isVideo': true,
      'teacher': 'Mrs. Iyer',
      'subjectBgColor': 0xFFFEF2F2,
      'subjectTextColor': 0xFF991B1B,
    },
    {
      'subject': 'Chemistry',
      'date': '12 May',
      'title': 'Carbon — past year questions',
      'description': 'Compiled questions from the last 5 years\' board papers on carbon and its compounds. Solutions on the last 3...',
      'fileCount': 2,
      'isVideo': false,
      'teacher': 'Mrs. Iyer',
      'subjectBgColor': 0xFFFFF1F2,
      'subjectTextColor': 0xFF9F1239,
    },
    {
      'subject': 'Mathematics',
      'date': '08 May',
      'title': 'Linear equations — extra sums',
      'description': '40 additional problems on linear equations in two variables, sorted easy -> hard.',
      'fileCount': 1,
      'isVideo': false,
      'teacher': 'Mr. R. Verma',
      'subjectBgColor': 0xFFFEF2F2,
      'subjectTextColor': 0xFF991B1B,
    },
  ];

  void selectSubject(String subject) {
    selectedSubject.value = subject;
  }

  List<Map<String, dynamic>> get filteredMaterials {
    if (selectedSubject.value == 'All subjects') {
      return materials;
    }
    return materials.where((m) => m['subject'] == selectedSubject.value).toList();
  }
}
