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

  Stream<List<Subject>> getSubjectsById(List<String> subjectIds) {
    if (subjectIds.isEmpty) {
      return Stream.value([]);
    }
    return _subjectCollection
        .where(FieldPath.documentId, whereIn: subjectIds)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((docSnapshot) => docSnapshot.data())
            .toList());
  }

  Future<DocumentReference?> getSubjectByCode(String code) async {
    return await FirebaseFirestore.instance
        .collection('subjects')
        .where('code', isEqualTo: code)
        .limit(1)
        .get()
        .then((QuerySnapshot snapshot) {
      if (snapshot.docs.length > 0) {
        return snapshot.docs[0].reference;
      } else {
        return null;
      }
    });
  }

  Future<DocumentReference> getSubjectById(String id) async {
    return await FirebaseFirestore.instance
        .collection('subjects')
        .doc(id)
        .get()
        .then((DocumentSnapshot snapshot) {
      return snapshot.reference;
    });
  }

  Future<Subject> getSubjectObjectById(String id) async {
    return await _subjectCollection
        .doc(id)
        .get()
        .then((querySnapshot) => querySnapshot.data()!);
  }

  Future<void> createSubject(Subject subject) {
    return _subjectCollection.add(subject);
  }

  Future<void> deleteSubject(String subjectId) async {
    // Delete subject's deadlines
    final querySnapshot = await FirebaseFirestore.instance
        .collection("deadlines")
        .where("subjectRef", isEqualTo: subjectId)
        .get();
    final batch = FirebaseFirestore.instance.batch();
    for (final doc in querySnapshot.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();

    // Delete subjectID from user's registered subjects
    final snapshot =
        await await FirebaseFirestore.instance.collection("users").get();
    for (final doc in snapshot.docs) {
      await doc.reference.update(
        {
          "subjectIds": FieldValue.arrayRemove([subjectId])
        },
      );
    }

    // Delete subject
    return _subjectCollection.doc(subjectId).delete();
  }

  Future<void> changeSubjectMemberCount(String subjectId, int value) {
    return _subjectCollection
        .doc(subjectId)
        .update({'memberCount': FieldValue.increment(value)});
  }

  Future<void> changeSubjectRequiredVotes(String subjectId, int value) {
    return _subjectCollection.doc(subjectId).update({'requiredVotes': value});
  }
}
