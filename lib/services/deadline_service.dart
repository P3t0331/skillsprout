import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deadline_tracker/models/deadline.dart';
import 'package:deadline_tracker/services/subject_service.dart';

import '../models/vote.dart';

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

  Stream<List<Deadline>> deadlineStream({String orderBy = 'Date'}) {
    bool descending = false;
    if (orderBy == 'Title') {
      descending = true;
    }
    return _deadlineCollection
        .orderBy(orderBy.toLowerCase(), descending: descending)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((docSnapshot) => docSnapshot.data())
            .toList());
  }

  Future<String> getDeadlineId(Deadline deadline) {
    return _deadlineCollection
        .where('title', isEqualTo: deadline.title)
        .where('description', isEqualTo: deadline.description)
        .where('date', isEqualTo: deadline.date)
        .get()
        .then((querySnapshot) {
      return querySnapshot.docs.first.id;
    });
  }

  Future<void> createDeadline(
      {required String title,
      required DateTime date,
      required String code,
      String description = ""}) async {
    var subject = await _subjectService.getSubject(code);
    var deadline = Deadline(
        title: title,
        date: date,
        subjectRef: subject.id,
        description: description);
    DocumentReference ref = await _deadlineCollection.add(deadline);
    await subject.update({
      'deadlineIds': FieldValue.arrayUnion([ref.id])
    });
  }

  Stream<List<Deadline>> subjectDeadlineStream(
      {required String subjectCode}) async* {
    var subjectId = (await _subjectService.getSubject(subjectCode)).id;
    yield* _deadlineCollection
        .where('subjectRef', isEqualTo: subjectId)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((docSnapshot) => docSnapshot.data())
            .toList());
  }

  Future<void> deleteDeadline(String deadlineId) {
    return _deadlineCollection.doc(deadlineId).delete();
  }

  Stream<Vote> getUserVote(String deadlineId, String uid) async* {
    final snapshot = await _deadlineCollection.doc(deadlineId).get();
    if (snapshot.get('upvoteIds').contains(uid)) {
      yield Vote.upvote;
    } else if (snapshot.get('downvoteIds').contains(uid)) {
      yield Vote.downvote;
    } else {
      yield Vote.none;
    }
  }

  Future<void> changeVote(String uid, String deadlineId, Vote vote) async {
    switch (vote) {
      case Vote.upvote:
        await _deadlineCollection.doc(deadlineId).update(
          {
            'upvoteIds': FieldValue.arrayUnion([uid])
          },
        );
        await _deadlineCollection.doc(deadlineId).update(
          {
            'downvoteIds': FieldValue.arrayRemove([uid])
          },
        );
        break;
      case Vote.downvote:
        await _deadlineCollection.doc(deadlineId).update(
          {
            'downvoteIds': FieldValue.arrayUnion([uid])
          },
        );
        await _deadlineCollection.doc(deadlineId).update(
          {
            'upvoteIds': FieldValue.arrayRemove([uid])
          },
        );
        break;
      case Vote.none:
        await _deadlineCollection.doc(deadlineId).update(
          {
            'upvoteIds': FieldValue.arrayRemove([uid])
          },
        );
        await _deadlineCollection.doc(deadlineId).update(
          {
            'downvote': FieldValue.arrayRemove([uid])
          },
        );
        break;
      default:
        throw Exception("unrecognized vote option");
    }
  }
}
