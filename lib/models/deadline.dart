class Deadline {
  final String title;
  final DateTime date;
  final String description;
  final List<String> upvoteIds;
  final List<String> downvoteIds;

  Deadline(
      {required this.title,
      required this.date,
      this.description = "",
      this.upvoteIds = const [],
      this.downvoteIds = const []});
}
