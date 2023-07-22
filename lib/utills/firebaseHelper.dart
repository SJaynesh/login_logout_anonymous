import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:signin_singout_anonymous/controllers/user_data_controller.dart';
import 'package:signin_singout_anonymous/utills/firebase_cloud_messaging_helper.dart';
import 'package:signin_singout_anonymous/utills/firestore_helper.dart';

class FirebaseHelper {
  FirebaseHelper._();

  static final FirebaseHelper firebaseHelper = FirebaseHelper._();

  static final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn googleSignIn = GoogleSignIn();

  Map<String, dynamic> data = {};

  //todo: anonymously without try and catch blocks
  // Future<User?> signInAnonymously() async {
  //   UserCredential userCredential = await firebaseAuth.signInAnonymously();
  //
  //   User? user = userCredential.user;
  //
  //   return user;
  // }

  //todo: anonymosly with try and catch blocks
  Future<Map<String, dynamic>> signInAnonymously() async {
    try {
      UserCredential userCredential = await firebaseAuth.signInAnonymously();

      User? user = userCredential.user;

      data['user'] = user;

      Map<String, dynamic> userData = {
        "email": user!.email,
        "uid": user.uid,
        "image":
            "https://image.cnbcfm.com/api/v1/image/107022566-1646098677297-gettyimages-1018280982-AA_17082018_798699.jpeg?v=1646124420",
      };

      await FirestoreHelper.firestoreHelper
          .insertUserWhileSingIn(data: userData);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "admin-restricted-operation":
          data['msg'] = "This service is temporary down";

        default:
          data['msg'] = e.code;
      }
    }
    return data;
  }

  //todo: sing up with email and password without try and catch
  // Future<User?> singUpWithEmailAndPassword(
  //     {required String email, required String password}) async {
  //   UserCredential userCredential = await firebaseAuth
  //       .createUserWithEmailAndPassword(email: email, password: password);
  //
  //   User? user = userCredential.user;
  //   return user;
  // }
  //todo: sing up with email and password with try and catch
  Future<Map<String, dynamic>> singUpWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      data['user'] = user;
      Map<String, dynamic> userData = {
        "email": user!.email,
        "uid": user.uid,
        "image":
            "https://i.pinimg.com/736x/de/59/4e/de594ec09881da3fa66d98384a3c72ff.jpg",
      };

      await FirestoreHelper.firestoreHelper
          .insertUserWhileSingIn(data: userData);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "admin-restricted-operation":
          data['msg'] = "This service is temporary down. ";
        case "weak-password":
          data['msg'] = "Password must be greater then 6 char. ";
        case "email-already-in-use":
          data['msg'] = "User with this email id is already exists. ";
        default:
          data['msg'] = e.code;
      }
    }
    return data;
  }

// todo:singout with email and password without try and catch
//   Future<User?> sinInWithEmailAndPassword(
//       {required String email, required String password}) async {
//     UserCredential userCredential = await firebaseAuth
//         .signInWithEmailAndPassword(email: email, password: password);
//
//     User? user = userCredential.user;
//     return user;
//   }
  Future<Map<String, dynamic>> sinInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      data['user'] = user;

      Map<String, dynamic> userData = {
        "email": user!.email,
        "uid": user.uid,
        "image":
            "https://i.pinimg.com/736x/de/59/4e/de594ec09881da3fa66d98384a3c72ff.jpg",
      };

      await FirestoreHelper.firestoreHelper
          .insertUserWhileSingIn(data: userData);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "admin-restricted-operation":
          data['msg'] = "This service is temporary down.";
        case "wrong-password":
          data['msg'] = "Password is wrog.";
        case "user-not-found":
          data['msg'] = "User does not exists with this email id.";
        case "user-disabled":
          data['msg'] = "User is disabled, contact admin.";
        default:
          data['msg'] = e.code;
      }
    }
    return data;
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);

      UserDataController userDataController = UserDataController();
      String? userToken = await FCMHelper.fcmHelper.fetchToken();
      userDataController.initilization(
        email: firebaseAuth.currentUser!.email!,
        uid: firebaseAuth.currentUser!.uid,
        displayName: firebaseAuth.currentUser!.displayName!,
        photoURI: firebaseAuth.currentUser!.photoURL!,
        token: userToken!,
      );

      User? user = userCredential.user;

      data['user'] = user;

      // Map<String, dynamic> userData = {
      //   "email": user!.email,
      //   "uid": user.uid,
      //   "image": user.photoURL,
      // };
      //
      // await FirestoreHelper.firestoreHelper
      //     .insertUserWhileSingIn(data: userData);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "admin-restricted-operation":
          data['msg'] = "This service is temporary down.";
        default:
          data['msg'] = e.code;
      }
    }
    return data;
  }

  // Sing Out

  Future<void> singOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }
}
