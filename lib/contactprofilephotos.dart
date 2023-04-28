// PROFILE-PHOTO ACTIVITY

import 'package:chatofi/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ContactProfilePhotos extends StatefulWidget {
  const ContactProfilePhotos({Key? key, required this.curruntnumber})
      : super(key: key);

  final String curruntnumber;

  @override
  State<ContactProfilePhotos> createState() => _ContactProfilePhotosState();
}

class _ContactProfilePhotosState extends State<ContactProfilePhotos> {
  final texter = TextEditingController();
  final auth = FirebaseAuth.instance;
  final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final fstore2 =
        FirebaseFirestore.instance.collection(widget.curruntnumber).snapshots();
    return StreamBuilder<QuerySnapshot>(
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
            return const Icon(
              Icons.people,
              color: Colors.white,
            );
          } else {
            return snapshot.data!.docs[0]['id'].toString() ==
                        widget.curruntnumber &&
                    snapshot.data!.docs[0]['title'].toString().isNotEmpty
                ? InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PreviewPage(
                                  pictureUrl: snapshot.data!.docs[0]['title']
                                      .toString())));
                    },
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(500.0),
                        child: Image.network(
                            snapshot.data!.docs[0]['title'].toString())),
                  )
                : const Icon(
                    Icons.people,
                    color: Colors.white,
                  );
          }
        });
  }
}

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.pictureUrl}) : super(key: key);

  final String pictureUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: (darkmode) ? const Color(0xFF212121) : Colors.white,
        appBar: AppBar(
            leading:
                BackButton(color: (darkmode) ? Colors.white : Colors.black),
            title: Text(
              'Image view',
              style: GoogleFonts.orbitron(
                  color: (darkmode) ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: (darkmode)
                ? const Color(0xFF303030)
                : Colors.white.withOpacity(0.2)),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FittedBox(
            child: Image.network(pictureUrl),
          ),
        ));
  }
}
