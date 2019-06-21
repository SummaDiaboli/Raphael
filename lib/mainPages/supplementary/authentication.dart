import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> resetPassword(String email);

  Future<String> updateDisplayName(String displayName);

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Future<String> updateUserEmail(String email);

  Future<void> reloadProfile();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return user.uid;
  }

  Future<void> resetPassword(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<String> updateDisplayName(String displayName) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    UserUpdateInfo updateInfo = UserUpdateInfo();
    updateInfo.displayName = displayName;
    user.updateProfile(updateInfo);
    user.reload();
    _firebaseAuth.currentUser();
    return user.displayName;
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<String> updateUserEmail(String email) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.updateEmail(email);
    return user.email;
  }

  Future<void> reloadProfile() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.reload();
  }
}
