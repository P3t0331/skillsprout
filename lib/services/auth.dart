import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deadline_tracker/main.dart';
import 'package:deadline_tracker/models/app_user.dart';
import 'package:deadline_tracker/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final UserService _userService;

  Auth(this._userService);

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> createUserWithEmailAndPassword(
      {required String email,
      required String password,
      required String name}) async {
    await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((userCredential) {
      // Add user to Firestore database
      User fireBaseUser = userCredential.user!;
      AppUser user = AppUser(name: name, email: fireBaseUser.email!);
      _userService.createUser(user, fireBaseUser.uid);
    });
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
