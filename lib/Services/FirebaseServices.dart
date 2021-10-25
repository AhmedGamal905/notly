import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notly/Helpers/Authentication.dart';

class FirebaseServices {
  final _userUid = Auth().getUser().uid;
  final firestoreInstance = FirebaseFirestore.instance;

  Stream getUserNotes() {
    return firestoreInstance
        .collection('data')
        .doc(_userUid)
        .collection('notes')
        .snapshots();
  }

  Future<void> addUserNote(Map note) {
    return firestoreInstance
        .collection("data")
        .doc(_userUid)
        .collection("notes")
        .doc()
        .set(note);
  }

  Future<void> updateUserNote(Map note, String id) {
    return firestoreInstance
        .collection("data")
        .doc(_userUid)
        .collection("notes")
        .doc(id)
        .update(note);
  }

  Future<void> removeUserNote(String id) {
    return firestoreInstance
        .collection("data")
        .doc(_userUid)
        .collection("notes")
        .doc(id)
        .delete();
  }
}
