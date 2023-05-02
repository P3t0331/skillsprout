import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(DateTime date) {
    return DateFormat('E, d MMM yyyy HH:mm').format(date);
  }
}
