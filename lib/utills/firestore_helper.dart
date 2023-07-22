import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:signin_singout_anonymous/utills/firebaseHelper.dart';

class FirestoreHelper {
  FirestoreHelper._();

  static final FirestoreHelper firestoreHelper = FirestoreHelper._();

  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<bool> userExits() async {
    return (await db
            .collection('users')
            .doc(FirebaseHelper.firebaseAuth.currentUser!.uid)
            .get())
        .exists;
  }

  //todo: Insert user while sing in
  insertUserWhileSingIn({required Map<String, dynamic> data}) async {
    // DocumentReference docRef = await db.collection("users").add(data);
    //
    // String docId = docRef.id;
    //
    // print("======================");
    // print("Doc ID : ${docId}");
    // print("======================");

    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await db.collection("records").doc("users").get();

    Map<String, dynamic> res = docSnapshot.data() as Map<String, dynamic>;

    print("*******************");
    int id = res['id'];
    int length = res['length'];

    print(id);
    print(length);
    print("*******************");

    await db.collection("users").doc("${++id}").set(data);

    await db
        .collection("records")
        .doc("users")
        .update({"id": id, "length": ++length});
  }

//todo: display all users
  Stream displayAllUsers() {
    Stream<QuerySnapshot<Map<String, dynamic>>> userStream =
        db.collection("users").snapshots();

    return userStream;
  }

  //todo:send chat message
  Future<void> sendChatMessage(
      {required String msg, required String id}) async {
    await db.collection("users").doc(id).collection("chat").add({
      "messge": msg,
      "timestamp": FieldValue.serverTimestamp(),
    });
  }

  //todo: display chat message
  Stream<QuerySnapshot<Map<String, dynamic>>> displayChatMessage(
      {required String id}) {
    return db
        .collection("users")
        .doc(id)
        .collection("chat")
        .orderBy("timestamp", descending: true)
        .snapshots();
  }
}
