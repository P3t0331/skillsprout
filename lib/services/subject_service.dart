import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deadline_tracker/models/subject.dart';

class SubjectService {
  final _subjectCollection = FirebaseFirestore.instance
      .collection('subjects')
      .withConverter(fromFirestore: (snapshot, options) {
    final json = snapshot.data() ?? {};
    json['id'] = snapshot.id;
    return Subject.fromJson(json);
  }, toFirestore: (value, options) {
    final json = value.toJson();
    json.remove('id');
    return json;
  });

  Stream<List<Subject>> get subjectStream =>
      _subjectCollection.snapshots().map((querySnapshot) =>
          querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());

  Stream<List<Subject>> subjectStreamByName(String name) {
    return _subjectCollection
        .where('name', isLessThanOrEqualTo: name)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((docSnapshot) => docSnapshot.data())
            .toList());
  }

  Future<List<Subject>> getSubjectsById(List<String> subjectIds) async {
    final querySnapshot = await _subjectCollection
        .where(FieldPath.documentId, whereIn: subjectIds)
        .get();
    return querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  Future<DocumentReference> getSubject(String code) async {
    return await FirebaseFirestore.instance
        .collection('subjects')
        .where('code', isEqualTo: code)
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
      return snapshot.docs[0].reference;
    });
  }

  Stream<bool> subjectAlreadyExists(String code) {
    return _subjectCollection.where('code', isEqualTo: code).snapshots().map(
        (querySnapshot) => !querySnapshot.docs
            .map((docSnapshot) => docSnapshot.data())
            .isEmpty);
  }

  Future<void> updateSubjectDeadlineIds(String id, List<String> newIds) {
    return _subjectCollection.doc(id).update({'deadlineIds': newIds});
  }

  Future<void> createSubject(Subject subject) {
    return _subjectCollection.add(subject);
  }

  Future<void> deleteSubject(String subjectId) {
    return _subjectCollection.doc(subjectId).delete();
  }
}
