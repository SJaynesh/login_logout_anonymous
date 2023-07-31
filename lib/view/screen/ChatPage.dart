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
                    .displayChatMessage(userId: data.id, user: data.data()),
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
                    QuerySnapshot<Map<String, dynamic>> data1 =
                        snapshot.data as QuerySnapshot<Map<String, dynamic>>;

                    List<QueryDocumentSnapshot<Map<String, dynamic>>> allDocs =
                        data1.docs;
                    return (allDocs.isEmpty)
                        ? Center(
                            child: Text("No Chat Available"),
                          )
                        : ListView.builder(
                            itemCount: allDocs.length,
                            reverse: true,
                            itemBuilder: (context, i) => (allDocs[i]
                                        ['fromId'] ==
                                    FirestoreHelper.auth.uid)
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Spacer(),
                                        Flexible(
                                          flex: 4,
                                          child: InkWell(
                                            onLongPress: () {
                                              FirestoreHelper.firestoreHelper.deleteMessage(user: data.data(), recordId: allDocs[i]['chatId'].toString());
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Color(0xffe7ffdb),
                                                borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(20),
                                                  bottomLeft: Radius.circular(20),
                                                  topLeft: Radius.circular(20),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Flexible(
                                                        child: Text(
                                                          "${allDocs[i]['msg']}",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "${allDocs[i]['sent']}  ✔",
                                                        style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 10,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Container(
                                            padding: const EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                bottomRight: Radius.circular(20),
                                                bottomLeft: Radius.circular(20),
                                                topRight: Radius.circular(20),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                              children: [
                                                Row(
                                                  mainAxisSize:
                                                  MainAxisSize.min,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        "${allDocs[i]['msg']}",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Text(
                                                      "${allDocs[i]['sent']}",
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Spacer(),
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
                      onPressed: () async {
                        await FirestoreHelper.firestoreHelper.sendChatMessage(
                          msg: chatController.text,
                          userId: data.id,
                          user: data.data(),
                        );
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
      backgroundColor: Color(0xfff0e7de),
    );
  }
}
