import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signin_singout_anonymous/utills/atributes.dart';

class SplachScreen extends StatefulWidget {
  const SplachScreen({super.key});

  @override
  State<SplachScreen> createState() => _SplachScreenState();
}

class _SplachScreenState extends State<SplachScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
      Duration(seconds: 5),
      () {
        (getStore.read("isNotRepert") == false ||
            getStore.read("isNotRepert") == null)
            ? Get.offAndToNamed("/LoginPage")
            : Get.offAndToNamed("/HomePage");
      },
    );
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Image.asset(
          "assets/images/Splach/logo.png",
          height: 100,
        ),
      ),
    );
  }
}
