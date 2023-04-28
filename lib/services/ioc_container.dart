import 'package:deadline_tracker/services/deadline_service.dart';
import 'package:deadline_tracker/services/subject_service.dart';
import 'package:get_it/get_it.dart';

class IoCContainer {
  const IoCContainer._();

  static void setup() {
    GetIt.I.registerSingleton(SubjectService());
    GetIt.I.registerSingleton(DeadlineService(GetIt.I<SubjectService>()));
  }
}
