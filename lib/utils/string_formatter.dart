class StringFormatter {
  static String handlePlural(int value, String text) {
    if (value == 1) {
      return "1 ${text}";
    }
    return "${value} ${text}s";
  }
}
