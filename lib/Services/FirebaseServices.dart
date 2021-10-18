import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notly/Helpers/Authentication.dart';
import 'package:notly/Models/NoteModel.dart';

class FirebaseServices {
  final _userUid = Auth().getUser().uid;
  final firestoreInstance = FirebaseFirestore.instance;

  Stream<List<Note>> getUserNotes() {
    return firestoreInstance
        .collection('data')
        .doc(_userUid)
        .collection('notes')
        .snapshots()
        .map((snapShot) =>
            snapShot.docs.map((docs) => Note.fromJson(docs.data())).toList());
  }

  Future<void> addUserNotes(Note note) {
    return firestoreInstance
        .collection("data")
        .doc(_userUid)
        .collection("notes")
        .doc()
        .set(note.toJson());
  }
}
