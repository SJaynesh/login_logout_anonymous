import 'package:firebase_auth/firebase_auth.dart';

class SingUpModel {
  bool isNotRepert;
  User? user;

  SingUpModel({
    required this.isNotRepert,
    required this.user,
  });
}
