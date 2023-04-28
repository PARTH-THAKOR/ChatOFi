//  THE PROFILE PHOTO ACTIVITY

import 'package:chatofi/settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePhotos extends StatelessWidget {
  const ProfilePhotos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final fstore2 = FirebaseFirestore.instance
        .collection("${auth.currentUser?.phoneNumber.toString()}")
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: fstore2,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color:
                    (darkmode == true) ? Colors.cyanAccent : Colors.deepPurple,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: CircularProgressIndicator(
                color:
                    (darkmode == true) ? Colors.cyanAccent : Colors.deepPurple,
              ),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return const Icon(Icons.people);
          } else {
            return snapshot.data!.docs[0]['id'].toString() ==
                        auth.currentUser?.phoneNumber &&
                    snapshot.data!.docs[0]['title'].toString().isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(500.0),
                    child: Image.network(
                        snapshot.data!.docs[0]['title'].toString()))
                : const Icon(
                    Icons.people,
                    color: Colors.deepPurple,
                  );
          }
        });
  }
}
