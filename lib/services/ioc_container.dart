import 'package:deadline_tracker/services/deadline_service.dart';
import 'package:deadline_tracker/services/subject_service.dart';
import 'package:deadline_tracker/services/user_service.dart';
import 'package:get_it/get_it.dart';

import 'auth.dart';

class IoCContainer {
  const IoCContainer._();

  static void setup() {
    GetIt.I.registerSingleton(SubjectService());
    GetIt.I.registerSingleton(DeadlineService(GetIt.I<SubjectService>()));
    GetIt.I.registerSingleton(UserService(GetIt.I<SubjectService>()));
    GetIt.I.registerSingleton(Auth(GetIt.I<UserService>()));
  }
}
