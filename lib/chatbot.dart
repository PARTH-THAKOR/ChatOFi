// THE CHAT-BOT ACTIVITY

import 'dart:convert';
import 'package:chatofi/chatbotmodel.dart';
import 'package:chatofi/sequrity/apikey.dart';
import 'package:chatofi/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({Key? key}) : super(key: key);

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  TextEditingController texter = TextEditingController();
  List<ChatBotModel> gptlist = [];
  final user = FirebaseAuth.instance.currentUser?.phoneNumber;
  var docId = DateTime.now().microsecondsSinceEpoch.toString();
  DateTime now = DateTime.now();
  final scroller = ScrollController();

  @override
  void dispose() {
    scroller.dispose();
    super.dispose();
  }

  chatBotApiCall(String search) async {
    final fstore = FirebaseFirestore.instance.collection('chatbot');
    try {
      final response =
          await http.post(Uri.parse(url),
              headers: {
                "Authorization":
                    authKey,
                'Content-Type': 'application/json'
              },
              body: jsonEncode({
                "model": "text-davinci-003",
                "prompt": search,
                "max_tokens": 700,
                "temperature": 0
              }));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        gptlist.add(ChatBotModel.fromJson(data));
        docId = DateTime.now().microsecondsSinceEpoch.toString();
        fstore.doc(user.toString()).collection("openAI").doc(docId).set({
          "id": docId,
          "set": "ss",
          "time": DateTime.now(),
          "deleteId": docId,
          "user": user.toString(),
          "title": data['choices'][0]["text"].toString()
        }).then((value) {
          docId = DateTime.now().microsecondsSinceEpoch.toString();
        }).onError((error, stackTrace) {
          Fluttertoast.showToast(msg: error.toString());
          docId = DateTime.now().microsecondsSinceEpoch.toString();
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  firebaseMassageUpload() {
    final fstore = FirebaseFirestore.instance.collection('chatbot');
    texter.text.toString().isEmpty
        ? Fluttertoast.showToast(msg: "Empty Message")
        : fstore.doc(user.toString()).collection("openAI").doc(docId).set({
            "id": docId,
            "set": "s",
            "time": DateTime.now(),
            "deleteId": docId,
            "user": user.toString(),
            "title": texter.text.toString()
          }).then((value) {
            docId = DateTime.now().microsecondsSinceEpoch.toString();
            chatBotApiCall(texter.text.toString());
            texter.clear();
          }).onError((error, stackTrace) {
            Fluttertoast.showToast(msg: error.toString());
            texter.clear();
            docId = DateTime.now().microsecondsSinceEpoch.toString();
          });
  }

  firebaseMassageFetch() {
    final fstore = FirebaseFirestore.instance
        .collection('chatbot')
        .doc(user.toString())
        .collection("openAI");
    final fstoresnapshot = FirebaseFirestore.instance
        .collection('chatbot')
        .doc(user.toString())
        .collection("openAI")
        .orderBy('time')
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: fstoresnapshot,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color:
                    (darkmode == true) ? Colors.cyanAccent : Colors.pinkAccent,
              ),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No Messages",
                style: GoogleFonts.orbitron(
                    fontWeight: FontWeight.bold,
                    color: (darkmode) ? Colors.white : Colors.black,
                    fontSize: 20),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: CircularProgressIndicator(
                color:
                    (darkmode == true) ? Colors.cyanAccent : Colors.pinkAccent,
              ),
            );
          } else {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              scroller.jumpTo(scroller.position.maxScrollExtent);
            });
            return ListView.builder(
                controller: scroller,
                itemCount: snapshot.data!.docs.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => Column(children: [
                      (snapshot.data!.docs[index]['user'].toString()) ==
                              user.toString()
                          ? Row(
                              mainAxisAlignment: snapshot
                                          .data!.docs[index]['set']
                                          .toString() ==
                                      's'
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    InkWell(
                                      onLongPress: () {
                                        fstore
                                            .doc(snapshot
                                                .data!.docs[index]['deleteId']
                                                .toString())
                                            .delete();
                                        Fluttertoast.showToast(
                                            msg: "Message Deleted");
                                      },
                                      child: Container(
                                          margin: const EdgeInsets.only(
                                              right: 16, left: 14, bottom: 4),
                                          padding: const EdgeInsets.all(16),
                                          constraints: const BoxConstraints(
                                              maxWidth: 320),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                colors: snapshot.data!
                                                            .docs[index]['set']
                                                            .toString() ==
                                                        's'
                                                    ? (darkmode == true)
                                                        ? [
                                                            Colors.cyanAccent,
                                                            Colors.cyanAccent,
                                                          ]
                                                        : [
                                                            Colors.pinkAccent,
                                                            Colors.pinkAccent,
                                                          ]
                                                    : (darkmode == true)
                                                        ? [
                                                            const Color(
                                                                0xFF424242),
                                                            const Color(
                                                                0xFF424242)
                                                          ]
                                                        : [
                                                            Colors.black
                                                                .withOpacity(
                                                                    0.05),
                                                            Colors.black
                                                                .withOpacity(
                                                                    0.05)
                                                          ]),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Column(children: [
                                            Text(
                                              snapshot
                                                  .data!.docs[index]['title']
                                                  .toString(),
                                              style: GoogleFonts.orbitron(
                                                  color: snapshot
                                                              .data!
                                                              .docs[index]
                                                                  ['set']
                                                              .toString() ==
                                                          's'
                                                      ? (darkmode == true)
                                                          ? Colors.black
                                                          : Colors.white
                                                      : (darkmode == true)
                                                          ? Colors.white
                                                          : Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          ])),
                                    ),
                                  ],
                                )
                              ],
                            )
                          : Container(),
                    ]));
          }
        });
  }

  messageTextField() {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 16, top: 1, bottom: 16),
      child: ListTile(
        trailing: Container(
          margin: const EdgeInsets.only(right: 50),
          child: IconButton(
            onPressed: () {
              SchedulerBinding.instance.addPostFrameCallback((_) {
                scroller.jumpTo(scroller.position.maxScrollExtent);
              });
            },
            icon: Icon(
              Icons.arrow_downward_sharp,
              color: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
            ),
          ),
        ),
        tileColor: (darkmode == true)
            ? const Color(0xFF424242)
            : Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(250),
        ),
        title: Container(
          margin: const EdgeInsets.only(left: 10),
          child: TextFormField(
              cursorColor: (darkmode) ? Colors.white : Colors.black,
              maxLines: 1,
              controller: texter,
              style: GoogleFonts.orbitron(
                  color: (darkmode) ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
              decoration: InputDecoration(
                  hintText: "Message",
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.orbitron(
                      color: (darkmode) ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold))),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:
            (darkmode == true) ? const Color(0xFF212121) : Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            firebaseMassageUpload();
          },
          backgroundColor:
              (darkmode == true) ? Colors.cyanAccent : Colors.pinkAccent,
          child: Icon(
            Icons.send,
            color: (darkmode) ? Colors.black : Colors.white,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: firebaseMassageFetch(),
            ),
            messageTextField()
          ],
        ));
  }
}

deleteAllChat() async {
  final user = FirebaseAuth.instance.currentUser?.phoneNumber;
  final fstoresnapshot = FirebaseFirestore.instance
      .collection('chatbot')
      .doc(user.toString())
      .collection("openAI");
  var list = await fstoresnapshot.get();
  for (int i = 0; i < list.size; i++) {
    if (list.docs[i]['user'] == user.toString()) {
      fstoresnapshot.doc(list.docs[i]['deleteId'].toString()).delete();
    }
  }
}
