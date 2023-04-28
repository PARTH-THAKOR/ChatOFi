// CALL CONTACTS ACTIVITY

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatofi/contactprofilephotos.dart';
import 'package:chatofi/contactsorting.dart';
import 'package:chatofi/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'videovoicecalls.dart';

class CallContactsBackEnd extends StatefulWidget {
  const CallContactsBackEnd({Key? key}) : super(key: key);

  @override
  CallContactsBackEndState createState() => CallContactsBackEndState();
}

class CallContactsBackEndState extends State<CallContactsBackEnd> {
  List<Contact>? contacts;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getContact();
  }

  void getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      setState(() {});
    }
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
          title: AnimatedTextKit(
            animatedTexts: [
              TypewriterAnimatedText('My Contacts',
                  textStyle: GoogleFonts.orbitron(
                    color: (darkmode) ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  )),
            ],
            totalRepeatCount: 1,
          ),
          leading: BackButton(
            color: (darkmode) ? Colors.white : Colors.black,
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
              systemNavigationBarColor:
                  (darkmode == true) ? const Color(0xFF212121) : Colors.white),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SortingForCall()));
                },
                icon: Icon(
                  Icons.search,
                  color: (darkmode) ? Colors.white : Colors.black,
                )),
          ],
          backgroundColor: (darkmode)
              ? const Color(0xFF303030)
              : Colors.white.withOpacity(0.2),
        ),
        body: (contacts) == null
            ? Center(
                child: CircularProgressIndicator(
                    color: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent))
            : ListView.builder(
                itemCount: contacts!.length,
                itemBuilder: (BuildContext context, int index) {
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
                                Icons.people,
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
                                                        callID:
                                                            callIdFinder(index),
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
                                                        callID:
                                                            callIdFinder(index),
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
                },
              ));
  }
}

class CallContactsFrontEnd extends StatefulWidget {
  const CallContactsFrontEnd({Key? key}) : super(key: key);

  @override
  CallContactsFrontEndState createState() => CallContactsFrontEndState();
}

class CallContactsFrontEndState extends State<CallContactsFrontEnd> {
  List<Contact>? contacts = [];
  final auth = FirebaseAuth.instance;
  List<String> contacts2 = [];

  @override
  void initState() {
    super.initState();
    getContact();
  }

