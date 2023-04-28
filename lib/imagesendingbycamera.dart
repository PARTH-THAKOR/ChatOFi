// IMAGE SEND BY CAMERA ACTIVITY

import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatofi/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;

class ImageSendByCamera extends StatefulWidget {
  const ImageSendByCamera(
      {Key? key,
      required this.curruntUser,
      required this.cuadd,
      required this.cuaadd})
      : super(key: key);

  final String curruntUser;
  final double cuadd;
  final double cuaadd;

  @override
  State<ImageSendByCamera> createState() => _ImageSendByCameraState();
}

class _ImageSendByCameraState extends State<ImageSendByCamera> {
  File? _image;
  final picker = ImagePicker();
  final auth = FirebaseAuth.instance;
  bool loading = false;

  @override
  void initState() {
    getImageFromCamera();
    super.initState();
  }

  getImageFromCamera() async {
    final pickedImage =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    setState(() {
      (pickedImage != null)
          ? _image = File(pickedImage.path)
          : debugPrint("no img selected");
    });
  }

  @override
  Widget build(BuildContext context) {
    var fstore1 = FirebaseFirestore.instance.collection('post');
    var fstore = FirebaseFirestore.instance
        .collection('post')
        .doc(widget.cuadd.toString() + widget.cuaadd.toString())
        .collection('lol');
    final user = auth.currentUser?.phoneNumber;
    DateTime now = DateTime.now();
    var docId = DateTime.now().microsecondsSinceEpoch.toString();
    return Scaffold(
      backgroundColor: (darkmode) ? const Color(0xFF212121) : Colors.white,
      appBar: AppBar(
        leading: BackButton(color: (darkmode) ? Colors.white : Colors.black),
        title: Text(
          "Send Image",
          style: GoogleFonts.orbitron(
              color: (darkmode) ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: (darkmode)
            ? const Color(0xFF303030)
            : Colors.white.withOpacity(0.2),
      ),
      body: ListView(
        children: [
          InkWell(
            onTap: () {
              getImageFromCamera();
            },
            child: Container(
              margin: const EdgeInsets.only(top: 100, bottom: 10),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.3,
              child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 30,
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(500.0),
                          child: Image.file(File(_image!.path)))
                      : const Icon(
                          Icons.person,
                          color: Colors.black,
                          size: 35,
                        )),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            width: 100,
            margin:
                const EdgeInsets.only(top: 50, right: 50, left: 50, bottom: 20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  fs.Reference storage = fs.FirebaseStorage.instance.ref(docId);
                  fs.UploadTask uploadTask = storage.putFile(_image!.absolute);
                  Future.value(uploadTask).then((value) async {
                    var url = await storage.getDownloadURL();
                    fstore.doc(docId).set({
                      "id": widget.curruntUser + user.toString(),
                      "time": DateTime.now(),
                      "type": "img",
                      "deleteId": docId,
                      "time2":
                          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
                      "title": url
                    }).then((value) {
                      docId = DateTime.now().microsecondsSinceEpoch.toString();
                      fstore1
                          .doc(widget.cuadd.toString() +
                              widget.cuaadd.toString())
                          .set({
                            "id": widget.curruntUser + user.toString(),
                            "time": DateTime.now(),
                            "lastmsg": "Image",
                            "time2":
                                "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
                          })
                          .then((value) {})
                          .onError((error, stackTrace) {
                            Fluttertoast.showToast(msg: error.toString());
                          });
                      loading = false;
                      Navigator.pop(context);
                    }).onError((error, stackTrace) {
                      Fluttertoast.showToast(msg: error.toString());
                    });
                  });
                },
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                      (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
                    ),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27)))),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: (loading == true)
                      ? CircularProgressIndicator(
                          color: (darkmode) ? Colors.black : Colors.white,
                          strokeWidth: 3,
                        )
                      : Text("Send Image ",
                          style: GoogleFonts.orbitron(
                              color: (darkmode) ? Colors.black : Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                ),
              ),
            ),
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
}
