import 'package:intl/intl.dart';

/// Shared date-string helpers so different screens render the same date
/// the same way (e.g. homework due dates show "Today" / "Tomorrow" /
/// "May 30, 2026" consistently).
class DateFormatUtils {
  DateFormatUtils._();

  /// Returns the display label for a homework due date.
  ///
  /// - Closed (`isActive == false`) homework → "Ended MMM dd, yyyy".
  /// - Active homework due today → "Due Today".
  /// - Active homework due tomorrow → "Due Tomorrow".
  /// - Active homework due 2+ days from now (or in the past) → "Due MMM dd, yyyy".
  static String homeworkDueLabel(DateTime dueDate, {required bool isActive}) {
    final dateStr = DateFormat('MMM dd, yyyy').format(dueDate);
    if (!isActive) return 'Ended $dateStr';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    final diff = due.difference(today).inDays;

    if (diff == 0) return 'Due Today';
    if (diff == 1) return 'Due Tomorrow';
    return 'Due $dateStr';
  }

  /// WhatsApp-style chat day separator label: "Today", "Yesterday", or a
  /// formatted date like "12 May 2026" for anything older.
  static String chatDaySeparator(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(date.year, date.month, date.day);
    final diff = today.difference(that).inDays;
    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    return DateFormat('dd MMM yyyy').format(date);
  }

  /// Whether two timestamps fall on different calendar days (used to decide
  /// when to insert a day separator between consecutive chat messages).
  static bool isDifferentDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return a != b;
    return a.year != b.year || a.month != b.month || a.day != b.day;
  }
}
