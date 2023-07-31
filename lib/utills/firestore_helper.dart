import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:signin_singout_anonymous/utills/firebaseHelper.dart';
import 'package:signin_singout_anonymous/utills/firebase_cloud_messaging_helper.dart';

class FirestoreHelper {
  FirestoreHelper._();

  static final FirestoreHelper firestoreHelper = FirestoreHelper._();

  static final FirebaseFirestore db = FirebaseFirestore.instance;
  static final User auth = FirebaseAuth.instance.currentUser!;

  Future<bool> userExits() async {
    return (await db
            .collection('users')
            .doc(FirebaseHelper.firebaseAuth.currentUser!.uid)
            .get())
        .exists;
  }

  Future<void> createUser() async {
    Map<String, dynamic> data = {
      'id': auth.uid,
      'name': auth.displayName,
      'image': auth.photoURL,
      'email': auth.email,
      'phone': auth.phoneNumber,
      'phoneUrl': auth.photoURL,
      // 'pushToken' :FCMHelper.fcmHelper.fetchToken().toString(),
    };
    print("===========================");
    print(auth.uid);
    print(auth.displayName);
    print(auth.photoURL);
    print(auth.email);
    print(auth.phoneNumber);
    // print(FCMHelper.fcmHelper.fetchToken().toString());
    print("===========================");

    await db.collection("users").doc(auth.uid).set(data);

    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await db.collection("records").doc("users").get();

    Map<String, dynamic> res = docSnapshot.data() as Map<String, dynamic>;

    print("*******************");
    int id = res['id'];
    int length = res['length'];

    print(id);
    print(length);
    print("*******************");

    await db
        .collection("records")
        .doc("users")
        .update({"id": ++id, "length": ++length});
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

  String getConersationID(String id) => (auth.uid.hashCode <= id.hashCode)
      ? '${auth.uid}_$id'
      : '${id}_${auth.uid}';

//todo: display all users
  Stream displayAllUsers() {
    Stream<QuerySnapshot<Map<String, dynamic>>> userStream =
        db.collection("users").where('id', isNotEqualTo: auth.uid).snapshots();

    print(userStream);

    return userStream;
  }

  //todo:send chat message
  Future<void> sendChatMessage(
      {required String msg,
      required String userId,
      required Map<String, dynamic> user}) async {
    // await db.collection("users").doc(id).collection("chat").add({
    //   "messge": msg,
    //   "timestamp": FieldValue.serverTimestamp(),
    // });
    String id = getConersationID(user['id']);

    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await db.collection("chat_records").doc("chat").get();

    Map<String, dynamic> res = docSnapshot.data() as Map<String, dynamic>;

    int chatId = res['id'];

    print(chatId);

    await db.collection("chat_records").doc("chat").update({"id": ++chatId});

    Map<String, dynamic> message = {
      'msg': msg,
      'fromId': auth.uid,
      'toId': user['id'],
      'sent':
          "${TimeOfDay.now().hour}:${TimeOfDay.now().minute} ${(TimeOfDay.now().periodOffset == 0) ? 'am' : 'pm'}",
      'timestamp': FieldValue.serverTimestamp(),
      'chatId': chatId,
    };

    await db.collection('chat/${id}/messages/').doc(chatId.toString()).set(message);

    // await db.collection('users').doc(userId).collection('chat').add(message);
  }

  //todo: display chat message
  displayChatMessage(
      {required String userId, required Map<String, dynamic> user}) {
    String id = getConersationID(user['id']);

    // return db
    //     .collection("users")
    //     .doc(user['id'])
    //     .collection("chat")
    //     .orderBy("timestamp", descending: true)
    //     .snapshots();
    return db
        .collection('chat/${id}/messages/')
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Future<void> deleteMessage(
      {required Map<String, dynamic> user, required String recordId}) async {
    String id = getConersationID(user['id']);
    await db.collection('chat/${id}/messages/').doc(recordId).delete();
  }
}
