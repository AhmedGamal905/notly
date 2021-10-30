import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> signUp(String email, String password) async {
    UserCredential authResult = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return authResult;
  }

  Future<UserCredential> signIn(String email, String password) async {
    UserCredential authResult = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return authResult;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  User getUser() {
    try {
      return FirebaseAuth.instance.currentUser;
    } on FirebaseAuthException {
      return null;
    }
  }
}
