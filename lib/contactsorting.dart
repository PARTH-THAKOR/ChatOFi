// SORTING ACTIVITY

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatofi/settings.dart';
import 'package:chatofi/videovoicecalls.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'contactprofilephotos.dart';
import 'imagesending.dart';
import 'imagesendingbycamera.dart';

class SortingForChat extends StatefulWidget {
  const SortingForChat({Key? key}) : super(key: key);

  @override
  State<SortingForChat> createState() => _SortingForChatState();
}

class _SortingForChatState extends State<SortingForChat> {
  List<Contact>? contacts = [];
  var controller = "";
  final scroller = ScrollController();
  final auth = FirebaseAuth.instance;
  final texter = TextEditingController();

  @override
  void initState() {
    super.initState();
    getContact();
  }

  @override
  void dispose() {
    scroller.dispose();
    super.dispose();
  }

  void getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: false);
      setState(() {});
    }
  }

  massagePage(int index, BuildContext context) {
    final user = auth.currentUser?.phoneNumber;
    DateTime now = DateTime.now();
    String curruntUser = (contacts![index]
            .phones
            .first
            .number
            .toString()
            .contains("+91")
        ? (contacts![index].phones.first.number.toString()).replaceAll(' ', '')
        : ("+91${contacts![index].phones.first.number}").replaceAll(' ', ''));
    String callID = (user.toString() + curruntUser).replaceAll('+', '');
    String cu = curruntUser.replaceAll('+', '');
    String u = user.toString().replaceAll('+', '');
    double ciaadd = double.parse(cu) + double.parse(u);
    double ciadd = 0;

    for (int i = 0; i < 24; i++) {
      ciadd += double.parse(callID[i]);
    }

    final fstore1x = FirebaseFirestore.instance.collection('post');
    final fstore2x = FirebaseFirestore.instance
        .collection('post')
        .doc(ciadd.toString() + ciaadd.toString())
        .collection('lol');

    var docId = DateTime.now().microsecondsSinceEpoch.toString();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: (darkmode) ? const Color(0xFF212121) : Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          texter.text.toString().isEmpty
              ? Fluttertoast.showToast(msg: "Empty Message")
              : fstore2x.doc(docId).set({
                  "id": curruntUser + user.toString(),
                  "time": DateTime.now(),
                  "type": "text",
                  "deleteId": docId,
                  "time2":
                      "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
                  "title": texter.text.toString()
                }).then((value) {
                  docId = DateTime.now().microsecondsSinceEpoch.toString();
                  fstore1x.doc(ciadd.toString() + ciaadd.toString()).set({
                    "id": curruntUser + user.toString(),
                    "time": DateTime.now(),
                    "lastmsg": texter.text.toString(),
                    "time2":
                        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
                  }).then((value) {
                    texter.clear();
                  }).onError((error, stackTrace) {
                    Fluttertoast.showToast(msg: error.toString());
                    texter.clear();
                  });
                  texter.clear();
                }).onError((error, stackTrace) {
                  Fluttertoast.showToast(msg: error.toString());
                  texter.clear();
                });
        },
        backgroundColor: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
        child: Icon(
          Icons.send,
          color: (darkmode) ? Colors.black : Colors.white,
        ),
      ),
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: (darkmode == true)
                            ? const Color(0xFF303030)
                            : Colors.white.withOpacity(0.8),
                        title: Text(
                          "Delete",
                          style: GoogleFonts.orbitron(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: (darkmode == true)
                                  ? Colors.cyanAccent
                                  : Colors.pinkAccent),
                        ),
                        content: Text(
                          "Do you want to Delete all message ?",
                          style: GoogleFonts.orbitron(
                              color: (darkmode == true)
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                var list = await fstore2x.get();
                                for (int i = 0; i < list.size; i++) {
                                  fstore2x
                                      .doc(list.docs[i]['deleteId'].toString())
                                      .delete();
                                }
                                Fluttertoast.showToast(
                                    msg: "All messages are Deleted");
                                setState(() {
                                  Navigator.pop(context);
                                });
                              },
                              child: Text(
                                "Delete",
                                style: GoogleFonts.orbitron(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: (darkmode == true)
                                        ? Colors.cyanAccent
                                        : Colors.pinkAccent),
                              ))
                        ],
                      );
                    });
              },
              icon: Icon(
                Icons.delete,
                color: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
              )),
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ImageSendByCamera(
                              curruntUser: curruntUser,
                              cuadd: ciadd,
                              cuaadd: ciaadd,
                            )));
              },
              icon: Icon(
                Icons.camera_alt,
                color: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
              )),
          IconButton(
              onPressed: () {
                final fstore = FirebaseFirestore.instance.collection('calls');
                DateTime now = DateTime.now();

                var deleteId = DateTime.now().millisecondsSinceEpoch.toString();

                fstore.doc(deleteId).set({
                  "id": user.toString() + curruntUser.toString(),
                  "time": DateTime.now(),
                  "deleteId": deleteId,
                  "time2":
                      "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
                }).then((value) {
                  deleteId = DateTime.now().millisecondsSinceEpoch.toString();
                }).onError((error, stackTrace) {
                  Fluttertoast.showToast(msg: error.toString());
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VoiceCall(
                              callID: ciadd.toString() + ciaadd.toString(),
                            )));
              },
              icon: Icon(
                Icons.call_outlined,
                color: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
              )),
          IconButton(
              onPressed: () {
                final fstore = FirebaseFirestore.instance.collection('calls');
                DateTime now = DateTime.now();

                var deleteId = DateTime.now().millisecondsSinceEpoch.toString();

                fstore.doc(deleteId).set({
                  "id": user.toString() + curruntUser.toString(),
                  "time": DateTime.now(),
                  "deleteId": deleteId,
                  "time2":
                      "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
                }).then((value) {
                  deleteId = DateTime.now().millisecondsSinceEpoch.toString();
                }).onError((error, stackTrace) {
                  Fluttertoast.showToast(msg: error.toString());
                });
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VideoCall(
                              callID: ciadd.toString() + ciaadd.toString(),
                            )));
              },
              icon: Icon(
                Icons.videocam,
                color: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
              )),
        ],
        leading: BackButton(color: (darkmode) ? Colors.white : Colors.black),
        backgroundColor: (darkmode)
            ? const Color(0xFF303030)
            : Colors.white.withOpacity(0.2),
        title: ListTile(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => contactIdPage(index)));
          },
          title: Text(
              '${contacts![index].name.first} ${contacts![index].name.last}',
              style: GoogleFonts.orbitron(
                  fontWeight: FontWeight.bold,
                  color: (darkmode) ? Colors.white : Colors.black)),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: chatMessageFromFirestore(index, context),
            ),
            messageTextField(index)
          ],
        ),
      ),
    );
  }

  messageTextField(int index) {
    final user = auth.currentUser?.phoneNumber;
    String curruntUser = (contacts![index]
            .phones
            .first
            .number
            .toString()
            .contains("+91")
        ? (contacts![index].phones.first.number.toString()).replaceAll(' ', '')
        : ("+91${contacts![index].phones.first.number}").replaceAll(' ', ''));
    String callID = (user.toString() + curruntUser).replaceAll('+', '');
    String cu = curruntUser.replaceAll('+', '');
    String u = user.toString().replaceAll('+', '');
    double ciaadd = double.parse(cu) + double.parse(u);
    double ciadd = 0;

    for (int i = 0; i < 24; i++) {
      ciadd += double.parse(callID[i]);
    }
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 16, bottom: 16, top: 1),
      child: ListTile(
        tileColor: (darkmode)
            ? const Color(0xFF424242)
            : Colors.black.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(250),
        ),
        leading: IconButton(
          color: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ImageSend(
                          curruntUser: curruntUser,
                          cuadd: ciadd,
                          cuaadd: ciaadd,
                        )));
          },
          icon: const Icon(Icons.source),
        ),
        trailing: Container(
            margin: const EdgeInsets.only(right: 38),
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
            )),
        title: TextFormField(
            cursorColor: (darkmode) ? Colors.white : Colors.black,
            maxLines: 1,
            controller: texter,
            style: GoogleFonts.orbitron(
                color: (darkmode) ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Message",
                hintStyle: GoogleFonts.orbitron(
                    color: (darkmode) ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold))),
      ),
    );
  }

  chatMessageFromFirestore(int index, BuildContext context) {
    final user = auth.currentUser?.phoneNumber;
    String curruntUser = (contacts![index]
            .phones
            .first
            .number
            .toString()
            .contains("+91")
        ? (contacts![index].phones.first.number.toString()).replaceAll(' ', '')
        : ("+91${contacts![index].phones.first.number}").replaceAll(' ', ''));
    String callID = (user.toString() + curruntUser).replaceAll('+', '');
    String cu = curruntUser.replaceAll('+', '');
    String u = user.toString().replaceAll('+', '');
    double ciaadd = double.parse(cu) + double.parse(u);
    double ciadd = 0;
    for (int i = 0; i < 24; i++) {
      ciadd += double.parse(callID[i]);
    }
    final fstore2x = FirebaseFirestore.instance
        .collection('post')
        .doc(ciadd.toString() + ciaadd.toString())
        .collection('lol');
    final fstore2 = FirebaseFirestore.instance
        .collection('post')
        .doc(ciadd.toString() + ciaadd.toString())
        .collection('lol')
        .orderBy('time')
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: fstore2,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
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
                color: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
              ),
            );
          } else {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              scroller.jumpTo(scroller.position.maxScrollExtent);
            });
            return ListView.builder(
                controller: scroller,
                reverse: false,
                itemCount: snapshot.data!.docs.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => Column(children: [
                      (snapshot.data!.docs[index]['id'].toString())
                                  .contains(curruntUser) &&
                              (snapshot.data!.docs[index]['id'].toString())
                                  .contains(user.toString())
                          ? Row(
                              mainAxisAlignment:
                                  snapshot.data!.docs[index]['id'].toString() ==
                                          curruntUser + user.toString()
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    snapshot.data!.docs[index]['type']
                                                .toString() ==
                                            "img"
                                        ? InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PreviewPage(
                                                              pictureUrl: snapshot
                                                                  .data!
                                                                  .docs[index]
                                                                      ['title']
                                                                  .toString())));
                                            },
                                            onLongPress: () {
                                              if (snapshot
                                                      .data!.docs[index]['id']
                                                      .toString() ==
                                                  curruntUser +
                                                      user.toString()) {
                                                fstore2x
                                                    .doc(snapshot.data!
                                                        .docs[index]['deleteId']
                                                        .toString())
                                                    .delete();
                                                Fluttertoast.showToast(
                                                    msg: "Message Deleted");
                                              }
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  right: 14,
                                                  left: 14,
                                                  bottom: 4),
                                              width: 250,
                                              height: 300,
                                              child: Column(children: [
                                                Expanded(
                                                  child: Container(
                                                    padding:
                                                        const EdgeInsets.all(7),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors
                                                                .greenAccent),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(17)),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                      child: Image.network(
                                                          snapshot
                                                              .data!
                                                              .docs[index]
                                                                  ['title']
                                                              .toString()),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  snapshot.data!
                                                      .docs[index]['time2']
                                                      .toString(),
                                                  style: GoogleFonts.orbitron(
                                                      fontSize: 8,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: (darkmode)
                                                          ? Colors.white
                                                          : Colors.black),
                                                )
                                              ]),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              if (snapshot
                                                      .data!.docs[index]['id']
                                                      .toString() ==
                                                  curruntUser +
                                                      user.toString()) {
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "LongPress to delete Message");
                                              }
                                            },
                                            onLongPress: () {
                                              if (snapshot
                                                      .data!.docs[index]['id']
                                                      .toString() ==
                                                  curruntUser +
                                                      user.toString()) {
                                                fstore2x
                                                    .doc(snapshot.data!
                                                        .docs[index]['deleteId']
                                                        .toString())
                                                    .delete();
                                                Fluttertoast.showToast(
                                                    msg: "Message Deleted");
                                              }
                                            },
                                            child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 16,
                                                    left: 14,
                                                    bottom: 4),
                                                padding:
                                                    const EdgeInsets.all(16),
                                                constraints:
                                                    const BoxConstraints(
                                                        maxWidth: 320),
                                                decoration: BoxDecoration(
                                                  color: snapshot.data!
                                                              .docs[index]['id']
                                                              .toString() ==
                                                          curruntUser +
                                                              user.toString()
                                                      ? (darkmode)
                                                          ? Colors.cyanAccent
                                                          : Colors.pinkAccent
                                                      : (darkmode)
                                                          ? const Color(
                                                              0xFF424242)
                                                          : Colors.black
                                                              .withOpacity(
                                                                  0.05),
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Column(children: [
                                                  Text(
                                                    snapshot.data!
                                                        .docs[index]['title']
                                                        .toString(),
                                                    style: GoogleFonts.orbitron(
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        ['id']
                                                                    .toString() ==
                                                                curruntUser +
                                                                    user.toString()
                                                            ? (darkmode)
                                                                ? Colors.black
                                                                : Colors.white
                                                            : (darkmode)
                                                                ? Colors.white
                                                                : Colors.black),
                                                  ),
                                                  Text(
                                                    snapshot.data!
                                                        .docs[index]['time2']
                                                        .toString(),
                                                    style: GoogleFonts.orbitron(
                                                        fontSize: 8,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        ['id']
                                                                    .toString() ==
                                                                curruntUser +
                                                                    user.toString()
                                                            ? (darkmode)
                                                                ? Colors.black
                                                                : Colors.white
                                                            : (darkmode)
                                                                ? Colors.white
                                                                : Colors.black),
                                                  )
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

  contactIdPage(int index) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser?.phoneNumber;
    String curruntUser = (contacts![index]
            .phones
            .first
            .number
            .toString()
            .contains("+91")
        ? (contacts![index].phones.first.number.toString()).replaceAll(' ', '')
        : ("+91${contacts![index].phones.first.number}").replaceAll(' ', ''));
    String callID = (user.toString() + curruntUser).replaceAll('+', '');
    String cu = curruntUser.replaceAll('+', '');
    String u = user.toString().replaceAll('+', '');
    double ciaadd = double.parse(cu) + double.parse(u);
    double ciadd = 0;

    for (int i = 0; i < 24; i++) {
      ciadd += double.parse(callID[i]);
    }

    final fstore2 = FirebaseFirestore.instance
        .collection("About${curruntUser.toString()}")
        .snapshots();
    late String hinttext = "Hey ! there, I am using ChatOFi !";

    return Scaffold(
      backgroundColor: (darkmode) ? const Color(0xFF212121) : Colors.white,
      appBar: AppBar(
        leading: BackButton(
          color: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.3,
            child: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 30,
                child: ContactProfilePhotos(curruntnumber: curruntUser)),
          ),
          ListTile(
            title: Text(
              "${contacts![index].name.first} ${contacts![index].name.last}",
              textAlign: TextAlign.center,
              style: GoogleFonts.orbitron(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
              ),
            ),
          ),
          ListTile(
            title: Text(
              (contacts![index].phones.isNotEmpty)
                  ? (contacts![index].phones.first.number)
                  : "--",
              textAlign: TextAlign.center,
              style: GoogleFonts.orbitron(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: (darkmode) ? Colors.white : Colors.black),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ListTile(
            leading: IconButton(
                onPressed: () {
                  final fstore = FirebaseFirestore.instance.collection('calls');
                  DateTime now = DateTime.now();

                  var deleteId =
                      DateTime.now().millisecondsSinceEpoch.toString();

                  fstore.doc(deleteId).set({
                    "id": user.toString() + curruntUser.toString(),
                    "time": DateTime.now(),
                    "deleteId": deleteId,
                    "time2":
                        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
                  }).then((value) {
                    deleteId = DateTime.now().millisecondsSinceEpoch.toString();
                  }).onError((error, stackTrace) {
                    Fluttertoast.showToast(msg: error.toString());
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VideoCall(
                                callID: ciadd.toString() + ciaadd.toString(),
                              )));
                },
                icon: Icon(
                  Icons.videocam,
                  color: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
                )),
            onTap: () {
              final fstore = FirebaseFirestore.instance.collection('calls');
              DateTime now = DateTime.now();

              var deleteId = DateTime.now().millisecondsSinceEpoch.toString();

              fstore.doc(deleteId).set({
                "id": user.toString() + curruntUser.toString(),
                "time": DateTime.now(),
                "deleteId": deleteId,
                "time2":
                    "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
              }).then((value) {
                deleteId = DateTime.now().millisecondsSinceEpoch.toString();
              }).onError((error, stackTrace) {
                Fluttertoast.showToast(msg: error.toString());
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VideoCall(
                            callID: ciadd.toString() + ciaadd.toString(),
                          )));
            },
            title: Text(
              "Video call ${contacts![index].name.first} ${contacts![index].name.last}",
              style: GoogleFonts.orbitron(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: (darkmode) ? Colors.white : Colors.black),
            ),
          ),
          ListTile(
            leading: IconButton(
                onPressed: () {
                  final fstore = FirebaseFirestore.instance.collection('calls');
                  DateTime now = DateTime.now();

                  var deleteId =
                      DateTime.now().millisecondsSinceEpoch.toString();

                  fstore.doc(deleteId).set({
                    "id": user.toString() + curruntUser.toString(),
                    "time": DateTime.now(),
                    "deleteId": deleteId,
                    "time2":
                        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
                  }).then((value) {
                    deleteId = DateTime.now().millisecondsSinceEpoch.toString();
                  }).onError((error, stackTrace) {
                    Fluttertoast.showToast(msg: error.toString());
                  });
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VoiceCall(
                                callID: ciadd.toString() + ciaadd.toString(),
                              )));
                },
                icon: Icon(
                  Icons.call_outlined,
                  color: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
                )),
            onTap: () {
              final fstore = FirebaseFirestore.instance.collection('calls');
              DateTime now = DateTime.now();

              var deleteId = DateTime.now().millisecondsSinceEpoch.toString();

              fstore.doc(deleteId).set({
                "id": user.toString() + curruntUser.toString(),
                "time": DateTime.now(),
                "deleteId": deleteId,
                "time2":
                    "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
              }).then((value) {
                deleteId = DateTime.now().millisecondsSinceEpoch.toString();
              }).onError((error, stackTrace) {
                Fluttertoast.showToast(msg: error.toString());
              });
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VoiceCall(
                            callID: ciadd.toString() + ciaadd.toString(),
                          )));
            },
            title: Text(
              "Voice call ${contacts![index].name.first} ${contacts![index].name.last}",
              style: GoogleFonts.orbitron(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: (darkmode) ? Colors.white : Colors.black),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              Text(
                "Status",
                style: GoogleFonts.orbitron(
                    color: (darkmode) ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            margin: const EdgeInsets.only(right: 10, left: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                border: Border.all(
                  color: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
                )),
            child: ListTile(
              title: StreamBuilder<QuerySnapshot>(
                  stream: fstore2,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(".....",
                          style: GoogleFonts.orbitron(
                              fontSize: 25,
                              color: (darkmode) ? Colors.white : Colors.black));
                    } else if (snapshot.hasError) {
                      return Text(".....",
                          style: GoogleFonts.orbitron(
                              fontSize: 25,
                              color: (darkmode) ? Colors.white : Colors.black));
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Text(hinttext,
                          style: GoogleFonts.orbitron(
                              fontSize: 25,
                              color: (darkmode) ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold));
                    } else {
                      return snapshot.data!.docs[0]['id'].toString() ==
                              curruntUser
                          ? Text(
                              snapshot.data!.docs[0]['title'],
                              style: GoogleFonts.orbitron(
                                  color:
                                      (darkmode) ? Colors.white : Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text("......",
                              style: GoogleFonts.orbitron(
                                  fontSize: 25,
                                  color: (darkmode)
                                      ? Colors.white
                                      : Colors.black));
                    }
                  }),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Container(
            color: (darkmode == true) ? const Color(0xFF212121) : Colors.white,
            margin: const EdgeInsets.only(top: 25),
            alignment: Alignment.bottomCenter,
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText('  developers.roundrobin',
                    textStyle: GoogleFonts.orbitron(
                        color: (darkmode == true) ? Colors.white : Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
              ],
              totalRepeatCount: 1,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser?.phoneNumber;
    return Scaffold(
        backgroundColor: (darkmode) ? const Color(0xFF212121) : Colors.white,
        appBar: AppBar(
          leading: BackButton(
            color: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Container(
            margin: const EdgeInsets.only(right: 10),
            child: TextFormField(
              autofocus: true,
              cursorColor: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
              style: GoogleFonts.orbitron(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: (darkmode) ? Colors.white : Colors.black,
              ),
              onChanged: (value) {
                setState(() {
                  controller = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Enter Name for Chat",
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: (darkmode)
                            ? Colors.cyanAccent
                            : Colors.pinkAccent)),
                hintStyle: GoogleFonts.orbitron(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: (darkmode) ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
        ),
        body: (contacts) == null
            ? Center(
                child: CircularProgressIndicator(
                    color: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent))
            : ListView.builder(
                itemCount: contacts!.length,
                itemBuilder: (BuildContext context, int index) {
                  if ("${contacts![index].name.first} ${contacts![index].name.last}"
                          .toString()
                          .toLowerCase()
                          .startsWith(controller) &&
                      controller != "") {
                    return ListTile(
                        tileColor:
                            (darkmode) ? const Color(0xFF212121) : Colors.white,
                        leading: CircleAvatar(
                            backgroundColor:
                                (darkmode) ? Colors.grey : Colors.pinkAccent,
                            child: (contacts![index].phones.isNotEmpty)
                                ? ContactProfilePhotos(
                                    curruntnumber: (contacts![index]
                                            .phones
                                            .first
                                            .number
                                            .toString()
                                            .contains("+91")
                                        ? (contacts![index]
                                                .phones
                                                .first
                                                .number
                                                .toString())
                                            .replaceAll(' ', '')
                                        : ("+91${contacts![index].phones.first.number}")
                                            .replaceAll(' ', '')))
                                : const Icon(
                                    Icons.abc,
                                    color: Colors.white,
                                  )),
                        title: Text(
                          "${contacts![index].name.first} ${contacts![index].name.last}",
                          style: GoogleFonts.orbitron(
                              color: (darkmode) ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            (contacts![index].phones.isNotEmpty)
                                ? (contacts![index].phones.first.number)
                                : "--",
                            style: GoogleFonts.orbitron(
                                color:
                                    (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
                                fontWeight: FontWeight.bold)),
                        onTap: () {
                          if (contacts![index].phones.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Can't make chat with this contact");
                          } else if ((contacts![index].phones.first.number)
                                  .toString()
                                  .length <
                              10) {
                            Fluttertoast.showToast(
                                msg: "Can't make chat with this contact");
                          } else if ((contacts![index].phones.first.number)
                              .toString()
                              .contains(user.toString().substring(3, 13))) {
                            Fluttertoast.showToast(
                                msg: "Can't make chat with yourself");
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        massagePage(index, context)));
                          }
                        });
                  } else if (controller == "") {
                    return ListTile(
                        tileColor:
                            (darkmode) ? const Color(0xFF212121) : Colors.white,
                        leading: CircleAvatar(
                            backgroundColor:
                                (darkmode) ? Colors.grey : Colors.pinkAccent,
                            child: (contacts![index].phones.isNotEmpty)
                                ? ContactProfilePhotos(
                                    curruntnumber: (contacts![index]
                                            .phones
                                            .first
                                            .number
                                            .toString()
                                            .contains("+91")
                                        ? (contacts![index]
                                                .phones
                                                .first
                                                .number
                                                .toString())
                                            .replaceAll(' ', '')
                                        : ("+91${contacts![index].phones.first.number}")
                                            .replaceAll(' ', '')))
                                : const Icon(
                                    Icons.abc,
                                    color: Colors.white,
                                  )),
                        title: Text(
                          "${contacts![index].name.first} ${contacts![index].name.last}",
                          style: GoogleFonts.orbitron(
                              color: (darkmode) ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            (contacts![index].phones.isNotEmpty)
                                ? (contacts![index].phones.first.number)
                                : "--",
                            style: GoogleFonts.orbitron(
                                color:
                                    (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
                                fontWeight: FontWeight.bold)),
                        onTap: () {
                          if (contacts![index].phones.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Can't make chat with this contact");
                          } else if ((contacts![index].phones.first.number)
                                  .toString()
                                  .length <
                              10) {
                            Fluttertoast.showToast(
                                msg: "Can't make chat with this contact");
                          } else if ((contacts![index].phones.first.number)
                              .toString()
                              .contains(user.toString().substring(3, 13))) {
                            Fluttertoast.showToast(
                                msg: "Can't make chat with yourself");
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        massagePage(index, context)));
                          }
                        });
                  } else {
                    return Container();
                  }
                },
              ));
  }
}

class SortingForCall extends StatefulWidget {
  const SortingForCall({Key? key}) : super(key: key);

  @override
  State<SortingForCall> createState() => _SortingForCallState();
}

class _SortingForCallState extends State<SortingForCall> {
  List<Contact>? contacts = [];
  final auth = FirebaseAuth.instance;
  var controller = "";

  @override
  void initState() {
    super.initState();
    getContact();
  }

  void getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
    }
    setState(() {});
  }

  callIdFinder(int index) {
    final user = auth.currentUser?.phoneNumber;
    String curruntUser = (contacts![index]
            .phones
            .first
            .number
            .toString()
            .contains("+91")
        ? (contacts![index].phones.first.number.toString()).replaceAll(' ', '')
        : ("+91${contacts![index].phones.first.number}").replaceAll(' ', ''));
    String callID = (user.toString() + curruntUser).replaceAll('+', '');
    String cu = curruntUser.replaceAll('+', '');
    String u = user.toString().replaceAll('+', '');
    double ciaadd = double.parse(cu) + double.parse(u);
    double ciadd = 0;

    for (int i = 0; i < 24; i++) {
      ciadd += double.parse(callID[i]);
    }

    final fstore = FirebaseFirestore.instance.collection('calls');
    DateTime now = DateTime.now();

    var deleteId = DateTime.now().millisecondsSinceEpoch.toString();

    fstore.doc(deleteId).set({
      "id": user.toString() + curruntUser.toString(),
      "time": DateTime.now(),
      "deleteId": deleteId,
      "time2":
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
    }).then((value) {
      deleteId = DateTime.now().millisecondsSinceEpoch.toString();
    }).onError((error, stackTrace) {
      Fluttertoast.showToast(msg: error.toString());
    });

    return ciadd.toString() + ciaadd.toString();
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser?.phoneNumber;
    return Scaffold(
        backgroundColor: (darkmode) ? const Color(0xFF212121) : Colors.white,
        appBar: AppBar(
          leading: BackButton(
            color: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Container(
            margin: const EdgeInsets.only(right: 10),
            child: TextFormField(
              autofocus: true,
              cursorColor: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
              style: GoogleFonts.orbitron(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: (darkmode) ? Colors.white : Colors.black,
              ),
              onChanged: (value) {
                setState(() {
                  controller = value.toString();
                });
              },
              decoration: InputDecoration(
                hintText: "Enter Name for Call",
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: (darkmode)
                            ? Colors.cyanAccent
                            : Colors.pinkAccent)),
                hintStyle: GoogleFonts.orbitron(
                    fontSize: 17,
                    color: (darkmode) ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        body: (contacts) == null
            ? Center(
                child: CircularProgressIndicator(
                    color: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent))
            : ListView.builder(
                itemCount: contacts!.length,
                itemBuilder: (BuildContext context, int index) {
                  if ("${contacts![index].name.first} ${contacts![index].name.last}"
                          .toString()
                          .toLowerCase()
                          .startsWith(controller) &&
                      controller != "") {
                    return ListTile(
                        tileColor:
                            (darkmode) ? const Color(0xFF212121) : Colors.white,
                        leading: CircleAvatar(
                          backgroundColor:
                              (darkmode) ? Colors.grey : Colors.pinkAccent,
                          child: (contacts![index].phones.isNotEmpty)
                              ? ContactProfilePhotos(
                                  curruntnumber: (contacts![index]
                                          .phones
                                          .first
                                          .number
                                          .toString()
                                          .contains("+91")
                                      ? (contacts![index]
                                              .phones
                                              .first
                                              .number
                                              .toString())
                                          .replaceAll(' ', '')
                                      : ("+91${contacts![index].phones.first.number}")
                                          .replaceAll(' ', '')))
                              : const Icon(
                                  Icons.abc,
                                  color: Colors.white,
                                ),
                        ),
                        title: Text(
                          "${contacts![index].name.first} ${contacts![index].name.last}",
                          style: GoogleFonts.orbitron(
                              color: (darkmode) ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            (contacts![index].phones.isNotEmpty)
                                ? (contacts![index].phones.first.number)
                                : "----",
                            style: GoogleFonts.orbitron(
                                color: (darkmode)
                                    ? Colors.cyanAccent
                                    : Colors.pinkAccent,
                                fontWeight: FontWeight.bold)),
                        onTap: () {
                          if (contacts![index].phones.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Can't make call with this contact");
                          } else if ((contacts![index].phones.first.number)
                                  .toString()
                                  .length <
                              10) {
                            Fluttertoast.showToast(
                                msg: "Can't make call with this contact");
                          } else if ((contacts![index].phones.first.number)
                              .toString()
                              .contains(user.toString().substring(3, 13))) {
                            Fluttertoast.showToast(
                                msg: "Can't make call with yourself");
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: (darkmode == true)
                                        ? const Color(0xFF303030)
                                        : Colors.white.withOpacity(0.8),
                                    title: Text(
                                      "Voice/Video Call",
                                      style: GoogleFonts.orbitron(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: (darkmode == true)
                                              ? Colors.cyanAccent
                                              : Colors.pinkAccent),
                                    ),
                                    content: Text(
                                        "Voice/Video Call to ${contacts![index].name.first} ${contacts![index].name.last}",
                                        style: GoogleFonts.orbitron(
                                            color: (darkmode == true)
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold)),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        VideoCall(
                                                          callID: callIdFinder(
                                                              index),
                                                        )));
                                          },
                                          child: Text(
                                            "Videocall",
                                            style: GoogleFonts.orbitron(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: (darkmode == true)
                                                    ? Colors.cyanAccent
                                                    : Colors.pinkAccent),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        VoiceCall(
                                                          callID: callIdFinder(
                                                              index),
                                                        )));
                                          },
                                          child: Text(
                                            "Voicecall",
                                            style: GoogleFonts.orbitron(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: (darkmode == true)
                                                    ? Colors.cyanAccent
                                                    : Colors.pinkAccent),
                                          )),
                                    ],
                                  );
                                });
                          }
                        });
                  } else if (controller == "") {
                    return ListTile(
                        tileColor:
                            (darkmode) ? const Color(0xFF212121) : Colors.white,
                        leading: CircleAvatar(
                          backgroundColor:
                              (darkmode) ? Colors.grey : Colors.pinkAccent,
                          child: (contacts![index].phones.isNotEmpty)
                              ? ContactProfilePhotos(
                                  curruntnumber: (contacts![index]
                                          .phones
                                          .first
                                          .number
                                          .toString()
                                          .contains("+91")
                                      ? (contacts![index]
                                              .phones
                                              .first
                                              .number
                                              .toString())
                                          .replaceAll(' ', '')
                                      : ("+91${contacts![index].phones.first.number}")
                                          .replaceAll(' ', '')))
                              : const Icon(
                                  Icons.abc,
                                  color: Colors.white,
                                ),
                        ),
                        title: Text(
                          "${contacts![index].name.first} ${contacts![index].name.last}",
                          style: GoogleFonts.orbitron(
                              color: (darkmode) ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            (contacts![index].phones.isNotEmpty)
                                ? (contacts![index].phones.first.number)
                                : "----",
                            style: GoogleFonts.orbitron(
                                color: (darkmode)
                                    ? Colors.cyanAccent
                                    : Colors.pinkAccent,
                                fontWeight: FontWeight.bold)),
                        onTap: () {
                          if (contacts![index].phones.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Can't make call with this contact");
                          } else if ((contacts![index].phones.first.number)
                                  .toString()
                                  .length <
                              10) {
                            Fluttertoast.showToast(
                                msg: "Can't make call with this contact");
                          } else if ((contacts![index].phones.first.number)
                              .toString()
                              .contains(user.toString().substring(3, 13))) {
                            Fluttertoast.showToast(
                                msg: "Can't make call with yourself");
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: (darkmode == true)
                                        ? const Color(0xFF303030)
                                        : Colors.white.withOpacity(0.8),
                                    title: Text(
                                      "Voice/Video Call",
                                      style: GoogleFonts.orbitron(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: (darkmode == true)
                                              ? Colors.cyanAccent
                                              : Colors.pinkAccent),
                                    ),
                                    content: Text(
                                        "Voice/Video Call to ${contacts![index].name.first} ${contacts![index].name.last}",
                                        style: GoogleFonts.orbitron(
                                            color: (darkmode == true)
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold)),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        VideoCall(
                                                          callID: callIdFinder(
                                                              index),
                                                        )));
                                          },
                                          child: Text(
                                            "Videocall",
                                            style: GoogleFonts.orbitron(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: (darkmode == true)
                                                    ? Colors.cyanAccent
                                                    : Colors.pinkAccent),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        VoiceCall(
                                                          callID: callIdFinder(
                                                              index),
                                                        )));
                                          },
                                          child: Text(
                                            "Voicecall",
                                            style: GoogleFonts.orbitron(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                                color: (darkmode == true)
                                                    ? Colors.cyanAccent
                                                    : Colors.pinkAccent),
                                          )),
                                    ],
                                  );
                                });
                          }
                        });
                  } else {
                    return Container();
                  }
                },
              ));
  }
}
