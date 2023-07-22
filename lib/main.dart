import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:signin_singout_anonymous/view/screen/ChatPage.dart';
import 'package:signin_singout_anonymous/view/screen/HomePage.dart';
import 'package:signin_singout_anonymous/view/screen/LoginPage.dart';
import 'package:signin_singout_anonymous/view/screen/SingUpPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:signin_singout_anonymous/view/screen/SplachScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      darkTheme: ThemeData(useMaterial3: true),
      getPages: [
        GetPage(
          name: "/",
          page: () => SplachScreen(),
          transition: Transition.rightToLeft,
          curve: Curves.easeInOut,
        ),
        GetPage(
          name: "/LoginPage",
          page: () => LoginPage(),
          transition: Transition.rightToLeft,
          curve: Curves.easeInOut,
        ),
        GetPage(
          name: "/SingupPage",
          page: () => SingUpPage(),
          transition: Transition.rightToLeft,
          curve: Curves.easeInOut,
        ),
        GetPage(
          name: "/HomePage",
          page: () => HomePage(),
          transition: Transition.rightToLeft,
          curve: Curves.easeInOut,
        ),
        GetPage(
          name: "/ChatPage",
          page: () => ChatPage(),
          transition: Transition.rightToLeft,
          curve: Curves.easeInOut,
        ),
      ],
    ),
  );
}
