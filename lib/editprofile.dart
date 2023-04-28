// EDIT PROFILE ACTIVITY

import 'dart:io';
import 'package:chatofi/profilephotos.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatofi/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;

class EditProfile extends StatelessWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late String hinttext = "Hey ! there, I am using ChatOFi";
    final auth = FirebaseAuth.instance;
    final fstore2 = FirebaseFirestore.instance
        .collection("About${auth.currentUser?.phoneNumber.toString()}")
        .snapshots();
    return Scaffold(
      backgroundColor:
          (darkmode == true) ? const Color(0xFF212121) : Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor:
                (darkmode == true) ? const Color(0xFF212121) : Colors.white),
        leading: BackButton(
          color: (darkmode) ? Colors.white : Colors.black,
        ),
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText('Profile',
                textStyle: GoogleFonts.orbitron(
                    fontWeight: FontWeight.bold,
                    color: (darkmode) ? Colors.white : Colors.black)),
          ],
          totalRepeatCount: 1,
        ),
        backgroundColor: (darkmode == true)
            ? const Color(0xFF303030)
            : Colors.white.withOpacity(0.2),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10),
        child: ListView(
          children: [
            const SizedBox(
              height: 30,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Text(
                  "Profile photo ",
                  style: GoogleFonts.orbitron(
                      fontWeight: FontWeight.bold,
                      color: (darkmode == true) ? Colors.white : Colors.black),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              title: Text(
                " LongPress on circle to update Profile Pic !",
                textAlign: TextAlign.center,
                style: GoogleFonts.orbitron(
                    fontWeight: FontWeight.bold,
                    color: (darkmode == true)
                        ? Colors.cyanAccent
                        : Colors.pinkAccent),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            InkWell(
              onTap: () {
                Fluttertoast.showToast(msg: "LongPress to edit ProfilePic");
              },
              onLongPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileImage()));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, right: 10),
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.3,
                child: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    radius: 30,
                    child: ProfilePhotos()),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                Text(
                  "Status",
                  style: GoogleFonts.orbitron(
                      fontWeight: FontWeight.bold,
                      color: (darkmode == true) ? Colors.white : Colors.black),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              title: Text(
                " LongPress on your Status to Update !",
                textAlign: TextAlign.center,
                style: GoogleFonts.orbitron(
                    fontWeight: FontWeight.bold,
                    color: (darkmode == true)
                        ? Colors.cyanAccent
                        : Colors.pinkAccent),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 10, top: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(
                      color: (darkmode == true)
                          ? Colors.cyanAccent
                          : Colors.pinkAccent)),
              child: ListTile(
                title: StreamBuilder<QuerySnapshot>(
                    stream: fstore2,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text(".....",
                            style: GoogleFonts.orbitron(
                                fontWeight: FontWeight.bold, fontSize: 26));
                      } else if (snapshot.hasError) {
                        return Text(".....",
                            style: GoogleFonts.orbitron(
                                fontWeight: FontWeight.bold, fontSize: 26));
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Text(hinttext,
                            style: GoogleFonts.orbitron(
                                fontWeight: FontWeight.bold, fontSize: 26));
                      } else {
                        return snapshot.data!.docs[0]['id'].toString() ==
                                auth.currentUser?.phoneNumber
                            ? Text(
                                snapshot.data!.docs[0]['title'],
                                style: GoogleFonts.orbitron(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26,
                                    color: (darkmode == true)
                                        ? Colors.white
                                        : Colors.black),
                              )
                            : const Text("......",
                                style: TextStyle(
                                    fontSize: 25, color: Colors.black));
                      }
                    }),
                onTap: () {
                  Fluttertoast.showToast(msg: "LongPress to edit Status");
                },
                onLongPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileStatus()));
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              color:
                  (darkmode == true) ? const Color(0xFF212121) : Colors.white,
              margin: const EdgeInsets.only(top: 25),
              alignment: Alignment.bottomCenter,
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText('  developers.roundrobin',
                      textStyle: GoogleFonts.orbitron(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: (darkmode == true)
                              ? Colors.white
                              : Colors.black)),
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

