import 'package:firebase_messaging/firebase_messaging.dart';

class FCMHelper {

  FCMHelper._();

  static final FCMHelper fcmHelper = FCMHelper._();

  static final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  Future<String?> fetchToken() async{
    print("***** token ******");
    print(firebaseMessaging.getToken());
    print("***** token ******");
    return await firebaseMessaging.getToken();
  }
}