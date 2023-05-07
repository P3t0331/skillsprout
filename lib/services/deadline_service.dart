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

  Future<void> createDeadline(
      {required String title,
      required DateTime date,
      required String code,
      required String authorId,
      String description = ""}) async {
    var subject = await _subjectService.getSubjectByCode(code);
    var deadline = Deadline(
        title: title,
        date: date,
        subjectRef: subject!.id,
        description: description,
        authorId: authorId);
    DocumentReference ref = await _deadlineCollection.add(deadline);
    await subject.update({
      'deadlineIds': FieldValue.arrayUnion([ref.id])
    });
  }

  Future<void> updateDeadline(
      {required String deadlineId,
      required String title,
      required DateTime date,
      required String code,
      required String description}) async {
    var subject = await _subjectService.getSubjectByCode(code);
    _deadlineCollection.doc(deadlineId).update({
      'title': title,
      'date': date,
      'description': description,
      'subjectRef': subject!.id,
      'upvoteIds': [],
      'downvoteIds': [],
    });
  }

  Stream<List<Deadline>> subjectDeadlineStream({required String subjectId}) {
    return _deadlineCollection
        .where('subjectRef', isEqualTo: subjectId)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((docSnapshot) => docSnapshot.data())
            .toList());
  }

  Future<void> deleteDeadline(Deadline deadline) async {
    var subject = await _subjectService.getSubjectById(deadline.subjectRef);
    await subject.update({
      'deadlineIds': FieldValue.arrayRemove([deadline.id])
    });
    return _deadlineCollection.doc(deadline.id).delete();
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
            'downvoteIds': FieldValue.arrayRemove([uid])
          },
        );
        break;
      default:
        throw Exception("unrecognized vote option");
    }
  }
}
