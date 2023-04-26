import 'deadline.dart';

class Subject {
  final String name;
  final List<Deadline> deadlines;
  final int requiredVotes;

  Subject(
      {required this.name, required this.deadlines, this.requiredVotes = 3});
}
