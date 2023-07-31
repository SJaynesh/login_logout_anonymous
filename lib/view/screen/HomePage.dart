import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signin_singout_anonymous/controllers/user_data_controller.dart';
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
  UserDataController userDataController = Get.put(UserDataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                    "${userDataController.userDataModel.photoURl}"),
              ),
              Divider(),
              Text("UID : ${userDataController.userDataModel.uid}"),
              Text(
                  "USERNAME : ${userDataController.userDataModel.displayName}"),
              Text("EMAIL : ${userDataController.userDataModel.email}"),
              Text("PHONE : ${userDataController.userDataModel.phoneNumber}"),
              Text("PHONE URL : ${userDataController.userDataModel.photoURl}"),
              Text("TOKEN : ${userDataController.userDataModel.token}"),
              // Text("USERNAME : ${getStore.read("UserName")}"),
              // Text("EMAIL : ${getStore.read("UserEmail")}"),
              // Text("USER ID : ${getStore.read("UserUid")}"),
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
            QuerySnapshot<Map<String, dynamic>> data = snapshot.data as QuerySnapshot<Map<String, dynamic>>;

            List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                data.docs;

            print("---- Length ---");
            print(allDocs);
            print("---- Length ---");
            return (allDocs.isEmpty)
                ? Center(
                    child: Text("EMPTY"),
                  )
                : ListView.builder(
                    itemCount: allDocs.length,
                    itemBuilder: (context, i) => ListTile(
                      onTap: () {
                        Get.toNamed("/ChatPage", arguments: allDocs[i]);
                      },
                      // isThreeLine: true,
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage("${allDocs[i].data()['image']}"),
                      ),
                      title: Text("${allDocs[i].data()['email']}"),
                      subtitle: Text("${allDocs[i].data()['id']}"),
                      // trailing: Text("${allDocs[i].id}"),
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