class ProfileImage extends StatefulWidget {
  const ProfileImage({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  File? _image;
  final picker = ImagePicker();
  final auth = FirebaseAuth.instance;
  bool loading = false;

  @override
  void initState() {
    getImageFromGallery();
    super.initState();
  }

  getImageFromGallery() async {
    final pickedImage =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      (pickedImage != null)
          ? _image = File(pickedImage.path)
          : debugPrint("no img selected");
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser?.phoneNumber;
    final fstore = FirebaseFirestore.instance.collection(user.toString());
    DateTime now = DateTime.now();
    return Scaffold(
      backgroundColor:
          (darkmode == true) ? const Color(0xFF212121) : Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor:
                (darkmode == true) ? const Color(0xFF212121) : Colors.white),
        leading: BackButton(color: (darkmode) ? Colors.white : Colors.black),
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText('Edit Profile Pic...',
                textStyle: GoogleFonts.orbitron(
                    fontWeight: FontWeight.bold,
                    color: (darkmode) ? Colors.white : Colors.black)),
          ],
          totalRepeatCount: 1,
        ),
        backgroundColor: (darkmode == true)
            ? const Color(0xFF212121)
            : Colors.white.withOpacity(0.2),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 50, left: 30),
            child: Text(
              "Select Image...",
              style: GoogleFonts.orbitron(
                fontWeight: FontWeight.bold,
                color: (darkmode == true) ? Colors.white : Colors.black,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              getImageFromGallery();
            },
            child: Container(
              margin: const EdgeInsets.only(top: 40, right: 20, left: 20),
              height: 300,
              child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 30,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(500.0),
                    child: _image != null
                        ? Image.file(File(_image!.path))
                        : const Icon(
                            Icons.person,
                            size: 35,
                            color: Colors.black,
                          ),
                  )),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            margin:
                const EdgeInsets.only(top: 0, right: 75, left: 75, bottom: 20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  if (_image != null) {
                    setState(() {
                      loading = true;
                    });
                    fs.Reference storage =
                        fs.FirebaseStorage.instance.ref(user.toString());
                    fs.UploadTask uploadTask =
                        storage.putFile(_image!.absolute);
                    Future.value(uploadTask).then((value) async {
                      var url = await storage.getDownloadURL();
                      fstore.doc(user.toString()).set({
                        "id": user.toString(),
                        "time": DateTime.now(),
                        "type": "img",
                        "time2": "${now.hour}:${now.minute}",
                        "title": url
                      }).then((value) {
                        loading = false;
                        Navigator.pop(context);
                      }).onError((error, stackTrace) {
                        Fluttertoast.showToast(msg: error.toString());
                      });
                    });
                  } else {
                    Fluttertoast.showToast(msg: "Select Image");
                  }
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      (darkmode == true)
                          ? Colors.cyanAccent
                          : Colors.pinkAccent,
                    ),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27)))),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: (loading == true)
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        )
                      : Text("Set Profile Pic..",
                          style: GoogleFonts.orbitron(
                              color: (darkmode == true)
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
              totalRepeatCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileStatus extends StatefulWidget {
  const ProfileStatus({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileStatus> createState() => _ProfileStatusState();
}

class _ProfileStatusState extends State<ProfileStatus> {
  bool loading = false;
  final statuscontroller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          (darkmode == true) ? const Color(0xFF212121) : Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor:
                (darkmode == true) ? const Color(0xFF212121) : Colors.white),
        leading: BackButton(color: (darkmode) ? Colors.white : Colors.black),
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText('Edit Status...',
                textStyle: GoogleFonts.orbitron(
                    fontWeight: FontWeight.bold,
                    color: (darkmode) ? Colors.white : Colors.black)),
          ],
          totalRepeatCount: 1,
        ),
        backgroundColor: (darkmode == true)
            ? const Color(0xFF212121)
            : Colors.white.withOpacity(0.2),
      ),
      body: ListView(children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 90),
              child: Text(
                "Edit Status !",
                style: GoogleFonts.orbitron(
                    fontWeight: FontWeight.bold,
                    color: (darkmode == true)
                        ? Colors.cyanAccent
                        : Colors.pinkAccent,
                    fontSize: 30),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: TextFormField(
                  cursorColor: (darkmode == true)
                      ? Colors.cyanAccent
                      : Colors.pinkAccent,
                  controller: statuscontroller,
                  style: GoogleFonts.orbitron(
                      color: (darkmode == true) ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Enter new Status",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: (darkmode == true)
                              ? Colors.cyanAccent
                              : Colors.pinkAccent,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: (darkmode == true)
                              ? Colors.cyanAccent
                              : Colors.pinkAccent,
                        )),
                    hintStyle: GoogleFonts.orbitron(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: (darkmode == true) ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                  top: 0, right: 75, left: 75, bottom: 20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: () async {
                    if (statuscontroller.text.toString().isNotEmpty) {
                      setState(() {
                        loading = true;
                      });
                      final user = _auth.currentUser?.phoneNumber;
                      final fstore = FirebaseFirestore.instance
                          .collection("About${user.toString()}");
                      fstore.doc(user.toString()).set({
                        "id": user.toString(),
                        "time": DateTime.now(),
                        "title": statuscontroller.text.toString()
                      }).then((value) {
                        loading = false;
                      }).onError((error, stackTrace) {
                        Fluttertoast.showToast(msg: error.toString());
                      });
                      Navigator.pop(context);
                    } else {
                      Fluttertoast.showToast(msg: "Write Status...");
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        (darkmode == true)
                            ? Colors.cyanAccent
                            : Colors.pinkAccent,
                      ),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(27)))),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: (loading == true)
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          )
                        : Text("Update Status",
                            style: GoogleFonts.orbitron(
                                color: (darkmode == true)
                                    ? Colors.black
                                    : Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              color:
                  (darkmode == true) ? const Color(0xFF212121) : Colors.white,
              margin: const EdgeInsets.only(top: 25),
              alignment: Alignment.bottomCenter,
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText('  developers.roundrobin',
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
      ]),
    );
  }
}
