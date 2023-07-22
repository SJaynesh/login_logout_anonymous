import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signin_singout_anonymous/utills/firebaseHelper.dart';
import 'package:signin_singout_anonymous/utills/firestore_helper.dart';

import '../../controllers/singup_controller.dart';
import '../../utills/atributes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SingupController singupController = Get.put(SingupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage("${getStore.read('UserImage')}"),
            ),
            Divider(),
            Text("USERNAME : ${getStore.read("UserName")}"),
            Text("EMAIL : ${getStore.read("UserEmail")}"),
            Text("USER ID : ${getStore.read("UserUid")}"),
            // (user != null)
            //     ? (user!.isAnonymous)
            //         ? Text("ANONYMOUS")
            //         : (user?.displayName == null)
            //             ? Text("")
            //             : Text("UserName : ${user!.displayName}")
            //     : Text(""),
            // (user != null)
            //     ? (user!.isAnonymous)
            //         ? Text("")
            //         : Text("Email : ${user?.email}")
            //     : Text(""),
            // Text("PhoneNumber : ${user?.phoneNumber}"),
            // Text("UserId : ${user?.uid}"),
            // Text("RefreshToken : ${user?.refreshToken}"),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text("HomePage"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseHelper.firebaseHelper.singOut();
              print("log out");
              Get.offNamedUntil("/LoginPage", (route) => false);
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirestoreHelper.firestoreHelper.displayAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                "ERROR : ${snapshot.error}",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.brown,
                ),
              ),
            );
          } else if (snapshot.hasData) {
            QuerySnapshot<Map<String, dynamic>> data = snapshot.data;

            List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                data.docs;
            return ListView.builder(
              itemCount: allDocs.length,
              itemBuilder: (context, i) =>
                  (getStore.read("UserEmail") == allDocs[i].data()['email'])
                      ? Container()
                      : ListTile(
                          onTap: () {
                            Get.toNamed("/ChatPage", arguments: allDocs[i]);
                          },
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage("${allDocs[i].data()['image']}"),
                          ),
                          title: Text("${allDocs[i].data()['email']}"),
                          subtitle: Text("${allDocs[i].data()['uid']}"),
                        ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
