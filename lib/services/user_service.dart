import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';

class UserService {
  final _userCollection = FirebaseFirestore.instance
      .collection('users')
      .withConverter(fromFirestore: (snapshot, options) {
    final json = snapshot.data() ?? {};
    json['id'] = snapshot.id;
    return AppUser.fromJson(json);
  }, toFirestore: (value, options) {
    final json = value.toJson();
    json.remove('id');
    return json;
  });

  Stream<List<AppUser>> get subjectStream =>
      _userCollection.snapshots().map((querySnapshot) =>
          querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList());

  Future<void> createUser(AppUser user, String uid) {
    return _userCollection.doc(uid).set(user);
  }

  Future<void> joinSubject(String uid, String subjectId) {
    print("Joining subject with id: ${subjectId} for user ID: ${uid}");
    return _userCollection.doc(uid).update(
      {
        'subjectIds': FieldValue.arrayUnion([subjectId])
      },
    );
  }

  Future<void> leaveSubject(String uid, String subjectId) {
    print("Leaving subject with id: ${subjectId} for user ID: ${uid}");
    return _userCollection.doc(uid).update(
      {
        'subjectIds': FieldValue.arrayRemove([subjectId])
      },
    );
  }

  Stream<bool?> hasJoinedSubject(String uid, String subjectId) async* {
    yield* await _userCollection.doc(uid).snapshots().map(
      (doc) {
        return doc.data()?.subjectIds.contains(subjectId);
      },
    );
  }
}
