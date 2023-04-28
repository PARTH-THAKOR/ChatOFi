// APPLICATION SETTING ACTIVITY

import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatofi/editprofile.dart';
import 'package:chatofi/profilephotos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restart_app/restart_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

bool fingerlock = false;
bool darkmode = false;

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  void initState() {
    setState(() {
      getDarkModeSwitch();
      getFingerLockSwitch();
    });
    super.initState();
  }

  getFingerLockSwitch() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey("fp")) {
      setState(() {
        fingerlock = sharedPreferences.getBool("fp")!;
      });
    } else {
      setState(() {
        fingerlock = false;
      });
    }
  }

  getDarkModeSwitch() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.containsKey("dm")) {
      setState(() {
        darkmode = sharedPreferences.getBool("dm")!;
      });
    } else {
      setState(() {
        darkmode = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final fstore2 = FirebaseFirestore.instance
        .collection("name${auth.currentUser?.phoneNumber.toString()}")
        .snapshots();
    return Scaffold(
      backgroundColor:
          (darkmode == true) ? const Color(0xFF212121) : Colors.white,
      appBar: AppBar(
        backgroundColor: (darkmode == true)
            ? const Color(0xFF303030)
            : Colors.white.withOpacity(0.2),
        leading: BackButton(
          color: (darkmode) ? Colors.white : Colors.black,
        ),
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText('Settings',
                textStyle: GoogleFonts.orbitron(
                  color: (darkmode) ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                )),
          ],
          totalRepeatCount: 1,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10),
        child: ListView(
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: const EdgeInsets.only(right: 10, bottom: 25, top: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                    color: (darkmode == true)
                        ? Colors.cyanAccent
                        : Colors.pinkAccent,
                  )),
              child: ListTile(
                onTap: () {},
                leading: CircleAvatar(
                  backgroundColor: (darkmode) ? Colors.white : Colors.black,
                  child: const CircleAvatar(
                      backgroundColor: Color(0xffE6E6E6),
                      radius: 30,
                      child: ProfilePhotos()),
                ),
                title: StreamBuilder<QuerySnapshot>(
                    stream: fstore2,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(
                          "Username",
                          style: GoogleFonts.orbitron(
                              color: (darkmode == true)
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          "Username",
                          style: GoogleFonts.orbitron(
                              color: (darkmode == true)
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        );
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Text(
                          "Username",
                          style: GoogleFonts.orbitron(
                              color: (darkmode == true)
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        );
                      } else {
                        return snapshot.data!.docs[0]['id'].toString() ==
                                auth.currentUser?.phoneNumber
                            ? Text(
                                snapshot.data!.docs[0]['title'],
                                style: GoogleFonts.orbitron(
                                    color: (darkmode == true)
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                              )
                            : Text(
                                "Username",
                                style: GoogleFonts.orbitron(
                                    color: (darkmode == true)
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              );
                      }
                    }),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.edit_rounded,
                color:
                    (darkmode == true) ? Colors.cyanAccent : Colors.pinkAccent,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfile()));
              },
              title: Text(
                "Edit Profile",
                style: GoogleFonts.orbitron(
                    color: (darkmode == true) ? Colors.white : Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Edit profile photo and status",
                  style: GoogleFonts.orbitron(
                      fontWeight: FontWeight.bold,
                      color: (darkmode == true) ? Colors.white : Colors.black)),
            ),
            const SizedBox(
              height: 5,
            ),
            ListTile(
              leading: Icon(
                Icons.dark_mode,
                color:
                    (darkmode == true) ? Colors.cyanAccent : Colors.pinkAccent,
              ),
              onTap: () {},
              trailing: Switch(
                  activeColor: (darkmode == true)
                      ? Colors.cyanAccent
                      : Colors.pinkAccent,
                  value: darkmode,
                  onChanged: (value) async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    setState(() {
                      darkmode = value;
                      sharedPreferences.setBool("dm", value);
                      Restart.restartApp();
                    });
                  }),
              title: Text(
                "Theme Mode",
                style: GoogleFonts.orbitron(
                    color: (darkmode == true) ? Colors.white : Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Change theme dark/light",
                  style: GoogleFonts.orbitron(
                      color: (darkmode == true) ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 5,
            ),
            ListTile(
              leading: Icon(
                Icons.lock,
                color:
                    (darkmode == true) ? Colors.cyanAccent : Colors.pinkAccent,
              ),
              trailing: Switch(
                  activeColor: (darkmode == true)
                      ? Colors.cyanAccent
                      : Colors.pinkAccent,
                  value: fingerlock,
                  onChanged: (value) async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    setState(() {
                      fingerlock = value;
                      sharedPreferences.setBool("fp", value);
                      Restart.restartApp();
                    });
                  }),
              title: Text(
                "FingerPrint Lock",
                style: GoogleFonts.orbitron(
                    color: (darkmode == true) ? Colors.white : Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Enable FingerPrint Lock",
                  style: GoogleFonts.orbitron(
                      color: (darkmode == true) ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold)),
              onTap: () {},
            ),
            const SizedBox(
              height: 5,
            ),
            ListTile(
              leading: Icon(
                Icons.apps,
                color:
                    (darkmode == true) ? Colors.cyanAccent : Colors.pinkAccent,
              ),
              title: Text(
                "About App",
                style: GoogleFonts.orbitron(
                    color: (darkmode == true) ? Colors.white : Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Know the version of app",
                  style: GoogleFonts.orbitron(
                      color: (darkmode == true) ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold)),
              onTap: () {
                Fluttertoast.showToast(msg: "ChatOFi     v2.0.3");
              },
            ),
            const SizedBox(
              height: 5,
            ),
            ListTile(
              leading: Icon(
                Icons.web,
                color:
                    (darkmode == true) ? Colors.cyanAccent : Colors.pinkAccent,
              ),
              title: Text(
                "know about Developers",
                style: GoogleFonts.orbitron(
                    color: (darkmode == true) ? Colors.white : Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Visit Roundrobin...",
                  style: GoogleFonts.orbitron(
                      color: (darkmode == true) ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold)),
              onTap: () async {
                var url =
                    Uri.parse("https://developers-roundrobin.netlify.app");

                await launchUrl(url);
              },
            ),
            const SizedBox(
              height: 5,
            ),
            ListTile(
              leading: Icon(
                Icons.logout_outlined,
                color:
                    (darkmode == true) ? Colors.cyanAccent : Colors.pinkAccent,
              ),
              title: Text(
                "Log out",
                style: GoogleFonts.orbitron(
                    color: (darkmode == true) ? Colors.white : Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: (darkmode == true)
                            ? const Color(0xFF303030)
                            : Colors.white.withOpacity(0.8),
                        title: Text(
                          "SignOut",
                          style: GoogleFonts.orbitron(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: (darkmode == true)
                                  ? Colors.cyanAccent
                                  : Colors.pinkAccent),
                        ),
                        content: Text(
                          "Do you want to SignOut from ChatOFi ?",
                          style: GoogleFonts.orbitron(
                              color: (darkmode == true)
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                        actions: [
                          TextButton(
                              onPressed: () {
                                auth.signOut().then((value) => exit(0));
                              },
                              child: Text(
                                "SignOut",
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
              subtitle: Text("Log out from ChatOFi...",
                  style: GoogleFonts.orbitron(
                      color: (darkmode == true) ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold)),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              color:
                  (darkmode == true) ? const Color(0xFF212121) : Colors.white,
              margin: const EdgeInsets.only(top: 25),
              alignment: Alignment.bottomCenter,
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText('developers.roundrobin',
                      textStyle: GoogleFonts.orbitron(
                          color:
                              (darkmode == true) ? Colors.white : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
                totalRepeatCount: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
