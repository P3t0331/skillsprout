import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deadline_tracker/models/deadline.dart';
import 'package:deadline_tracker/services/subject_service.dart';

import '../models/subject.dart';

class DeadlineService {
  final SubjectService _subjectService;

  DeadlineService(this._subjectService);

  final _deadlineCollection = FirebaseFirestore.instance
      .collection('deadlines')
      .withConverter(fromFirestore: (snapshot, options) {
    final json = snapshot.data() ?? {};
    json['id'] = snapshot.id;
    return Deadline.fromJson(json);
  }, toFirestore: (value, options) {
    final json = value.toJson();
    json.remove('id');
    return json;
  });

  Stream<List<Deadline>> deadlineStream({String orderBy = 'date'}) {
    return _deadlineCollection.orderBy(orderBy).snapshots().map(
        (querySnapshot) => querySnapshot.docs
            .map((docSnapshot) => docSnapshot.data())
            .toList());
  }

  Future<void> createDeadline(Deadline deadline, String code) async {
    DocumentReference ref = await _deadlineCollection.add(deadline);
    var subject = await _subjectService.getSubject(code);
    await subject.update({
      'deadlineIds': FieldValue.arrayUnion([ref.id])
    });
  }

  Future<void> deleteDeadline(String deadlineId) {
    return _deadlineCollection.doc(deadlineId).delete();
  }
}
