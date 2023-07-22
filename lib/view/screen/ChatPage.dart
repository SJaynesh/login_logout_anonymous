import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:signin_singout_anonymous/utills/firestore_helper.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController chatController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    QueryDocumentSnapshot<Map<String, dynamic>> data = ModalRoute.of(context)!
        .settings
        .arguments as QueryDocumentSnapshot<Map<String, dynamic>>;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Message",
          style: TextStyle(
            fontSize: 20,
            color: Colors.brown,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirestoreHelper.firestoreHelper
                    .displayChatMessage(id: data.id),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        "ERROR : ${snapshot.error}",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    QuerySnapshot<Map<String, dynamic>> data =
                        snapshot.data as QuerySnapshot<Map<String, dynamic>>;

                    List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                        data.docs;
                    return ListView.builder(
                      itemCount: allDocs.length,
                      reverse: true,
                      itemBuilder: (context, i) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color : Color(0xffe0d5ff),
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(50),
                                  bottomLeft: Radius.circular(50),
                                  topLeft: Radius.circular(50),
                                ),
                              ),
                              child: Text(
                                "${allDocs[i].data()['messge']}",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  flex: 10,
                  child: TextField(
                    controller: chatController,
                    decoration: InputDecoration(
                      hintText: "Send your msg...",
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.brown,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: CircleAvatar(
                    radius: 30,
                    child: IconButton(
                      onPressed: () {
                        FirestoreHelper.firestoreHelper.sendChatMessage(
                            msg: chatController.text, id: data.id);
                        chatController.clear();
                      },
                      icon: Icon(
                        Icons.send,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
