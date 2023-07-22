import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signin_singout_anonymous/controllers/singup_controller.dart';
import 'package:signin_singout_anonymous/utills/firebaseHelper.dart';

import '../../utills/atributes.dart';

class SingUpPage extends StatefulWidget {
  const SingUpPage({super.key});

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  TextEditingController emailSingupController = TextEditingController();
  TextEditingController passwordSingupController = TextEditingController();

  GlobalKey<FormState> singupKey = GlobalKey<FormState>();

  String emailSingup = "";
  String passwordSingup = "";

  SingupController singupController = Get.find<SingupController>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: singupKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios_sharp,
                          ),
                        )
                      ],
                    ),
                    Image.asset(
                      "assets/images/SingUp/Singip.png",
                      height: heigth * 0.3,
                    ),
                    SizedBox(
                      height: heigth * 0.05,
                    ),
                    TextFormField(
                      controller: emailSingupController,
                      onSaved: (val) {
                        emailSingup = val!;
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
                      controller: passwordSingupController,
                      obscureText: true,
                      obscuringCharacter: "*",
                      onSaved: (val) {
                        passwordSingup = val!;
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
                        if (singupKey.currentState!.validate()) {
                          singupKey.currentState!.save();

                          Map<String, dynamic> data = await FirebaseHelper.firebaseHelper
                              .singUpWithEmailAndPassword(
                                  email: emailSingup, password: passwordSingup);

                          if (data['user'] != null) {
                            Get.snackbar(
                              "SING IN",
                              "Sign In Successfully..",
                              backgroundColor: Colors.green,
                            );
                            singupController.getTheUserValue(data: data);
                            Get.offAllNamed("/HomePage");
                            singupController.changeTheValue();
                          } else {
                            Get.snackbar(
                              "SING IN",
                              data['msg'],
                              backgroundColor: Colors.redAccent,
                            );
                          }
                        }
                        emailSingupController.clear();
                        passwordSingupController.clear();
                      },
                      child: Container(
                        height: heigth * 0.08,
                        width: width,
                        decoration: BoxDecoration(
                          color: Color(0xffBA68C8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: heigth * 0.02,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: heigth * 0.05,
                    ),
                    Text(
                      "------ Or continue with ------",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: heigth * 0.075,
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Now a member ?",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: heigth * 0.015,
                            ),
                          ),
                          TextSpan(
                            text: " Sing in now",
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Get.back();
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