  void getContact() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: true);
      setState(() {});
    }
  }

  callIdFinder(String user, String curruntUser) {
    String callID = (user + curruntUser).replaceAll('+', '');
    String cu = curruntUser.replaceAll('+', '');
    String u = user.toString().replaceAll('+', '');
    double ciaadd = double.parse(cu) + double.parse(u);
    double ciadd = 0;

    for (int i = 0; i < 24; i++) {
      ciadd += double.parse(callID[i]);
    }

    return ciadd.toString() + ciaadd.toString();
  }

  contactIndexNameFinder(String number) {
    for (int i = 0; i < contacts!.length; i++) {
      if (contacts![i].phones.isNotEmpty) {
        contacts2.add((contacts![i]
                .phones
                .first
                .number
                .toString()
                .contains("+91")
            ? (contacts![i].phones.first.number.toString()).replaceAll(' ', '')
            : "+91${contacts![i].phones.first.number.replaceAll(' ', '')}"));
      }
    }

    for (int i = 0; i < contacts!.length; i++) {
      try {
        String curruntUser = (contacts![i].phones.isNotEmpty)
            ? (contacts![i].phones.first.number.toString().contains("+91")
                ? (contacts![i].phones.first.number.toString())
                    .replaceAll(' ', '')
                : "+91${contacts![i].phones.first.number.replaceAll(' ', '')}")
            : " ";
        if (number.contains(curruntUser) &&
            curruntUser != "${auth.currentUser?.phoneNumber.toString()}") {
          return Text("${contacts![i].name.first} ${contacts![i].name.last}",
              style: GoogleFonts.orbitron(
                  color: (darkmode) ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold));
        } else if (number.toString().substring(0, 13) ==
                auth.currentUser?.phoneNumber.toString() &&
            !contacts2.contains(number.toString().substring(13, 26))) {
          return Text(number.toString().substring(13, 26),
              style: GoogleFonts.orbitron(
                  color: (darkmode) ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold));
        } else if (number.toString().substring(13, 26) ==
                auth.currentUser?.phoneNumber.toString() &&
            !contacts2.contains(number.toString().substring(0, 13))) {
          return Text(number.toString().substring(0, 13),
              style: GoogleFonts.orbitron(
                  color: (darkmode) ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold));
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  contactIndexNameFinderString(String number) {
    for (int i = 0; i < contacts!.length; i++) {
      if (contacts![i].phones.isNotEmpty) {
        contacts2.add((contacts![i]
                .phones
                .first
                .number
                .toString()
                .contains("+91")
            ? (contacts![i].phones.first.number.toString()).replaceAll(' ', '')
            : "+91${contacts![i].phones.first.number.replaceAll(' ', '')}"));
      }
    }

    for (int i = 0; i < contacts!.length; i++) {
      try {
        String curruntUser = (contacts![i].phones.isNotEmpty)
            ? (contacts![i].phones.first.number.toString().contains("+91")
                ? (contacts![i].phones.first.number.toString())
                    .replaceAll(' ', '')
                : "+91${contacts![i].phones.first.number.replaceAll(' ', '')}")
            : " ";
        if (number.contains(curruntUser) &&
            curruntUser != "${auth.currentUser?.phoneNumber.toString()}") {
          return "${contacts![i].name.first} ${contacts![i].name.last}";
        } else if (number.toString().substring(0, 13) ==
                auth.currentUser?.phoneNumber.toString() &&
            !contacts2.contains(number.toString().substring(13, 26))) {
          return number.toString().substring(13, 26);
        } else if (number.toString().substring(13, 26) ==
                auth.currentUser?.phoneNumber.toString() &&
            !contacts2.contains(number.toString().substring(0, 13))) {
          return number.toString().substring(0, 13);
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser?.phoneNumber;
    final fstore2 = FirebaseFirestore.instance
        .collection('calls')
        .orderBy('time', descending: true)
        .snapshots();
    return Scaffold(
        backgroundColor: (darkmode) ? const Color(0xFF212121) : Colors.white,
        body: StreamBuilder<QuerySnapshot>(
            stream: fstore2,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: CircularProgressIndicator(
                    color: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
                  ),
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    "Let's start !",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.orbitron(
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent,
                        fontSize: 30),
                  ),
                );
              } else {
                bool here = true;
                for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  if (snapshot.data!.docs[i]['id']
                      .toString()
                      .contains(user.toString())) {
                    here = false;
                  }
                }
                if (here) {
                  return Center(
                    child: Text(
                      "No Calls",
                      style: GoogleFonts.orbitron(
                          fontWeight: FontWeight.bold,
                          color: (darkmode) ? Colors.white : Colors.black,
                          fontSize: 20),
                    ),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (snapshot.data!.docs[index]['id']
                          .toString()
                          .contains(user.toString())) {
                        if (snapshot.data!.docs[index]['id']
                                .toString()
                                .substring(0, 13) ==
                            user.toString()) {
                          return Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: ListTile(
                                tileColor: (darkmode)
                                    ? const Color(0xFF212121)
                                    : Colors.white,
                                leading: CircleAvatar(
                                    backgroundColor: (darkmode)
                                        ? Colors.grey
                                        : Colors.pinkAccent,
                                    child: ContactProfilePhotos(
                                        curruntnumber: snapshot
                                            .data!.docs[index]['id']
                                            .toString()
                                            .substring(13, 26))),
                                title: contactIndexNameFinder(
                                  snapshot.data!.docs[index]['id'],
                                ),
                                subtitle: Text("Activity : Outgoing",
                                    style: GoogleFonts.orbitron(
                                        color: (darkmode)
                                            ? Colors.white38
                                            : Colors.black.withOpacity(0.3),
                                        fontWeight: FontWeight.bold)),
                                trailing: Text(
                                    snapshot.data!.docs[index]['time2']
                                        .toString(),
                                    style: GoogleFonts.orbitron(
                                        color: (darkmode)
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold)),
                                onLongPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: (darkmode == true)
                                              ? const Color(0xFF303030)
                                              : Colors.white.withOpacity(0.8),
                                          title: Text("Delete Call",
                                              style: GoogleFonts.orbitron(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: (darkmode == true)
                                                      ? Colors.cyanAccent
                                                      : Colors.pinkAccent)),
                                          content: Text(
                                              "Delete Call with ${contactIndexNameFinderString(snapshot.data!.docs[index]['id'])} ?",
                                              style: GoogleFonts.orbitron(
                                                  color: (darkmode == true)
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold)),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  final fstore1 =
                                                      FirebaseFirestore.instance
                                                          .collection('calls');
                                                  fstore1
                                                      .doc(snapshot
                                                              .data!.docs[index]
                                                          ['deleteId'])
                                                      .delete();
                                                  Fluttertoast.showToast(
                                                      msg: "Call deleted");
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Delete",
                                                    style: GoogleFonts.orbitron(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: (darkmode ==
                                                                true)
                                                            ? Colors.cyanAccent
                                                            : Colors
                                                                .pinkAccent)))
                                          ],
                                        );
                                      });
                                },
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: (darkmode == true)
                                              ? const Color(0xFF303030)
                                              : Colors.white.withOpacity(0.8),
                                          title: Text("Voice/Video Call",
                                              style: GoogleFonts.orbitron(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: (darkmode == true)
                                                      ? Colors.cyanAccent
                                                      : Colors.pinkAccent)),
                                          content: Text(
                                              "make Voice/Video call ${contactIndexNameFinderString(snapshot.data!.docs[index]['id'])}",
                                              style: GoogleFonts.orbitron(
                                                  color: (darkmode == true)
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold)),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  final fstore =
                                                      FirebaseFirestore.instance
                                                          .collection('calls');
                                                  DateTime now = DateTime.now();

                                                  var deleteId = DateTime.now()
                                                      .millisecondsSinceEpoch
                                                      .toString();
                                                  fstore.doc(deleteId).set({
                                                    "id": user.toString() +
                                                        snapshot.data!
                                                            .docs[index]['id']
                                                            .toString()
                                                            .substring(13, 26),
                                                    "time": DateTime.now(),
                                                    "deleteId": deleteId,
                                                    "time2":
                                                        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
                                                  }).then((value) {
                                                    deleteId = DateTime.now()
                                                        .millisecondsSinceEpoch
                                                        .toString();
                                                  }).onError(
                                                      (error, stackTrace) {
                                                    Fluttertoast.showToast(
                                                        msg: error.toString());
                                                  });
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  VideoCall(
                                                                    callID: callIdFinder(
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index][
                                                                                'id']
                                                                            .toString()
                                                                            .substring(0,
                                                                                13),
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index][
                                                                                'id']
                                                                            .toString()
                                                                            .substring(13,
                                                                                26)),
                                                                  )));
                                                },
                                                child: Text("Videocall",
                                                    style: GoogleFonts.orbitron(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: (darkmode ==
                                                                true)
                                                            ? Colors.cyanAccent
                                                            : Colors
                                                                .pinkAccent))),
                                            TextButton(
                                                onPressed: () {
                                                  final fstore =
                                                      FirebaseFirestore.instance
                                                          .collection('calls');
                                                  DateTime now = DateTime.now();

                                                  var deleteId = DateTime.now()
                                                      .millisecondsSinceEpoch
                                                      .toString();

                                                  fstore.doc(deleteId).set({
                                                    "id": user.toString() +
                                                        snapshot.data!
                                                            .docs[index]['id']
                                                            .toString()
                                                            .substring(13, 26),
                                                    "time": DateTime.now(),
                                                    "deleteId": deleteId,
                                                    "time2":
                                                        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
                                                  }).then((value) {
                                                    deleteId = DateTime.now()
                                                        .millisecondsSinceEpoch
                                                        .toString();
                                                  }).onError(
                                                      (error, stackTrace) {
                                                    Fluttertoast.showToast(
                                                        msg: error.toString());
                                                  });
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  VoiceCall(
                                                                    callID: callIdFinder(
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index][
                                                                                'id']
                                                                            .toString()
                                                                            .substring(0,
                                                                                13),
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index][
                                                                                'id']
                                                                            .toString()
                                                                            .substring(13,
                                                                                26)),
                                                                  )));
                                                },
                                                child: Text("Voicecall",
                                                    style: GoogleFonts.orbitron(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: (darkmode ==
                                                                true)
                                                            ? Colors.cyanAccent
                                                            : Colors
                                                                .pinkAccent))),
                                          ],
                                        );
                                      });
                                }),
                          );
                        } else {
                          return Container(
                            margin: const EdgeInsets.only(top: 5),
                            child: ListTile(
                                leading: CircleAvatar(
                                    backgroundColor: (darkmode)
                                        ? Colors.grey
                                        : Colors.pinkAccent,
                                    child: ContactProfilePhotos(
                                        curruntnumber: snapshot
                                            .data!.docs[index]['id']
                                            .toString()
                                            .substring(0, 13))),
                                title: contactIndexNameFinder(
                                    snapshot.data!.docs[index]['id']),
                                subtitle: Text("Activity : Incoming",
                                    style: GoogleFonts.orbitron(
                                        color: (darkmode)
                                            ? Colors.white38
                                            : Colors.black.withOpacity(0.3),
                                        fontWeight: FontWeight.bold)),
                                trailing: Text(snapshot.data!.docs[index]['time2'].toString(),
                                    style: GoogleFonts.orbitron(
                                        color:
                                            (darkmode) ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.bold)),
                                onLongPress: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: (darkmode == true)
                                              ? const Color(0xFF303030)
                                              : Colors.white.withOpacity(0.8),
                                          title: Text("Delete Call",
                                              style: GoogleFonts.orbitron(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: (darkmode == true)
                                                      ? Colors.cyanAccent
                                                      : Colors.pinkAccent)),
                                          content: Text(
                                              "Delete Call with ${contactIndexNameFinderString(snapshot.data!.docs[index]['id'])} ?",
                                              style: GoogleFonts.orbitron(
                                                  color: (darkmode == true)
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold)),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  final fstore1 =
                                                      FirebaseFirestore.instance
                                                          .collection('calls');
                                                  fstore1
                                                      .doc(snapshot
                                                              .data!.docs[index]
                                                          ['deleteId'])
                                                      .delete();
                                                  Fluttertoast.showToast(
                                                      msg: "Call deleted");
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Delete",
                                                    style: GoogleFonts.orbitron(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: (darkmode ==
                                                                true)
                                                            ? Colors.cyanAccent
                                                            : Colors
                                                                .pinkAccent)))
                                          ],
                                        );
                                      });
                                },
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          backgroundColor: (darkmode == true)
                                              ? const Color(0xFF303030)
                                              : Colors.white.withOpacity(0.8),
                                          title: Text("Voice/Video Call",
                                              style: GoogleFonts.orbitron(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.bold,
                                                  color: (darkmode == true)
                                                      ? Colors.cyanAccent
                                                      : Colors.pinkAccent)),
                                          content: Text(
                                              "Voice/Video Call to ${contactIndexNameFinderString(snapshot.data!.docs[index]['id'])}",
                                              style: GoogleFonts.orbitron(
                                                  color: (darkmode == true)
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold)),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  final fstore =
                                                      FirebaseFirestore.instance
                                                          .collection('calls');
                                                  DateTime now = DateTime.now();

                                                  var deleteId = DateTime.now()
                                                      .millisecondsSinceEpoch
                                                      .toString();

                                                  fstore.doc(deleteId).set({
                                                    "id": user.toString() +
                                                        snapshot.data!
                                                            .docs[index]['id']
                                                            .toString()
                                                            .substring(0, 13),
                                                    "time": DateTime.now(),
                                                    "deleteId": deleteId,
                                                    "time2":
                                                        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
                                                  }).then((value) {
                                                    deleteId = DateTime.now()
                                                        .millisecondsSinceEpoch
                                                        .toString();
                                                  }).onError(
                                                      (error, stackTrace) {
                                                    Fluttertoast.showToast(
                                                        msg: error.toString());
                                                  });
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  VideoCall(
                                                                    callID: callIdFinder(
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index][
                                                                                'id']
                                                                            .toString()
                                                                            .substring(0,
                                                                                13),
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index][
                                                                                'id']
                                                                            .toString()
                                                                            .substring(13,
                                                                                26)),
                                                                  )));
                                                },
                                                child: Text("Videocall",
                                                    style: GoogleFonts.orbitron(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: (darkmode ==
                                                                true)
                                                            ? Colors.cyanAccent
                                                            : Colors
                                                                .pinkAccent))),
                                            TextButton(
                                                onPressed: () {
                                                  final fstore =
                                                      FirebaseFirestore.instance
                                                          .collection('calls');
                                                  DateTime now = DateTime.now();

                                                  var deleteId = DateTime.now()
                                                      .millisecondsSinceEpoch
                                                      .toString();

                                                  fstore.doc(deleteId).set({
                                                    "id": user.toString() +
                                                        snapshot.data!
                                                            .docs[index]['id']
                                                            .toString()
                                                            .substring(0, 13),
                                                    "time": DateTime.now(),
                                                    "deleteId": deleteId,
                                                    "time2":
                                                        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
                                                  }).then((value) {
                                                    deleteId = DateTime.now()
                                                        .millisecondsSinceEpoch
                                                        .toString();
                                                  }).onError(
                                                      (error, stackTrace) {
                                                    Fluttertoast.showToast(
                                                        msg: error.toString());
                                                  });
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  VoiceCall(
                                                                    callID: callIdFinder(
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index][
                                                                                'id']
                                                                            .toString()
                                                                            .substring(0,
                                                                                13),
                                                                        snapshot
                                                                            .data!
                                                                            .docs[index][
                                                                                'id']
                                                                            .toString()
                                                                            .substring(13,
                                                                                26)),
                                                                  )));
                                                },
                                                child: Text("Voicecall",
                                                    style: GoogleFonts.orbitron(
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: (darkmode ==
                                                                true)
                                                            ? Colors.cyanAccent
                                                            : Colors
                                                                .pinkAccent))),
                                          ],
                                        );
                                      });
                                }),
                          );
                        }
                      } else {
                        return Container();
                      }
                    },
                  );
                }
              }
            }));
  }
}

deleteAllCallLog() async {
  final user = FirebaseAuth.instance.currentUser?.phoneNumber;
  final fstoresnapshot = FirebaseFirestore.instance.collection('calls');
  var list = await fstoresnapshot.get();
  for (int i = 0; i < list.size; i++) {
    if (list.docs[i]['id'].toString().contains(user.toString())) {
      fstoresnapshot.doc(list.docs[i]['deleteId'].toString()).delete();
    }
  }
}
