import 'package:cloud_firestore/cloud_firestore.dart';
class FirestoreServices {

  //get collection of notes
  final CollectionReference notes = 
  FirebaseFirestore.instance.collection("notes");
  

  // CREATE: add a new note
  Future<void> addNote( String note)  {
    return notes.add({
      "note": note,
      "timestamp": Timestamp.now(), // Lưu thời điểm ghi chú được thêm vào bằng kiểu dữ liệu Timestamp của Firestore, với giá trị là thời gian hiện tại.
    });

  }

  //READ: get a note from database
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream = 
        notes.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

  //UPDATE: update notes given a doc id
  Future<void> updateNote(String docID, String newNote) {
  return notes.doc(docID).update({
    "note": newNote,
    "timestamp": Timestamp.now(), // Cập nhật lại thời gian sửa
  });
}



  //DELETE: delete a notes given a doc id
  Future<void> deleteNote(String docID) {
  return notes.doc(docID).delete();
}

}