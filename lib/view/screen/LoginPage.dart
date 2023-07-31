import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:signin_singout_anonymous/controllers/singup_controller.dart';
import 'package:signin_singout_anonymous/utills/firebaseHelper.dart';
import 'package:signin_singout_anonymous/utills/firestore_helper.dart';

import 'package:signin_singout_anonymous/utills/local_notification_helper.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:get/get.dart';

import '../../utills/atributes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> singInKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String email = "";
  String password = "";

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    var androidInitialzationSettings =
        AndroidInitializationSettings("mipmap/ic_launcher");
    var darwinInitialzationSettings = DarwinInitializationSettings();

    var initialzationSettings = InitializationSettings(
      android: androidInitialzationSettings,
      iOS: darwinInitialzationSettings,
    );

    tz.initializeTimeZones();

    LocalNotificationHelper.flutterLocalNotificationsPlugin.initialize(
      initialzationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("===========================");
        print("PAYLOAD : ${response.payload}");
        print("===========================");
      },
    );
  }

  SingupController singupController = Get.put(SingupController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: singInKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      "assets/images/loginPage/login.png",
                      height: heigth * 0.3,
                    ),
                    SizedBox(
                      height: heigth * 0.05,
                    ),
                    TextFormField(
                      controller: emailController,
                      onSaved: (val) {
                        email = val!;
                        setState(() {});
                      },
                      validator: (val) =>
                          val == null ? "Enter the Email" : null,
                      decoration: InputDecoration(
                        hintText: "Enter email..",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        label: Text("Email"),
                        labelStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.blue.shade800,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: heigth * 0.02,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      obscuringCharacter: "*",
                      onSaved: (val) {
                        password = val!;
                        setState(() {});
                      },
                      validator: (val) =>
                          val == null ? "Enter the Password}" : null,
                      decoration: InputDecoration(
                        hintText: "Enter password..",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        label: Text("Password"),
                        labelStyle: TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                            width: 2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.blue.shade800,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: heigth * 0.045,
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (singInKey.currentState!.validate()) {
                          singInKey.currentState!.save();

                          Map<String, dynamic> data = await FirebaseHelper
                              .firebaseHelper
                              .sinInWithEmailAndPassword(
                                  email: email, password: password);

                          if (data['user'] != null) {
                            Get.snackbar(
                              "SING IN",
                              "Sign In Successfully..",
                              backgroundColor: Colors.green,
                            );
                            singupController.getTheUserValue(data: data);
                            Get.offAndToNamed("/HomePage");
                            singupController.changeTheValue();
                          } else {
                            Get.snackbar(
                              "SING IN",
                              data['msg'],
                              backgroundColor: Colors.redAccent,
                            );
                          }
                        }
                        emailController.clear();
                        passwordController.clear();
                      },
                      child: Container(
                        height: heigth * 0.08,
                        width: width,
                        decoration: BoxDecoration(
                          color: Color(0xfffc6b68),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: heigth * 0.02,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: heigth * 0.02,
                    ),
                    Text(
                      "------ Or continue with ------",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: heigth * 0.025,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            Map<String, dynamic> data = await FirebaseHelper
                                .firebaseHelper
                                .signInWithGoogle();

                            if (data['user'] != null) {
                              Get.snackbar(
                                "SING IN",
                                "Sign In Successfully..",
                                backgroundColor: Colors.green,
                              );
                              // singupController.getTheUserValue(data: data);
                              // Get.offAndToNamed("/HomePage");
                              if (await FirestoreHelper.firestoreHelper
                                  .userExits()) {
                                Get.offAndToNamed("/HomePage");
                              } else {
                                FirestoreHelper.firestoreHelper
                                    .createUser()
                                    .then(
                                        (_) => Get.offAndToNamed("/HomePage"));
                              }
                              singupController.changeTheValue();
                            } else {
                              Get.snackbar(
                                "SING IN",
                                data['msg'],
                                backgroundColor: Colors.redAccent,
                              );
                            }
                          },
                          child: Container(
                            height: heigth * 0.065,
                            width: width * 0.18,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/images/loginPage/google.png",
                              height: heigth * 0.035,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            Map<String, dynamic> data = await FirebaseHelper
                                .firebaseHelper
                                .signInAnonymously();

                            if (data['user'] != null) {
                              Get.snackbar(
                                "SING IN",
                                "Sign In Successfully..",
                                backgroundColor: Colors.green,
                              );
                              singupController.getTheUserValue(data: data);
                              Get.offAndToNamed("/HomePage");
                              singupController.changeTheValue();
                            } else {
                              Get.snackbar(
                                "SING IN",
                                data['msg'],
                                backgroundColor: Colors.redAccent,
                              );
                            }
                          },
                          child: Container(
                            height: heigth * 0.065,
                            width: width * 0.18,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Image.asset(
                              "assets/images/loginPage/anonymous.png",
                              height: heigth * 0.035,
                            ),
                          ),
                        ),
                        Container(
                          height: heigth * 0.065,
                          width: width * 0.18,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/loginPage/facebook.png",
                            height: heigth * 0.035,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: heigth * 0.025,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Not a member ?",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: heigth * 0.015,
                            ),
                          ),
                          TextSpan(
                            text: " Register now",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.toNamed("/SingupPage");
                              },
                            style: TextStyle(
                              color: Color(0xff207aeb),
                              fontWeight: FontWeight.bold,
                              fontSize: heigth * 0.015,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        LocalNotificationHelper.localNotificationHelper
                            .showSimpleLocalPushNotification();
                      },
                      child: Text("Simple Notification"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        LocalNotificationHelper.localNotificationHelper
                            .showScheduledLocalPushNotification();
                      },
                      child: Text("Scheduled Notification"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        LocalNotificationHelper.localNotificationHelper
                            .showBigPictureLocalPushNotification();
                      },
                      child: Text("Big Picture Notification"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        LocalNotificationHelper.localNotificationHelper
                            .showMediaStyleLocalPushNotification();
                      },
                      child: Text("Media Style Notification"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        backgroundColor: Color(0xffe4f0f8),
      ),
    );
  }
}
