// LOGIN ACTIVITY

import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatofi/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool loading = false;
  var phonenumbercontroller = TextEditingController();
  static String namecontroller = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return logInScreen();
  }

  logInScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 70),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText('  Welcome !',
                      textStyle: GoogleFonts.orbitron(
                          color: Colors.pinkAccent,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                ],
                totalRepeatCount: 1,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 0),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText('  ChatOFi...',
                      textStyle: GoogleFonts.orbitron(
                          color: Colors.pinkAccent,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                ],
                totalRepeatCount: 1,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 70, bottom: 40),
              child: const Image(
                  image: AssetImage('images/dd.png'),
                  width: 150.0,
                  height: 150.0),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                  top: 15, bottom: 0, left: 20, right: 20),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  cursorColor: Colors.pinkAccent,
                  style: GoogleFonts.orbitron(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  onChanged: (value) {
                    namecontroller = value.toString();
                  },
                  decoration: InputDecoration(
                      hintText: "Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide:
                              const BorderSide(color: Colors.pinkAccent)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide:
                              const BorderSide(color: Colors.pinkAccent)),
                      hintStyle: GoogleFonts.orbitron(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            Container(
              margin:
                  const EdgeInsets.only(top: 3, bottom: 3, left: 20, right: 20),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  cursorColor: Colors.pinkAccent,
                  maxLength: 10,
                  controller: phonenumbercontroller,
                  style: GoogleFonts.orbitron(
                      fontSize: 20, fontWeight: FontWeight.bold),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      hintText: "Mobile Number",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide:
                              const BorderSide(color: Colors.pinkAccent)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide:
                              const BorderSide(color: Colors.pinkAccent)),
                      hintStyle: GoogleFonts.orbitron(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            Container(
              width: 200,
              margin: const EdgeInsets.only(
                  top: 0, right: 20, left: 20, bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () {
                    if (namecontroller.toString().isEmpty ||
                        phonenumbercontroller.text.toString().isEmpty ||
                        phonenumbercontroller.text.toString().length < 10) {
                      Fluttertoast.showToast(
                          msg:
                              "Enter name or mobile number or phonenumber should be 10 character");
                    } else {
                      setState(() {
                        loading = true;
                      });
                      _auth
                          .verifyPhoneNumber(
                              phoneNumber: "+91${phonenumbercontroller.text}",
                              verificationCompleted: (_) {},
                              verificationFailed: (e) {
                                setState(() {
                                  loading = false;
                                });
                                Fluttertoast.showToast(msg: e.toString());
                              },
                              codeSent: (String verificationId, int? token) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => OTPVerification(
                                              id: verificationId,
                                              name: namecontroller,
                                            )));
                              },
                              codeAutoRetrievalTimeout: (e) {})
                          .then((value) {});
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.pinkAccent),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(27)))),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: (loading == true)
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          )
                        : Text("LogIn",
                            style: GoogleFonts.orbitron(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}

class OTPVerification extends StatefulWidget {
  const OTPVerification({Key? key, required this.id, required this.name})
      : super(key: key);
  final String id;
  final String name;

  @override
  State<OTPVerification> createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  bool loading = false;
  static String code = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return otpVerifyPage();
  }

  otpVerifyPage() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 90),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText('  Let\'s Explore...',
                      textStyle: GoogleFonts.orbitron(
                          color: Colors.pinkAccent,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                ],
                totalRepeatCount: 1,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 90),
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText('  Enter OTP...',
                      textStyle: GoogleFonts.orbitron(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold)),
                ],
                totalRepeatCount: 1,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 100),
              child: OtpTextField(
                autoFocus: true,
                numberOfFields: 6,
                disabledBorderColor: Colors.pinkAccent,
                enabledBorderColor: Colors.pinkAccent,
                cursorColor: Colors.pinkAccent,
                textStyle: GoogleFonts.orbitron(
                    fontWeight: FontWeight.bold, fontSize: 17),
                showFieldAsBox: true,
                onCodeChanged: (String code) {
                  setState(() {
                    code = code.toString();
                  });
                },
                onSubmit: (String verificationCode) {
                  setState(() {
                    code = verificationCode.toString();
                  });
                }, // end onSubmit
              ),
            ),
            Container(
              width: 200,
              margin: const EdgeInsets.only(
                  top: 50, right: 20, left: 20, bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    final cread = PhoneAuthProvider.credential(
                        verificationId: widget.id.toString(),
                        smsCode: code.toString());
                    try {
                      await _auth.signInWithCredential(cread).then((value) {
                        final user = _auth.currentUser?.phoneNumber;
                        final fstore = FirebaseFirestore.instance
                            .collection("name${user.toString()}");
                        fstore.doc(user.toString()).set({
                          "id": user.toString(),
                          "time": DateTime.now(),
                          "title": widget.name
                        }).then((value) {
                          loading = false;
                        }).onError((error, stackTrace) {
                          Fluttertoast.showToast(msg: error.toString());
                        });
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Home()));
                        Fluttertoast.showToast(
                            msg: "Made with ❤️ by Parth Thakor");
                      });
                    } catch (e) {
                      setState(() {
                        loading = false;
                      });
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.pinkAccent),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(27)))),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: (loading == true)
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          )
                        : Text("Verify ",
                            style: GoogleFonts.orbitron(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 15, top: 90),
              alignment: Alignment.bottomCenter,
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText('  developers.roundrobin',
                      textStyle: GoogleFonts.orbitron(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                ],
                totalRepeatCount: 1,
              ),
            )
          ],
        ),
      ]),
    );
  }
}

void logIn(BuildContext context) {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final user = auth.currentUser;

  if (user != null) {
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const Home()));
    });
  } else {
    Timer(const Duration(seconds: 1), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LogInScreen()));
    });
  }
}
