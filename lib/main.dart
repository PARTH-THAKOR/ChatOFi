// THE CHATOFI PROJECT

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:firebase_storage/firebase_storage.dart' as fs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

toast() {
  return Fluttertoast.showToast(
      msg: "Coming Soon !",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      webPosition: "center",
      webBgColor: "black",
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ChatOFi",
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    SplashServices().logIn(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return splashScreenPage();
  }

  splashScreenPage() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Container(
            color: Colors.white,
            margin: const EdgeInsets.only(top: 270),
            alignment: Alignment.topCenter,
            child: splashScreenImage(),
          ),
          Container(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 20, top: 190),
            alignment: Alignment.bottomCenter,
            child: const Text(
              "from",
              style: TextStyle(fontSize: 10, color: Colors.deepPurple),
            ),
          ),
          Container(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 15),
            alignment: Alignment.bottomCenter,
            child: const Text(
              "ROUNDROBIN",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
          )
        ],
      ),
    );
  }

  splashScreenImage() {
    AssetImage assetImage = const AssetImage('images/dd.png');
    Image image = Image(image: assetImage, width: 200.0, height: 200.0);
    return image;
  }
}

class SplashServices {
  void logIn(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      Timer(const Duration(seconds: 2), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const MainApp()));
      });
    } else {
      Timer(const Duration(seconds: 2), () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LogInScreen()));
      });
    }
  }
}

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool loading = false;
  AssetImage assetImage = const AssetImage('images/dd.png');
  var phonenumbercontroller = TextEditingController();
  static String namecontroller = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 70),
              child: const Text(
                "Welcome !",
                style: TextStyle(fontSize: 30, color: Colors.deepPurple),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 0),
              child: const Text(
                "ChatOFi",
                style: TextStyle(fontSize: 30, color: Colors.deepPurple),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 70, bottom: 40),
              child: Image(image: assetImage, width: 150.0, height: 150.0),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                  top: 15, bottom: 0, left: 20, right: 20),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  cursorColor: Colors.deepPurple,
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                  onChanged: (value) {
                    namecontroller = value.toString();
                  },
                  decoration: const InputDecoration(
                    hintText: "Name",
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple)),
                    hintStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin:
                  const EdgeInsets.only(top: 3, bottom: 3, left: 20, right: 20),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  cursorColor: Colors.deepPurple,
                  maxLength: 10,
                  controller: phonenumbercontroller,
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Mobile Number",
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple)),
                    hintStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
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
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.deepPurple)),
                  onPressed: () {
                    if (namecontroller.toString().isEmpty ||
                        phonenumbercontroller.text.toString().isEmpty) {
                      Fluttertoast.showToast(
                          msg: "Enter name or mobile number");
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MobileNumberVerify(
                                              id: verificationId,
                                              name: namecontroller,
                                            )));
                              },
                              codeAutoRetrievalTimeout: (e) {
                                Fluttertoast.showToast(msg: e.toString());
                              })
                          .then((value) {});
                    }
                  },
                  child: (loading == true)
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Log In",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
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

class MobileNumberVerify extends StatefulWidget {
  const MobileNumberVerify({Key? key, required this.id, required this.name})
      : super(key: key);
  final String id;
  final String name;

  @override
  State<MobileNumberVerify> createState() => _MobileNumberVerifyState();
}

class _MobileNumberVerifyState extends State<MobileNumberVerify> {
  bool loading = false;
  AssetImage assetImage = const AssetImage('images/dd.png');
  final phonenumbercontroller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 90),
              child: const Text(
                "Let's Explore",
                style: TextStyle(fontSize: 30, color: Colors.deepPurple),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 70, bottom: 40),
              child: Image(image: assetImage, width: 150.0, height: 150.0),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  cursorColor: Colors.deepPurple,
                  controller: phonenumbercontroller,
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: "Enter OTP",
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple)),
                    hintStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
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
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.deepPurple)),
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    final cread = PhoneAuthProvider.credential(
                        verificationId: widget.id.toString(),
                        smsCode: phonenumbercontroller.text.toString());
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
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainApp()));
                        Fluttertoast.showToast(
                            msg: "Made with ❤️ by Parth Thakor");
                      });
                    } catch (e) {
                      setState(() {
                        loading = false;
                      });
                      Fluttertoast.showToast(msg: e.toString());
                    }
                  },
                  child: (loading == true)
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Verify",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
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

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with TickerProviderStateMixin {
  late TabController tabController;
  var length = 1;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 1, length: 4, vsync: this);
    tabController.addListener(() {
      setState(() {
        length = tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return startingOfMainApp(context);
  }

  startingOfMainApp(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: mainScafFoldBody(context),
    );
  }

  appBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        "ChatOFi",
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.deepPurple,
      actions: appBarActionButtons(context),
      bottom: tabBar(),
    );
  }

  appBarActionButtons(BuildContext context) {
    if (length == 3) {
      return [
        Container(
            width: 40,
            margin: const EdgeInsets.only(top: 10, bottom: 15, right: 8),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ImageManagementForProfileByCamera()));
              },
              icon: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
              ),
            )),
        Container(
            width: 40,
            margin: const EdgeInsets.only(top: 10, bottom: 15, right: 0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchContactsForCall()));
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            )),
        Container(
          width: 40,
          margin: const EdgeInsets.only(top: 10, bottom: 15, right: 0),
          child: PopUpMenu().appBarPopUpMenuCalls(context),
        ),
      ];
    } else if (length == 2) {
      return [
        Container(
            width: 40,
            margin: const EdgeInsets.only(top: 10, bottom: 15, right: 8),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ImageManagementForProfileByCamera()));
              },
              icon: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
              ),
            )),
        Container(
            width: 40,
            margin: const EdgeInsets.only(top: 10, bottom: 15, right: 0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchContactsForStatus()));
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            )),
        Container(
          width: 40,
          margin: const EdgeInsets.only(top: 10, bottom: 15, right: 0),
          child: PopUpMenu().appBarPopUpMenuStatus(context),
        ),
      ];
    } else if (length == 1) {
      return [
        Container(
            width: 40,
            margin: const EdgeInsets.only(top: 10, bottom: 15, right: 8),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ImageManagementForProfileByCamera()));
              },
              icon: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
              ),
            )),
        Container(
            width: 40,
            margin: const EdgeInsets.only(top: 10, bottom: 15, right: 0),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SearchContactsForChat()));
              },
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
            )),
        Container(
          width: 40,
          margin: const EdgeInsets.only(top: 10, bottom: 15, right: 0),
          child: PopUpMenu().appBarPopUpMenuChats(context),
        ),
      ];
    } else if (length == 0) {
      return [
        Container(
            width: 40,
            margin: const EdgeInsets.only(top: 10, bottom: 15, right: 8),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const ImageManagementForProfileByCamera()));
              },
              icon: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.white,
              ),
            )),
        Container(
          width: 40,
          margin: const EdgeInsets.only(top: 10, bottom: 15, right: 0),
          child: PopUpMenu().appBarPopUpMenuCommunity(context),
        ),
      ];
    }
  }

  tabBar() {
    return TabBar(
      indicatorSize: TabBarIndicatorSize.tab,
      isScrollable: true,
      controller: tabController,
      indicatorColor: Colors.white,
      tabs: [
        Tab(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.04,
            height: 20,
            margin: const EdgeInsets.only(right: 10),
            alignment: Alignment.center,
            child: const Icon(
              Icons.people,
            ),
          ),
        ),
        Tab(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.20,
            child: const Text(
              "CHATS",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Tab(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.20,
            child: const Text(
              "STATUS",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Tab(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.20,
            child: const Text(
              "CALLS",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  mainScafFoldBody(BuildContext context) {
    return TabBarView(controller: tabController, children: [
      Scaffold(
        backgroundColor: Colors.white,
        body: CommunityPage().communityPage(),
      ),
      Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingButtons().floatingButtonChats(context),
        body: const ContactsList(),
      ),
      Scaffold(
          backgroundColor: Colors.white,
          floatingActionButton: FloatingButtons().floatingButtonStatus(context),
          body: FloatingButtons().floatingButtonStatusPenButton(context)),
      Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingButtons().floatingButtonCalls(context),
        body: const ContactsListCalls(),
      )
    ]);
  }
}

class ImageManagementForProfileByCamera extends StatefulWidget {
  const ImageManagementForProfileByCamera({
    Key? key,
  }) : super(key: key);

  @override
  State<ImageManagementForProfileByCamera> createState() =>
      _ImageManagementForProfileByCameraState();
}

class _ImageManagementForProfileByCameraState
    extends State<ImageManagementForProfileByCamera> {
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
    final user = auth.currentUser?.phoneNumber;
    final fstore = FirebaseFirestore.instance.collection(user.toString());
    DateTime now = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile Image"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: [
          Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 150, right: 40, left: 40),
              decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: Colors.deepPurple)),
              width: 200,
              height: 300,
              child: _image != null
                  ? Image.file(File(_image!.path))
                  : const Icon(
                      Icons.person,
                      size: 35,
                    )),
          const SizedBox(
            height: 30,
          ),
          Container(
            width: 200,
            margin: const EdgeInsets.only(right: 50, left: 50),
            child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.deepPurple)),
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  fs.Reference storage =
                      fs.FirebaseStorage.instance.ref(user.toString());
                  fs.UploadTask uploadTask = storage.putFile(_image!.absolute);
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
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: loading == true
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Set as profile Image",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                )),
          )
        ],
      ),
    );
  }
}

class ImageManagementForStatusByCamera extends StatefulWidget {
  const ImageManagementForStatusByCamera({
    Key? key,
  }) : super(key: key);

  @override
  State<ImageManagementForStatusByCamera> createState() =>
      _ImageManagementForStatusByCameraState();
}

class _ImageManagementForStatusByCameraState
    extends State<ImageManagementForStatusByCamera> {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Status"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: [
          Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 150, right: 40, left: 40),
              decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: Colors.deepPurple)),
              width: 200,
              height: 300,
              child: _image != null
                  ? Image.file(File(_image!.path))
                  : const Icon(
                      Icons.person,
                      size: 35,
                    )),
          const SizedBox(
            height: 30,
          ),
          Container(
            width: 200,
            margin: const EdgeInsets.only(right: 50, left: 50),
            child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.deepPurple)),
                onPressed: () {
                  Fluttertoast.showToast(msg: "Status Coming Soon");
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: loading == true
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Set on Status",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                )),
          )
        ],
      ),
    );
  }
}

class PopUpMenu {
  appBarPopUpMenuCommunity(BuildContext context) {
    return PopupMenuButton(
      tooltip: "",
      color: Colors.white,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PopUpMenu().popUpMenuSettings(context)));
            },
            title: const Text(
              "Settings",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  appBarPopUpMenuChats(BuildContext context) {
    return PopupMenuButton(
      tooltip: "",
      color: Colors.white,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactsForNewGroup()));
            },
            title: const Text(
              "New group",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContactsForNewBroadcast()));
            },
            title: const Text(
              "New Broadcast",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PopUpInnerOptions().supportPage()));
            },
            title: const Text(
              "Support",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PopUpMenu().popUpMenuLinkedDevices()));
            },
            title: const Text(
              "Linked devices",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PopUpMenu().popUpMenuStaredMessage()));
            },
            title: const Text(
              "Starred messages",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PopUpMenu().popUpMenuSettings(context)));
            },
            title: const Text(
              "Settings",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  appBarPopUpMenuStatus(BuildContext context) {
    return PopupMenuButton(
      tooltip: "",
      color: Colors.white,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const RadioButton()));
            },
            title: const Text(
              "Status privacy",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PopUpMenu().popUpMenuSettings(context)));
            },
            title: const Text(
              "Settings",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  appBarPopUpMenuCalls(BuildContext context) {
    return PopupMenuButton(
      tooltip: "",
      color: Colors.white,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              toast();
            },
            title: const Text(
              "Clear call log",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ),
        PopupMenuItem(
          child: ListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PopUpMenu().popUpMenuSettings(context)));
            },
            title: const Text(
              "Settings",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
        ),
      ],
    );
  }

  popUpMenuSettings(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: popUpSettingsList(context),
    );
  }

  popUpSettingsList(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final fstore2 = FirebaseFirestore.instance
        .collection("name${auth.currentUser?.phoneNumber.toString()}")
        .snapshots();
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: ListView(
        children: [
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.only(right: 10, bottom: 20, top: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                border: Border.all(color: Colors.deepPurple)),
            child: ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfileEditingPage()));
              },
              leading: const CircleAvatar(
                backgroundColor: Colors.white,
                child: CircleAvatar(
                    backgroundColor: Color(0xffE6E6E6),
                    radius: 30,
                    child: ProfilePhotos()),
              ),
              title: StreamBuilder<QuerySnapshot>(
                  stream: fstore2,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Username");
                    } else if (snapshot.hasError) {
                      return const Text("Username");
                    } else if (snapshot.data!.docs.isEmpty) {
                      return const Text("Username");
                    } else {
                      return snapshot.data!.docs[0]['id'].toString() ==
                              auth.currentUser?.phoneNumber
                          ? Text(
                              snapshot.data!.docs[0]['title'],
                              style: const TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold),
                            )
                          : const Text("Username");
                    }
                  }),
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.key_outlined,
              color: Colors.deepPurple,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PopUpInnerOptions().settingPopUpInnerAccounts()));
            },
            title: const Text(
              "Account",
              style: TextStyle(fontSize: 17),
            ),
            subtitle: const Text("Security notifications,change number"),
          ),
          const SizedBox(
            height: 5,
          ),
          ListTile(
            leading: const Icon(
              Icons.gite_rounded,
              color: Colors.deepPurple,
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PopUpInnerOptions().settingPopUpInnerAvatar()));
            },
            title: const Text(
              "Avatar",
              style: TextStyle(fontSize: 17),
            ),
            subtitle: const Text("Change profile photo"),
          ),
          const SizedBox(
            height: 5,
          ),
          ListTile(
            leading: const Icon(
              Icons.lock,
              color: Colors.deepPurple,
            ),
            title: const Text(
              "Privacy",
              style: TextStyle(fontSize: 17),
            ),
            subtitle: const Text("Block contacts,disappearing message"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PopUpInnerOptions().settingPopUpInnerPrivacy()));
            },
          ),
          const SizedBox(
            height: 5,
          ),
          ListTile(
            leading: const Icon(
              Icons.chat,
              color: Colors.deepPurple,
            ),
            title: const Text(
              "Chats",
              style: TextStyle(fontSize: 17),
            ),
            subtitle: const Text("Theme,wallpapers,chat history"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PopUpInnerOptions().settingPopUpInnerChats()));
            },
          ),
          const SizedBox(
            height: 5,
          ),
          ListTile(
            leading: const Icon(
              Icons.notifications,
              color: Colors.deepPurple,
            ),
            title: const Text(
              "Notification",
              style: TextStyle(fontSize: 17),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PopUpInnerOptions()
                          .settingPopUpInnerNotifications()));
            },
            subtitle: const Text("Massage,group & call tones"),
          ),
          const SizedBox(
            height: 5,
          ),
          ListTile(
            leading: const Icon(
              Icons.storage_rounded,
              color: Colors.deepPurple,
            ),
            title: const Text(
              "Storage and data",
              style: TextStyle(fontSize: 17),
            ),
            subtitle: const Text("Network usage,auto download"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PopUpInnerOptions()
                          .settingPopUpInnerStorageAndDta()));
            },
          ),
          const SizedBox(
            height: 5,
          ),
          ListTile(
            leading: const Icon(
              Icons.language,
              color: Colors.deepPurple,
            ),
            title: const Text(
              "App language",
              style: TextStyle(fontSize: 17),
            ),
            subtitle: const Text("Change the language of app"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PopUpInnerOptions().settingPopUpInnerAppLanguage()));
            },
          ),
          const SizedBox(
            height: 5,
          ),
          ListTile(
            leading: const Icon(
              Icons.question_mark,
              color: Colors.deepPurple,
            ),
            title: const Text(
              "Help",
              style: TextStyle(fontSize: 17),
            ),
            subtitle: const Text("Help centre,contact us,privacy policy"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PopUpInnerOptions().settingPopUpInnerHelp(context)));
            },
          ),
          const SizedBox(
            height: 5,
          ),
          ListTile(
            leading: const Icon(
              Icons.people,
              color: Colors.deepPurple,
            ),
            title: const Text(
              "Invite a friend",
              style: TextStyle(fontSize: 17),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PopUpInnerOptions().settingPopUpInnerInvite()));
            },
          ),
          Container(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 20, top: 40),
            alignment: Alignment.bottomCenter,
            child: const Text(
              "from",
              style: TextStyle(fontSize: 10, color: Colors.deepPurple),
            ),
          ),
          Container(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 15),
            alignment: Alignment.bottomCenter,
            child: const Text(
              "ROUNDROBIN",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
          )
        ],
      ),
    );
  }

  popUpMenuLinkedDevices() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const Text(
          "Linked devices",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: popUpLinkedDevisesList(),
    );
  }

  popUpLinkedDevisesList() {
    return Column(
      children: [
        const SizedBox(
          height: 5,
        ),
        Container(
          margin: const EdgeInsets.only(top: 70),
          alignment: Alignment.center,
          child: popUpLinkedDevicesImage(),
        ),
        const SizedBox(
          height: 5,
        ),
        const Text(
          "Use ChatOFi on other devices",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          width: 300,
          child: ElevatedButton(
              style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.deepPurple)),
              onPressed: () {
                toast();
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "LINK A DEVICE",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              )),
        ),
        const SizedBox(
          height: 15,
        ),
        const ListTile(
          leading: Icon(Icons.lock),
          title: Text(
            "Your personal message are end to end encrypted on all your devices",
            style: TextStyle(fontSize: 13),
          ),
        )
      ],
    );
  }

  popUpLinkedDevicesImage() {
    AssetImage assetImage = const AssetImage('images/ptp.png');
    Image image = Image(image: assetImage, width: 300.0, height: 250.0);
    return image;
  }

  popUpMenuStaredMessage() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.white,
        ),
        title: const Text(
          "Starred messages",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: popUpStaredMassageList(),
    );
  }

  popUpStaredMassageList() {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 5,
          ),
          Container(
            margin: const EdgeInsets.only(top: 150),
            child: popUpStaredMassageImage(),
          ),
          const SizedBox(
            height: 50,
          ),
          const Text(
            "Tap and hold on any message",
            style: TextStyle(fontSize: 22),
          ),
          const Text(
            "in any chat to star it, so you",
            style: TextStyle(fontSize: 22),
          ),
          const Text(
            "can easily find it later",
            style: TextStyle(fontSize: 22),
          )
        ],
      ),
    );
  }

  popUpStaredMassageImage() {
    AssetImage assetImage = const AssetImage('images/aa.png');
    Image image = Image(image: assetImage, width: 200.0, height: 200.0);
    return image;
  }
}

class PopUpInnerOptions {
  settingPopUpInnerAccounts() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accounts"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 7,
          ),
          ListTile(
            onTap: () {
              toast();
            },
            leading: const Icon(
              Icons.shield,
              color: Colors.deepPurple,
            ),
            title: const Text("Security Notification"),
          ),
          ListTile(
            onTap: () {
              toast();
            },
            leading: const Icon(
              Icons.more,
              color: Colors.deepPurple,
            ),
            title: const Text("Two step verification"),
          ),
          ListTile(
            onTap: () {
              toast();
            },
            leading: const Icon(
              Icons.phone_android,
              color: Colors.deepPurple,
            ),
            title: const Text("Change number"),
          ),
          ListTile(
            onTap: () {
              toast();
            },
            leading: const Icon(
              Icons.file_copy_sharp,
              color: Colors.deepPurple,
            ),
            title: const Text("Request account info"),
          ),
          ListTile(
            onTap: () {
              toast();
            },
            leading: const Icon(
              Icons.delete,
              color: Colors.deepPurple,
            ),
            title: const Text("Delete my account"),
          ),
        ],
      ),
    );
  }

  settingPopUpInnerAvatar() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Avatar"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 25,
          ),
          Container(
            alignment: Alignment.topCenter,
            child: settingPopUpInnerAvatarImage(),
          ),
          const Text(
            "Say more with Avatars now on ChatOFi",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 25,
          ),
          SizedBox(
            width: 300,
            height: 50,
            child: settingPopUpInnerAvatarPageButton(),
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              TextButton(
                  onPressed: () {
                    toast();
                  },
                  child: const Text(
                    "Learn more",
                    style: TextStyle(fontSize: 15),
                  ))
            ],
          )
        ],
      ),
    );
  }

  settingPopUpInnerAvatarImage() {
    AssetImage assetImage = const AssetImage('images/rer.jpg');
    Image image = Image(image: assetImage, width: 370.0, height: 250.0);
    return image;
  }

  settingPopUpInnerAvatarPageButton() {
    return ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.deepPurple)),
        onPressed: () {
          toast();
        },
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "Create your Avatar",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ));
  }

  settingPopUpInnerPrivacy() {
    return const SwitchButtonPrivacy();
  }

  settingPopUpInnerChats() {
    return const SwitchButtonChats();
  }

  settingPopUpInnerNotifications() {
    return const SwitchButtonNotificatin();
  }

  settingPopUpInnerStorageAndDta() {
    return const SwitchButtonStorageAndData();
  }

  settingPopUpInnerAppLanguage() {
    return const RadioButtonAppLanguage();
  }

  settingPopUpInnerHelp(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 25,
          ),
          ListTile(
            onTap: () {
              toast();
            },
            leading: const Icon(
              Icons.help_center,
              color: Colors.deepPurple,
            ),
            title: const Text("Help centre"),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => supportPage()));
            },
            leading: const Icon(
              Icons.people_alt,
              color: Colors.deepPurple,
            ),
            title: const Text("Support"),
          ),
          ListTile(
            onTap: () {
              toast();
            },
            leading: const Icon(
              Icons.file_copy_sharp,
              color: Colors.deepPurple,
            ),
            title: const Text("Terms and Privacy policy"),
          ),
          ListTile(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => appInfoPage()));
            },
            leading: const Icon(
              Icons.info_outline,
              color: Colors.deepPurple,
            ),
            title: const Text("App info"),
          ),
        ],
      ),
    );
  }

  appInfoPage() {
    AssetImage assetImage = const AssetImage('images/dd.png');
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 90),
              child: const Text(
                "ChatOFi !",
                style: TextStyle(fontSize: 30, color: Colors.deepPurple),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 70, bottom: 50),
              child: Image(image: assetImage, width: 150.0, height: 150.0),
            ),
            Container(
              margin: const EdgeInsets.only(top: 0),
              child: const Text(
                "v1.0.0",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 20, top: 130),
              alignment: Alignment.bottomCenter,
              child: const Text(
                "from",
                style: TextStyle(fontSize: 10, color: Colors.deepPurple),
              ),
            ),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 15),
              alignment: Alignment.bottomCenter,
              child: const Text(
                "ROUNDROBIN",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
            )
          ],
        ),
      ]),
    );
  }

  settingPopUpInnerInvite() {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invite a friend"),
        backgroundColor: Colors.deepPurple,
        actions: [
          Container(
              width: 40,
              margin: const EdgeInsets.only(top: 10, bottom: 15, right: 0),
              child: TextButton(
                onPressed: () {
                  toast();
                },
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              )),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 25,
          ),
          ListTile(
            onTap: () {
              toast();
            },
            leading: const Icon(Icons.share, color: Colors.deepPurple),
            title: const Text("Share link"),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: const [
              SizedBox(
                width: 15,
              ),
              Text(
                "From Contacts",
                style: TextStyle(color: Colors.deepPurple),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  supportPage() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Support",
          style: TextStyle(color: Colors.deepPurple),
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: const BackButton(
          color: Colors.deepPurple,
        ),
      ),
      body: ListView(children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 70),
              child: const Text(
                "Support Us !",
                style: TextStyle(fontSize: 30, color: Colors.deepPurple),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Text(
                "Hello users ! \n"
                "I am the first year student of IT \nEngineering. "
                "This is my first application. "
                "\nIf you like my work then follow me"
                "\non Instagram and LinkedIn. "
                "If you \nfollow me there then I will make "
                "better \napplications for you !\n"
                "Made with ❤️ by Parth Thakor",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: const Text(
                "Instagram Link !",
                style: TextStyle(fontSize: 30, color: Colors.deepPurple),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: TextButton(
                  onPressed: () async {
                    var url = Uri.parse(
                        "https://instagram.com/parth_thakor_24?igshid=YzgyMTM2MGM=");
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: const Text(
                    "https://instagram.com/parth_thakor_24?igshid=YzgyMTM2MGM=",
                    textAlign: TextAlign.center,
                  ),
                )),
            Container(
              margin: const EdgeInsets.only(top: 30),
              child: const Text(
                "LinkedIn Link !",
                style: TextStyle(fontSize: 30, color: Colors.deepPurple),
              ),
            ),
            Container(
                margin: const EdgeInsets.only(top: 20),
                child: TextButton(
                  onPressed: () async {
                    var url = Uri.parse(
                        "https://www.linkedin.com/in/parth-thakor-4a469b25b");
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: const Text(
                    "https://www.linkedin.com/in/parth-thakor-4a469b25b",
                    textAlign: TextAlign.center,
                  ),
                )),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 20, top: 70),
              alignment: Alignment.bottomCenter,
              child: const Text(
                "from",
                style: TextStyle(fontSize: 10, color: Colors.deepPurple),
              ),
            ),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 15),
              alignment: Alignment.bottomCenter,
              child: const Text(
                "ROUNDROBIN",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
            )
          ],
        ),
      ]),
    );
  }
}

class SwitchButtonPrivacy extends StatefulWidget {
  const SwitchButtonPrivacy({super.key});

  @override
  State<SwitchButtonPrivacy> createState() =>
      _SwitchButtonStateSettingStatusPrivacyPage();
}

class _SwitchButtonStateSettingStatusPrivacyPage
    extends State<SwitchButtonPrivacy> {
  var switchbool = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacy"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10),
        child: ListView(
          children: [
            const SizedBox(
              height: 25,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Who can see my personal info",
                  style: TextStyle(color: Colors.deepPurple),
                )
              ],
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Last seen and online"),
              subtitle: const Text("Nobody, Everyone"),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Profile photo"),
              subtitle: const Text("My contacts"),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("About"),
              subtitle: const Text("Nobody"),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Status"),
              subtitle: const Text("My contacts"),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Read receipt"),
              subtitle: const Text(
                  "If turned off you won`t send or receive Read receipts.Read receipts are always sent for group chats"),
              trailing: Switch(
                  activeColor: Colors.deepPurple,
                  value: switchbool,
                  onChanged: (value) {
                    setState(() {
                      if (switchbool == true) {
                        switchbool = false;
                      } else {
                        switchbool = true;
                      }
                    });
                  }),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Disappearing messages"),
              subtitle:
                  const Text("Default message timer,Apply timer to chats"),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Groups"),
              subtitle: const Text("Everyone"),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Live location"),
              subtitle: const Text("None"),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Blocked contacts"),
              subtitle: const Text("5"),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Fingerprint lock"),
              subtitle: const Text("Enabled immediately"),
            ),
          ],
        ),
      ),
    );
  }
}

class SwitchButtonChats extends StatefulWidget {
  const SwitchButtonChats({super.key});

  @override
  State<SwitchButtonChats> createState() => _SwitchButtonChatsState();
}

class _SwitchButtonChatsState extends State<SwitchButtonChats> {
  var switchboolsend = false;
  var switchboolmedia = true;
  var switchboolarchive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10),
        child: ListView(
          children: [
            const SizedBox(
              height: 25,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Display",
                  style: TextStyle(color: Colors.deepPurple),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Theme"),
              subtitle: const Text("System default"),
              leading: const Icon(
                Icons.brightness_2_outlined,
                color: Colors.deepPurple,
              ),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Wallpaper"),
              leading: const Icon(
                Icons.image_outlined,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Chat settings",
                  style: TextStyle(color: Colors.deepPurple),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Enter is send"),
              leading: const Icon(
                Icons.send,
                color: Colors.deepPurple,
              ),
              subtitle: const Text("Media visibility"),
              trailing: Switch(
                  activeColor: Colors.deepPurple,
                  value: switchboolsend,
                  onChanged: (value) {
                    setState(() {
                      if (switchboolsend == true) {
                        switchboolsend = false;
                      } else {
                        switchboolsend = true;
                      }
                    });
                  }),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Media visibility"),
              leading: const Icon(
                Icons.perm_media,
                color: Colors.deepPurple,
              ),
              subtitle: const Text(
                  "Show newly downloaded media in your device`s gallery"),
              trailing: Switch(
                  activeColor: Colors.deepPurple,
                  value: switchboolmedia,
                  onChanged: (value) {
                    setState(() {
                      if (switchboolmedia == true) {
                        switchboolmedia = false;
                      } else {
                        switchboolmedia = true;
                      }
                    });
                  }),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Font size"),
              subtitle: const Text("Medium"),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Archived chats",
                  style: TextStyle(color: Colors.deepPurple),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Keep archived"),
              subtitle: const Text(
                  "Archived chats will remain archived when you receive a new message"),
              trailing: Switch(
                  activeColor: Colors.deepPurple,
                  value: switchboolarchive,
                  onChanged: (value) {
                    setState(() {
                      if (switchboolarchive == true) {
                        switchboolarchive = false;
                      } else {
                        switchboolarchive = true;
                      }
                    });
                  }),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Chat backup"),
              leading: const Icon(
                Icons.backup,
                color: Colors.deepPurple,
              ),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Chat history"),
              leading: const Icon(
                Icons.timer_sharp,
                color: Colors.deepPurple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SwitchButtonNotificatin extends StatefulWidget {
  const SwitchButtonNotificatin({super.key});

  @override
  State<SwitchButtonNotificatin> createState() => _SwitchButtonNotificatin();
}

class _SwitchButtonNotificatin extends State<SwitchButtonNotificatin> {
  var switchbooltons = true;
  var switchboolhighproritynotification = true;
  var switchboolhighproritynotificationG = true;
  var switchboolreaction = true;
  var switchboolreactionG = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: Colors.deepPurple,
        actions: [
          PopupMenuButton(
              itemBuilder: (context) => [
                    const PopupMenuItem(
                        child: ListTile(
                      title: Text("Reset notification settings"),
                    ))
                  ])
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10),
        child: ListView(
          children: [
            const SizedBox(
              height: 25,
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Conversation tones"),
              subtitle:
                  const Text("Play sounds for incoming and outgoing message"),
              trailing: Switch(
                  activeColor: Colors.deepPurple,
                  value: switchbooltons,
                  onChanged: (value) {
                    setState(() {
                      if (switchbooltons == true) {
                        switchbooltons = false;
                      } else {
                        switchbooltons = true;
                      }
                    });
                  }),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Message",
                  style: TextStyle(color: Colors.deepPurple),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Notification tone"),
              subtitle: const Text("Default"),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Vibrate"),
              subtitle: const Text("Default"),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Popup notification"),
              subtitle: const Text("Not available"),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Light"),
              subtitle: const Text("White"),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Use high priority notification"),
              subtitle: const Text(
                  "Show previews of notification at the top of the screen"),
              trailing: Switch(
                  activeColor: Colors.deepPurple,
                  value: switchboolhighproritynotification,
                  onChanged: (value) {
                    setState(() {
                      if (switchboolhighproritynotification == true) {
                        switchboolhighproritynotification = false;
                      } else {
                        switchboolhighproritynotification = true;
                      }
                    });
                  }),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Reaction notification"),
              subtitle: const Text(
                  "Show notifications for reactions to message you send"),
              trailing: Switch(
                  activeColor: Colors.deepPurple,
                  value: switchboolreaction,
                  onChanged: (value) {
                    setState(() {
                      if (switchboolreaction == true) {
                        switchboolreaction = false;
                      } else {
                        switchboolreaction = true;
                      }
                    });
                  }),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Groups",
                  style: TextStyle(color: Colors.deepPurple),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Notification tone"),
              subtitle: const Text("Default"),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Vibrate"),
              subtitle: const Text("Default"),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Light"),
              subtitle: const Text("White"),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Use high priority notification"),
              subtitle: const Text(
                  "Show previews of notification at the top of the screen"),
              trailing: Switch(
                  activeColor: Colors.deepPurple,
                  value: switchboolhighproritynotificationG,
                  onChanged: (value) {
                    setState(() {
                      if (switchboolhighproritynotificationG == true) {
                        switchboolhighproritynotificationG = false;
                      } else {
                        switchboolhighproritynotificationG = true;
                      }
                    });
                  }),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Reaction notification"),
              subtitle: const Text(
                  "Show notifications for reactions to message you send"),
              trailing: Switch(
                  activeColor: Colors.deepPurple,
                  value: switchboolreactionG,
                  onChanged: (value) {
                    setState(() {
                      if (switchboolreactionG == true) {
                        switchboolreactionG = false;
                      } else {
                        switchboolreactionG = true;
                      }
                    });
                  }),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Calls",
                  style: TextStyle(color: Colors.deepPurple),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Ringtone"),
              subtitle: const Text("Default"),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Vibrate"),
              subtitle: const Text("Default"),
            ),
          ],
        ),
      ),
    );
  }
}

class SwitchButtonStorageAndData extends StatefulWidget {
  const SwitchButtonStorageAndData({super.key});

  @override
  State<SwitchButtonStorageAndData> createState() =>
      _SwitchButtonStorageAndData();
}

class _SwitchButtonStorageAndData extends State<SwitchButtonStorageAndData> {
  var switchbooluselessdata = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Storage and data"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10),
        child: ListView(
          children: [
            const SizedBox(
              height: 25,
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Manage storage"),
              subtitle: const Text("345.0 MB"),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Network usage"),
              subtitle: const Text("1.5 GB sent , 1.7 GB received"),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Use less data for calls"),
              trailing: Switch(
                  activeColor: Colors.deepPurple,
                  value: switchbooluselessdata,
                  onChanged: (value) {
                    setState(() {
                      if (switchbooluselessdata == true) {
                        switchbooluselessdata = false;
                      } else {
                        switchbooluselessdata = true;
                      }
                    });
                  }),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Media auto download\nVoice message are always automatically downloaded",
                  style: TextStyle(color: Colors.deepPurple),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("When using mobile data"),
              subtitle: const Text("Photos"),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("When connected on Wi-Fi"),
              subtitle: const Text("All media"),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("When roaming"),
              subtitle: const Text("No media"),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 15,
                ),
                Text(
                    "Media upload quality\nChoose the quality of media files to be sent",
                    style: TextStyle(color: Colors.deepPurple))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Photo upload quality"),
              subtitle: const Text("Auto (recommended)"),
            ),
          ],
        ),
      ),
    );
  }
}

class RadioButtonAppLanguage extends StatefulWidget {
  const RadioButtonAppLanguage({super.key});

  @override
  State<RadioButtonAppLanguage> createState() => _RadioButtonAppLanguage();
}

class _RadioButtonAppLanguage extends State<RadioButtonAppLanguage> {
  int valueChanged = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("App language"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 30,
          ),
          RadioListTile(
              value: 1,
              activeColor: Colors.deepPurple,
              title: const Text("English"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 2,
              activeColor: Colors.deepPurple,
              title: const Text("Hindi"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 3,
              activeColor: Colors.deepPurple,
              title: const Text("Marathi"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 4,
              activeColor: Colors.deepPurple,
              title: const Text("Gujarati"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 5,
              activeColor: Colors.deepPurple,
              title: const Text("Tamil"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 6,
              activeColor: Colors.deepPurple,
              title: const Text("Bengali"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 7,
              activeColor: Colors.deepPurple,
              title: const Text("Telugu"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 8,
              activeColor: Colors.deepPurple,
              title: const Text("Kannada"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 9,
              activeColor: Colors.deepPurple,
              title: const Text("Malayalam"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 10,
              activeColor: Colors.deepPurple,
              title: const Text("Punjabi"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 11,
              activeColor: Colors.deepPurple,
              title: const Text("Urdu"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 12,
              activeColor: Colors.deepPurple,
              title: const Text("Afrikaans"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 13,
              activeColor: Colors.deepPurple,
              title: const Text("Albanian"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 14,
              activeColor: Colors.deepPurple,
              title: const Text("Amharic"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 15,
              activeColor: Colors.deepPurple,
              title: const Text("Arabic"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 16,
              activeColor: Colors.deepPurple,
              title: const Text("Azerbaijani"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 17,
              activeColor: Colors.deepPurple,
              title: const Text("Bulgarian"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 18,
              activeColor: Colors.deepPurple,
              title: const Text("Catalan"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 19,
              activeColor: Colors.deepPurple,
              title: const Text("Danish"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 20,
              activeColor: Colors.deepPurple,
              title: const Text("Dutch"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 21,
              activeColor: Colors.deepPurple,
              title: const Text("Filipino"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 22,
              activeColor: Colors.deepPurple,
              title: const Text("Finnish"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 23,
              activeColor: Colors.deepPurple,
              title: const Text("German"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 24,
              activeColor: Colors.deepPurple,
              title: const Text("Indonesian"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 25,
              activeColor: Colors.deepPurple,
              title: const Text("Irish"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 26,
              activeColor: Colors.deepPurple,
              title: const Text("Italian"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 27,
              activeColor: Colors.deepPurple,
              title: const Text("Japanese"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 28,
              activeColor: Colors.deepPurple,
              title: const Text("Korean"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 29,
              activeColor: Colors.deepPurple,
              title: const Text("Russian"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 30,
              activeColor: Colors.deepPurple,
              title: const Text("Slovak"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 31,
              activeColor: Colors.deepPurple,
              title: const Text("Thai"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 32,
              activeColor: Colors.deepPurple,
              title: const Text("Uzbek"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 33,
              activeColor: Colors.deepPurple,
              title: const Text("Spanish"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 34,
              activeColor: Colors.deepPurple,
              title: const Text("Malay"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 35,
              activeColor: Colors.deepPurple,
              title: const Text("Polish"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
        ],
      ),
    );
  }
}

class RadioButton extends StatefulWidget {
  const RadioButton({super.key});

  @override
  State<RadioButton> createState() => _RadioButtonStatePopUpStatusPrivacyPage();
}

class _RadioButtonStatePopUpStatusPrivacyPage extends State<RadioButton> {
  int valueChanged = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Status privacy"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          const ListTile(
            title: Text("Who can see my status"),
          ),
          RadioListTile(
              value: 1,
              activeColor: Colors.deepPurple,
              title: const Text("My contacts"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 2,
              activeColor: Colors.deepPurple,
              title: const Text("My contacts expect..."),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          RadioListTile(
              value: 3,
              activeColor: Colors.deepPurple,
              title: const Text("Only share with"),
              groupValue: valueChanged,
              onChanged: (value) {
                toast();
                setState(() {
                  valueChanged = value!;
                });
              }),
          const ListTile(
            title: Text(
              "Changes to your privacy settings won't affect status updates that you have sent already ",
              style: TextStyle(fontSize: 15),
            ),
          )
        ],
      ),
    );
  }
}

class FloatingButtons {
  floatingButtonChats(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ContactsMassage()));
      },
      backgroundColor: Colors.deepPurple,
      child: const Icon(
        Icons.mark_unread_chat_alt_rounded,
      ),
    );
  }

  floatingButtonStatus(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const ImageManagementForStatusByCamera()));
      },
      backgroundColor: Colors.deepPurple,
      child: const Icon(
        Icons.camera_alt_rounded,
      ),
    );
  }

  floatingButtonStatusPenButton(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.bottomRight,
        margin: const EdgeInsets.only(bottom: 80, right: 20),
        child: FloatingActionButton.small(
          backgroundColor: Colors.white70,
          child: const Icon(Icons.edit, color: Colors.black),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        const StatusFloatingEditButtonPage()));
          },
        ),
      ),
    );
  }

  floatingButtonCalls(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ContactsCalls()));
      },
      backgroundColor: Colors.deepPurple,
      child: const Icon(
        Icons.add_call,
      ),
    );
  }
}

class StatusFloatingEditButtonPage extends StatefulWidget {
  const StatusFloatingEditButtonPage({super.key});

  @override
  State<StatusFloatingEditButtonPage> createState() => _EditState();
}

class _EditState extends State<StatusFloatingEditButtonPage> {
  var color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
  var textcolor = Colors.black;
  var textitlic = FontStyle.normal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: textStatusPageFloatingButton(),
        backgroundColor: color,
        appBar: AppBar(
          actions: textStatusPageAppBarActions(),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        body: textStatusEditPageBody());
  }

  textStatusPageFloatingButton() {
    return FloatingActionButton(
      onPressed: () {
        toast();
      },
      backgroundColor: Colors.white,
      child: Icon(Icons.send, color: color),
    );
  }

  textStatusPageAppBarActions() {
    return [
      Container(
          width: 40,
          margin: const EdgeInsets.only(top: 10, bottom: 15, right: 8),
          child: TextButton(
            onPressed: () {
              setState(() {
                if (textitlic == FontStyle.italic) {
                  textitlic = FontStyle.normal;
                } else {
                  textitlic = FontStyle.italic;
                }
              });
            },
            child: const Icon(
              Icons.format_italic,
              color: Colors.white,
            ),
          )),
      Container(
          width: 40,
          margin: const EdgeInsets.only(top: 10, bottom: 15, right: 8),
          child: TextButton(
            onPressed: () {
              setState(() {
                textcolor =
                    Colors.primaries[Random().nextInt(Colors.primaries.length)];
              });
            },
            child: const Icon(
              Icons.text_format,
              color: Colors.white,
            ),
          )),
      Container(
          width: 40,
          margin: const EdgeInsets.only(top: 10, bottom: 15, right: 8),
          child: TextButton(
            onPressed: () {
              setState(() {
                color =
                    Colors.primaries[Random().nextInt(Colors.primaries.length)];
              });
            },
            child: const Icon(
              Icons.color_lens_outlined,
              color: Colors.white,
            ),
          )),
    ];
  }

  textStatusEditPageBody() {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 70),
        width: 300,
        height: 300,
        child: TextFormField(
            textAlign: TextAlign.center,
            cursorHeight: 60,
            autofocus: true,
            cursorColor: Colors.deepPurple,
            maxLines: 12,
            style: TextStyle(
              fontSize: 35,
              color: textcolor,
              fontStyle: textitlic,
            ),
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.only(left: 10),
                border: InputBorder.none,
                hintText: "Type Your Status",
                hintStyle: TextStyle(
                  color: textcolor,
                  fontStyle: textitlic,
                ))),
      ),
    );
  }
}

class CommunityPage {
  communityPage() {
    return Column(
      children: [
        const SizedBox(
          height: 25,
        ),
        Container(
          child: communityPageImage(),
        ),
        const Text(
          "Introducing communities",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        const Center(
          child: Text(
            "Easily organise your related groups and send",
            style: TextStyle(fontSize: 16),
          ),
        ),
        const Center(
          child: Text(
            "announcements, now your, communities like",
            style: TextStyle(fontSize: 16),
          ),
        ),
        const Center(
          child: Text(
            "neighbourhoods or schools can have their own",
            style: TextStyle(fontSize: 16),
          ),
        ),
        const Center(
          child: Text(
            "space",
            style: TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(
          height: 25,
        ),
        Center(
          child: SizedBox(
            width: 260,
            height: 40,
            child: communityPageCommunityButton(),
          ),
        )
      ],
    );
  }

  communityPageImage() {
    AssetImage assetImage = const AssetImage('images/ll.jpg');
    Image image = Image(image: assetImage, width: 200.0, height: 200.0);
    return image;
  }

  communityPageCommunityButton() {
    return ElevatedButton(
        style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.deepPurple)),
        onPressed: () {
          toast();
        },
        child: const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            "START YOUR COMMUNITY",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
        ));
  }
}

class ContactsForNewGroup extends StatefulWidget {
  const ContactsForNewGroup({Key? key}) : super(key: key);

  @override
  ContactsForNewGroupState createState() => ContactsForNewGroupState();
}

class ContactsForNewGroupState extends State<ContactsForNewGroup> {
  List<Contact>? contacts;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Select Contacts"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const SearchContactsForGroup()));
                },
                icon: const Icon(Icons.search))
          ],
          backgroundColor: Colors.deepPurple,
        ),
        body: (contacts) == null
            ? const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple))
            : ListView.builder(
                itemCount: contacts!.length,
                itemBuilder: (BuildContext context, int index) {
                  String num = (contacts![index].phones.isNotEmpty)
                      ? (contacts![index].phones.first.number)
                      : "--";
                  return ListTile(
                      tileColor: Colors.white,
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: ProfilePhotosForOtherContacts(
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
                                    .replaceAll(' ', ''))),
                      ),
                      title: Text(
                          "${contacts![index].name.first} ${contacts![index].name.last}"),
                      subtitle: Text(num),
                      onTap: () {
                        if ((contacts![index].phones.first.number)
                                .toString()
                                .length <
                            10) {
                          Fluttertoast.showToast(
                              msg: "Can't make Group with this contact");
                        } else {
                          Fluttertoast.showToast(
                              msg: "Group System Coming Soon");
                        }
                      });
                },
              ));
  }
}

class SearchContactsForGroup extends StatefulWidget {
  const SearchContactsForGroup({Key? key}) : super(key: key);

  @override
  State<SearchContactsForGroup> createState() => _SearchContactsForGroupState();
}

class _SearchContactsForGroupState extends State<SearchContactsForGroup> {
  List<Contact>? contacts = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.deepPurple,
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Container(
            margin: const EdgeInsets.only(right: 10),
            child: TextFormField(
              autofocus: true,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              onChanged: (value) {
                setState(() {
                  controller = value.toString();
                });
              },
              decoration: const InputDecoration(
                hintText: "Enter Name for Group",
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple)),
                hintStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        body: (contacts) == null
            ? const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple))
            : ListView.builder(
                itemCount: contacts!.length,
                itemBuilder: (BuildContext context, int index) {
                  String num = (contacts![index].phones.isNotEmpty)
                      ? (contacts![index].phones.first.number)
                      : "--";
                  if ("${contacts![index].name.first} ${contacts![index].name.last}"
                          .toString()
                          .toLowerCase()
                          .contains(controller) &&
                      controller != "") {
                    return ListTile(
                        tileColor: Colors.white,
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: ProfilePhotosForOtherContacts(
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
                                      .replaceAll(' ', ''))),
                        ),
                        title: Text(
                            "${contacts![index].name.first} ${contacts![index].name.last}"),
                        subtitle: Text(num),
                        onTap: () {
                          if ((contacts![index].phones.first.number)
                                  .toString()
                                  .length <
                              10) {
                            Fluttertoast.showToast(
                                msg: "Can't make group with this contact");
                          } else {
                            Fluttertoast.showToast(
                                msg: "Group System Coming Soon");
                          }
                        });
                  } else if (controller == "") {
                    return ListTile(
                        tileColor: Colors.white,
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: ProfilePhotosForOtherContacts(
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
                                      .replaceAll(' ', ''))),
                        ),
                        title: Text(
                            "${contacts![index].name.first} ${contacts![index].name.last}"),
                        subtitle: Text(num),
                        onTap: () {
                          if ((contacts![index].phones.first.number)
                                  .toString()
                                  .length <
                              10) {
                            Fluttertoast.showToast(
                                msg: "Can't make Group with this contact");
                          } else {
                            Fluttertoast.showToast(
                                msg: "Group System Coming Soon");
                          }
                        });
                  } else {
                    return Container();
                  }
                },
              ));
  }
}

class ContactsForNewBroadcast extends StatefulWidget {
  const ContactsForNewBroadcast({Key? key}) : super(key: key);

  @override
  ContactsForNewBroadcastState createState() => ContactsForNewBroadcastState();
}

class ContactsForNewBroadcastState extends State<ContactsForNewBroadcast> {
  List<Contact>? contacts;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Select Contacts"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const SearchContactsForBroadcast()));
                },
                icon: const Icon(Icons.search))
          ],
          backgroundColor: Colors.deepPurple,
        ),
        body: (contacts) == null
            ? const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple))
            : ListView.builder(
                itemCount: contacts!.length,
                itemBuilder: (BuildContext context, int index) {
                  String num = (contacts![index].phones.isNotEmpty)
                      ? (contacts![index].phones.first.number)
                      : "--";
                  return ListTile(
                      tileColor: Colors.white,
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: ProfilePhotosForOtherContacts(
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
                                    .replaceAll(' ', ''))),
                      ),
                      title: Text(
                          "${contacts![index].name.first} ${contacts![index].name.last}"),
                      subtitle: Text(num),
                      onTap: () {
                        if ((contacts![index].phones.first.number)
                                .toString()
                                .length <
                            10) {
                          Fluttertoast.showToast(
                              msg: "Can't make Broadcast with this contact");
                        } else {
                          Fluttertoast.showToast(
                              msg: "Broadcast System Coming Soon");
                        }
                      });
                },
              ));
  }
}

class SearchContactsForBroadcast extends StatefulWidget {
  const SearchContactsForBroadcast({Key? key}) : super(key: key);

  @override
  State<SearchContactsForBroadcast> createState() =>
      _SearchContactsForBroadcastState();
}

class _SearchContactsForBroadcastState
    extends State<SearchContactsForBroadcast> {
  List<Contact>? contacts = [];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.deepPurple,
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Container(
            margin: const EdgeInsets.only(right: 10),
            child: TextFormField(
              autofocus: true,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              onChanged: (value) {
                setState(() {
                  controller = value.toString();
                });
              },
              decoration: const InputDecoration(
                hintText: "Enter Name for Broadcast",
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple)),
                hintStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        body: (contacts) == null
            ? const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple))
            : ListView.builder(
                itemCount: contacts!.length,
                itemBuilder: (BuildContext context, int index) {
                  String num = (contacts![index].phones.isNotEmpty)
                      ? (contacts![index].phones.first.number)
                      : "--";
                  if ("${contacts![index].name.first} ${contacts![index].name.last}"
                          .toString()
                          .toLowerCase()
                          .contains(controller) &&
                      controller != "") {
                    return ListTile(
                        tileColor: Colors.white,
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: ProfilePhotosForOtherContacts(
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
                                      .replaceAll(' ', ''))),
                        ),
                        title: Text(
                            "${contacts![index].name.first} ${contacts![index].name.last}"),
                        subtitle: Text(num),
                        onTap: () {
                          if ((contacts![index].phones.first.number)
                                  .toString()
                                  .length <
                              10) {
                            Fluttertoast.showToast(
                                msg: "Can't make Broadcast with this contact");
                          } else {
                            Fluttertoast.showToast(
                                msg: "Broadcast System Coming Soon");
                          }
                        });
                  } else if (controller == "") {
                    return ListTile(
                        tileColor: Colors.white,
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: ProfilePhotosForOtherContacts(
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
                                      .replaceAll(' ', ''))),
                        ),
                        title: Text(
                            "${contacts![index].name.first} ${contacts![index].name.last}"),
                        subtitle: Text(num),
                        onTap: () {
                          if ((contacts![index].phones.first.number)
                                  .toString()
                                  .length <
                              10) {
                            Fluttertoast.showToast(
                                msg: "Can't make Broadcast with this contact");
                          } else {
                            Fluttertoast.showToast(
                                msg: "Broadcast System Coming Soon");
                          }
                        });
                  } else {
                    return Container();
                  }
                },
              ));
  }
}

class SearchContactsForChat extends StatefulWidget {
  const SearchContactsForChat({Key? key}) : super(key: key);

  @override
  State<SearchContactsForChat> createState() => _SearchContactsForChatState();
}

class _SearchContactsForChatState extends State<SearchContactsForChat> {
  List<Contact>? contacts = [];
  final scroller = ScrollController();
  final auth = FirebaseAuth.instance;
  var controller = "";

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
          withProperties: true, withPhoto: true);
    }
    setState(() {});
  }

  massagePage(int index, BuildContext context) {
    final texter = TextEditingController();
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

    final fstore2 = FirebaseFirestore.instance
        .collection('post')
        .doc(ciadd.toString() + ciaadd.toString())
        .collection('lol')
        .orderBy('time')
        .snapshots();

    var docId = DateTime.now().microsecondsSinceEpoch.toString();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white38,
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
        backgroundColor: Colors.purpleAccent,
        child: const Icon(Icons.send),
      ),
      appBar: AppBar(
        actions: [
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
              icon: const Icon(Icons.videocam)),
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
              icon: const Icon(Icons.call)),
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Add to contacts",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Media,links and docs",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Search",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Mute notification",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Disappearing messages",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Wallpaper",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "More",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                  ])
        ],
        backgroundColor: Colors.deepPurple,
        title: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => contactIdPage(index)));
          },
          child: Text(
              "${contacts![index].name.first} ${contacts![index].name.last}"),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: fstore2,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
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
                                        (snapshot.data!.docs[index]['id']
                                                .toString())
                                            .contains(user.toString())
                                    ? Row(
                                        mainAxisAlignment: snapshot
                                                    .data!.docs[index]['id']
                                                    .toString() ==
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
                                                                builder: (context) => PreviewPage(
                                                                    pictureUrl: snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                            [
                                                                            'title']
                                                                        .toString())));
                                                      },
                                                      onLongPress: () {
                                                        if (snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['id']
                                                                .toString() ==
                                                            curruntUser +
                                                                user.toString()) {
                                                          fstore2x
                                                              .doc(snapshot
                                                                  .data!
                                                                  .docs[index][
                                                                      'deleteId']
                                                                  .toString())
                                                              .delete();
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Message Deleted");
                                                        }
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            right: 16,
                                                            left: 14),
                                                        width: 250,
                                                        height: 300,
                                                        decoration: BoxDecoration(
                                                            color: snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                            [
                                                                            'id']
                                                                        .toString() ==
                                                                    curruntUser +
                                                                        user
                                                                            .toString()
                                                                ? Colors
                                                                    .deepPurple
                                                                : Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        17),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .deepPurple)),
                                                        child: Column(
                                                            children: [
                                                              Expanded(
                                                                child: Image.network(snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        [
                                                                        'title']
                                                                    .toString()),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        [
                                                                        'time2']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: snapshot.data!.docs[index]['id'].toString() ==
                                                                            curruntUser +
                                                                                user
                                                                                    .toString()
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .deepPurple),
                                                              )
                                                            ]),
                                                      ),
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        if (snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['id']
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
                                                                .data!
                                                                .docs[index]
                                                                    ['id']
                                                                .toString() ==
                                                            curruntUser +
                                                                user.toString()) {
                                                          fstore2x
                                                              .doc(snapshot
                                                                  .data!
                                                                  .docs[index][
                                                                      'deleteId']
                                                                  .toString())
                                                              .delete();
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Message Deleted");
                                                        }
                                                      },
                                                      child: Container(
                                                          margin:
                                                              const EdgeInsets.only(
                                                                  right: 16,
                                                                  left: 14),
                                                          padding: const EdgeInsets.all(
                                                              16),
                                                          constraints: const BoxConstraints(
                                                              maxWidth: 300),
                                                          decoration: BoxDecoration(
                                                              color: snapshot.data!.docs[index]['id'].toString() ==
                                                                      curruntUser +
                                                                          user
                                                                              .toString()
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .white,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      17),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .deepPurple)),
                                                          child: Column(
                                                              children: [
                                                                Text(
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          [
                                                                          'title']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: snapshot.data!.docs[index]['id'].toString() == curruntUser + user.toString()
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .deepPurple),
                                                                ),
                                                                Text(
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          [
                                                                          'time2']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: snapshot.data!.docs[index]['id'].toString() == curruntUser + user.toString()
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .deepPurple),
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
                  }),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 15, right: 16, bottom: 16, top: 4),
              child: ListTile(
                tileColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(250),
                ),
                leading: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageManagement(
                                  curruntUser: curruntUser,
                                  cuadd: ciadd,
                                  cuaadd: ciaadd,
                                )));
                  },
                  icon: const Icon(Icons.source, size: 25),
                ),
                trailing: Container(
                    margin: const EdgeInsets.only(right: 38),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageManagementByCamera(
                                      curruntUser: curruntUser,
                                      cuadd: ciadd,
                                      cuaadd: ciaadd,
                                    )));
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                    )),
                title: TextFormField(
                    cursorColor: Colors.white,
                    maxLines: 1,
                    controller: texter,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Message",
                        hintStyle: TextStyle(color: Colors.white))),
              ),
            )
          ],
        ),
      ),
    );
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
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.deepPurple,
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.deepPurple),
              itemBuilder: (context) => [
                    PopupMenuItem(
                        child: ListTile(
                      title: const Text("Add to contacts"),
                      onTap: () {
                        toast();
                      },
                    )),
                    PopupMenuItem(
                        child: ListTile(
                      title: const Text("Verify security code"),
                      onTap: () {
                        toast();
                      },
                    ))
                  ])
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.3,
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: ProfilePhotosForOtherContacts(
                      curruntnumber: curruntUser)),
            ),
            ListTile(
              title: Text(
                "${contacts![index].name.first} ${contacts![index].name.last}",
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: Text(
                (contacts![index].phones.isNotEmpty)
                    ? (contacts![index].phones.first.number)
                    : "--",
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              leading: IconButton(
                  onPressed: () {
                    final fstore =
                        FirebaseFirestore.instance.collection('calls');
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
                      deleteId =
                          DateTime.now().millisecondsSinceEpoch.toString();
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
                  icon: const Icon(
                    Icons.videocam,
                    color: Colors.deepPurple,
                    size: 35,
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
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
            ),
            ListTile(
              leading: IconButton(
                  onPressed: () {
                    final fstore =
                        FirebaseFirestore.instance.collection('calls');
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
                      deleteId =
                          DateTime.now().millisecondsSinceEpoch.toString();
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
                  icon: const Icon(
                    Icons.call_outlined,
                    color: Colors.deepPurple,
                    size: 35,
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
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Status",
                  style: TextStyle(color: Colors.deepPurple),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: Colors.black)),
              child: ListTile(
                title: StreamBuilder<QuerySnapshot>(
                    stream: fstore2,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(".....",
                            style:
                                TextStyle(fontSize: 25, color: Colors.black));
                      } else if (snapshot.hasError) {
                        return const Text(".....",
                            style:
                                TextStyle(fontSize: 25, color: Colors.black));
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Text(hinttext,
                            style: const TextStyle(
                                fontSize: 25, color: Colors.black));
                      } else {
                        return snapshot.data!.docs[0]['id'].toString() ==
                                curruntUser
                            ? Text(
                                snapshot.data!.docs[0]['title'],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                              )
                            : const Text("......",
                                style: TextStyle(
                                    fontSize: 25, color: Colors.black));
                      }
                    }),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Media, links and docs",
                  style: TextStyle(color: Colors.deepPurple),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const SwitchMuteNotification(),
            ListTile(
              title: const Text("Custom notifications"),
              onTap: () {
                toast();
              },
              leading: const Icon(
                Icons.music_note,
                color: Colors.deepPurple,
              ),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Media visibility"),
              leading: const Icon(
                Icons.perm_media_outlined,
                color: Colors.deepPurple,
              ),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Encryption"),
              subtitle: const Text(
                  "Messages and calls are end-to-end encrypted.Tap to verify"),
              leading: const Icon(
                Icons.lock,
                color: Colors.deepPurple,
              ),
            ),
            ListTile(
              title: const Text("Disappearing messages"),
              onTap: () {
                toast();
              },
              subtitle: const Text("Off"),
              leading: const Icon(
                Icons.timer_outlined,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: Text(
                "Block ${contacts![index].name.first} ${contacts![index].name.last}",
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
              leading: const Icon(
                Icons.block,
                color: Colors.red,
              ),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: Text(
                "Report ${contacts![index].name.first} ${contacts![index].name.last}",
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
              leading: const Icon(
                Icons.thumb_down_alt,
                color: Colors.red,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.deepPurple,
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Container(
            margin: const EdgeInsets.only(right: 10),
            child: TextFormField(
              autofocus: true,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              onChanged: (value) {
                setState(() {
                  controller = value.toString();
                });
              },
              decoration: const InputDecoration(
                hintText: "Enter Name for Chat",
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple)),
                hintStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        body: (contacts) == null
            ? const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple))
            : ListView.builder(
                itemCount: contacts!.length,
                itemBuilder: (BuildContext context, int index) {
                  String num = (contacts![index].phones.isNotEmpty)
                      ? (contacts![index].phones.first.number)
                      : "--";
                  if ("${contacts![index].name.first} ${contacts![index].name.last}"
                          .toString()
                          .toLowerCase()
                          .contains(controller) &&
                      controller != "") {
                    return ListTile(
                        tileColor: Colors.white,
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: ProfilePhotosForOtherContacts(
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
                                      .replaceAll(' ', ''))),
                        ),
                        title: Text(
                            "${contacts![index].name.first} ${contacts![index].name.last}"),
                        subtitle: Text(num),
                        onTap: () {
                          if ((contacts![index].phones.first.number)
                                  .toString()
                                  .length <
                              10) {
                            Fluttertoast.showToast(
                                msg: "Can't make chat with this contact");
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
                        tileColor: Colors.white,
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: ProfilePhotosForOtherContacts(
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
                                      .replaceAll(' ', ''))),
                        ),
                        title: Text(
                            "${contacts![index].name.first} ${contacts![index].name.last}"),
                        subtitle: Text(num),
                        onTap: () {
                          if ((contacts![index].phones.first.number)
                                  .toString()
                                  .length <
                              10) {
                            Fluttertoast.showToast(
                                msg: "Can't make chat with this contact");
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

class ContactsMassage extends StatefulWidget {
  const ContactsMassage({Key? key}) : super(key: key);

  @override
  ContactsMassageState createState() => ContactsMassageState();
}

class ContactsMassageState extends State<ContactsMassage> {
  List<Contact>? contacts;
  final scroller = ScrollController();
  final auth = FirebaseAuth.instance;

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
          withProperties: true, withPhoto: true);
      setState(() {});
    }
  }

  massagePage(int index, BuildContext context) {
    final texter = TextEditingController();
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

    final fstore2 = FirebaseFirestore.instance
        .collection('post')
        .doc(ciadd.toString() + ciaadd.toString())
        .collection('lol')
        .orderBy('time')
        .snapshots();

    var docId = DateTime.now().microsecondsSinceEpoch.toString();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white38,
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
        backgroundColor: Colors.purpleAccent,
        child: const Icon(Icons.send),
      ),
      appBar: AppBar(
        actions: [
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
              icon: const Icon(Icons.videocam)),
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
              icon: const Icon(Icons.call)),
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Add to contacts",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Media,links and docs",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Search",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Mute notification",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Disappearing messages",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Wallpaper",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "More",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                  ])
        ],
        backgroundColor: Colors.deepPurple,
        title: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => contactIdPage(index)));
          },
          child: Text(
              "${contacts![index].name.first} ${contacts![index].name.last}"),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: fstore2,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
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
                                        (snapshot.data!.docs[index]['id']
                                                .toString())
                                            .contains(user.toString())
                                    ? Row(
                                        mainAxisAlignment: snapshot
                                                    .data!.docs[index]['id']
                                                    .toString() ==
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
                                                                builder: (context) => PreviewPage(
                                                                    pictureUrl: snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                            [
                                                                            'title']
                                                                        .toString())));
                                                      },
                                                      onLongPress: () {
                                                        if (snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['id']
                                                                .toString() ==
                                                            curruntUser +
                                                                user.toString()) {
                                                          fstore2x
                                                              .doc(snapshot
                                                                  .data!
                                                                  .docs[index][
                                                                      'deleteId']
                                                                  .toString())
                                                              .delete();
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Message Deleted");
                                                        }
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            right: 16,
                                                            left: 14),
                                                        width: 250,
                                                        height: 300,
                                                        decoration: BoxDecoration(
                                                            color: snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                            [
                                                                            'id']
                                                                        .toString() ==
                                                                    curruntUser +
                                                                        user
                                                                            .toString()
                                                                ? Colors
                                                                    .deepPurple
                                                                : Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        17),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .deepPurple)),
                                                        child: Column(
                                                            children: [
                                                              Expanded(
                                                                child: Image.network(snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        [
                                                                        'title']
                                                                    .toString()),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        [
                                                                        'time2']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: snapshot.data!.docs[index]['id'].toString() ==
                                                                            curruntUser +
                                                                                user
                                                                                    .toString()
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .deepPurple),
                                                              )
                                                            ]),
                                                      ),
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        if (snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['id']
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
                                                                .data!
                                                                .docs[index]
                                                                    ['id']
                                                                .toString() ==
                                                            curruntUser +
                                                                user.toString()) {
                                                          fstore2x
                                                              .doc(snapshot
                                                                  .data!
                                                                  .docs[index][
                                                                      'deleteId']
                                                                  .toString())
                                                              .delete();
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Message Deleted");
                                                        }
                                                      },
                                                      child: Container(
                                                          margin:
                                                              const EdgeInsets.only(
                                                                  right: 16,
                                                                  left: 14),
                                                          padding: const EdgeInsets.all(
                                                              16),
                                                          constraints: const BoxConstraints(
                                                              maxWidth: 300),
                                                          decoration: BoxDecoration(
                                                              color: snapshot.data!.docs[index]['id'].toString() ==
                                                                      curruntUser +
                                                                          user
                                                                              .toString()
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .white,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      17),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .deepPurple)),
                                                          child: Column(
                                                              children: [
                                                                Text(
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          [
                                                                          'title']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: snapshot.data!.docs[index]['id'].toString() == curruntUser + user.toString()
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .deepPurple),
                                                                ),
                                                                Text(
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          [
                                                                          'time2']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: snapshot.data!.docs[index]['id'].toString() == curruntUser + user.toString()
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .deepPurple),
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
                  }),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 15, right: 16, bottom: 16, top: 4),
              child: ListTile(
                tileColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(250),
                ),
                leading: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageManagement(
                                  curruntUser: curruntUser,
                                  cuadd: ciadd,
                                  cuaadd: ciaadd,
                                )));
                  },
                  icon: const Icon(Icons.source, size: 25),
                ),
                trailing: Container(
                    margin: const EdgeInsets.only(right: 38),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageManagementByCamera(
                                      curruntUser: curruntUser,
                                      cuadd: ciadd,
                                      cuaadd: ciaadd,
                                    )));
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                    )),
                title: TextFormField(
                    cursorColor: Colors.white,
                    maxLines: 1,
                    controller: texter,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Message",
                        hintStyle: TextStyle(color: Colors.white))),
              ),
            )
          ],
        ),
      ),
    );
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
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.deepPurple,
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.deepPurple),
              itemBuilder: (context) => [
                    PopupMenuItem(
                        child: ListTile(
                      title: const Text("Add to contacts"),
                      onTap: () {
                        toast();
                      },
                    )),
                    PopupMenuItem(
                        child: ListTile(
                      title: const Text("Verify security code"),
                      onTap: () {
                        toast();
                      },
                    ))
                  ])
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.3,
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: ProfilePhotosForOtherContacts(
                      curruntnumber: curruntUser)),
            ),
            ListTile(
              title: Text(
                "${contacts![index].name.first} ${contacts![index].name.last}",
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: Text(
                (contacts![index].phones.isNotEmpty)
                    ? (contacts![index].phones.first.number)
                    : "--",
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              leading: IconButton(
                  onPressed: () {
                    final fstore =
                        FirebaseFirestore.instance.collection('calls');
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
                      deleteId =
                          DateTime.now().millisecondsSinceEpoch.toString();
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
                  icon: const Icon(
                    Icons.videocam,
                    color: Colors.deepPurple,
                    size: 35,
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
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
            ),
            ListTile(
              leading: IconButton(
                  onPressed: () {
                    final fstore =
                        FirebaseFirestore.instance.collection('calls');
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
                      deleteId =
                          DateTime.now().millisecondsSinceEpoch.toString();
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
                  icon: const Icon(
                    Icons.call_outlined,
                    color: Colors.deepPurple,
                    size: 35,
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
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Status",
                  style: TextStyle(color: Colors.deepPurple),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: Colors.black)),
              child: ListTile(
                title: StreamBuilder<QuerySnapshot>(
                    stream: fstore2,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(".....",
                            style:
                                TextStyle(fontSize: 25, color: Colors.black));
                      } else if (snapshot.hasError) {
                        return const Text(".....",
                            style:
                                TextStyle(fontSize: 25, color: Colors.black));
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Text(hinttext,
                            style: const TextStyle(
                                fontSize: 25, color: Colors.black));
                      } else {
                        return snapshot.data!.docs[0]['id'].toString() ==
                                curruntUser
                            ? Text(
                                snapshot.data!.docs[0]['title'],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                              )
                            : const Text("......",
                                style: TextStyle(
                                    fontSize: 25, color: Colors.black));
                      }
                    }),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Media, links and docs",
                  style: TextStyle(color: Colors.deepPurple),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const SwitchMuteNotification(),
            ListTile(
              title: const Text("Custom notifications"),
              onTap: () {
                toast();
              },
              leading: const Icon(
                Icons.music_note,
                color: Colors.deepPurple,
              ),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Media visibility"),
              leading: const Icon(
                Icons.perm_media_outlined,
                color: Colors.deepPurple,
              ),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Encryption"),
              subtitle: const Text(
                  "Messages and calls are end-to-end encrypted.Tap to verify"),
              leading: const Icon(
                Icons.lock,
                color: Colors.deepPurple,
              ),
            ),
            ListTile(
              title: const Text("Disappearing messages"),
              onTap: () {
                toast();
              },
              subtitle: const Text("Off"),
              leading: const Icon(
                Icons.timer_outlined,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: Text(
                "Block ${contacts![index].name.first} ${contacts![index].name.last}",
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
              leading: const Icon(
                Icons.block,
                color: Colors.red,
              ),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: Text(
                "Report ${contacts![index].name.first} ${contacts![index].name.last}",
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
              leading: const Icon(
                Icons.thumb_down_alt,
                color: Colors.red,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My contacts"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchContactsForChat()));
                },
                icon: const Icon(Icons.search))
          ],
          backgroundColor: Colors.deepPurple,
        ),
        body: (contacts) == null
            ? const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple))
            : ListView.builder(
                itemCount: contacts!.length,
                itemBuilder: (BuildContext context, int index) {
                  String num = (contacts![index].phones.isNotEmpty)
                      ? (contacts![index].phones.first.number)
                      : "--";
                  return ListTile(
                      tileColor: Colors.white,
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: ProfilePhotosForOtherContacts(
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
                                    .replaceAll(' ', ''))),
                      ),
                      title: Text(
                          "${contacts![index].name.first} ${contacts![index].name.last}"),
                      subtitle: Text(num),
                      onTap: () {
                        if ((contacts![index].phones.first.number)
                                .toString()
                                .length <
                            10) {
                          Fluttertoast.showToast(
                              msg: "Can't make chat with this contact");
                        } else {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      massagePage(index, context)));
                        }
                      });
                },
              ));
  }
}

class ContactsList extends StatefulWidget {
  const ContactsList({Key? key}) : super(key: key);

  @override
  ContactsListState createState() => ContactsListState();
}

class ContactsListState extends State<ContactsList> {
  List<Contact>? contacts = [];
  final scroller = ScrollController();
  final fstore = FirebaseFirestore.instance.collection('post');
  final auth = FirebaseAuth.instance;
  List<String> contacts2 = [];

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
          withProperties: true, withPhoto: true);
      setState(() {});
    }
  }

  massagePage(int index, BuildContext context) {
    final texter = TextEditingController();
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
    final fstore2 = FirebaseFirestore.instance
        .collection('post')
        .doc(ciadd.toString() + ciaadd.toString())
        .collection('lol')
        .orderBy('time')
        .snapshots();

    var docId = DateTime.now().microsecondsSinceEpoch.toString();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white38,
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
        backgroundColor: Colors.purpleAccent,
        child: const Icon(Icons.send),
      ),
      appBar: AppBar(
        actions: [
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
              icon: const Icon(Icons.videocam)),
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
              icon: const Icon(Icons.call)),
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Add to contacts",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Media,links and docs",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Search",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Mute notification",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Disappearing messages",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Wallpaper",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "More",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                  ])
        ],
        backgroundColor: Colors.deepPurple,
        title: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => contactIdPage(index)));
          },
          child: Text(
              "${contacts![index].name.first} ${contacts![index].name.last}"),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: fstore2,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
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
                                        (snapshot.data!.docs[index]['id']
                                                .toString())
                                            .contains(user.toString())
                                    ? Row(
                                        mainAxisAlignment: snapshot
                                                    .data!.docs[index]['id']
                                                    .toString() ==
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
                                                                builder: (context) => PreviewPage(
                                                                    pictureUrl: snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                            [
                                                                            'title']
                                                                        .toString())));
                                                      },
                                                      onLongPress: () {
                                                        if (snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['id']
                                                                .toString() ==
                                                            curruntUser +
                                                                user.toString()) {
                                                          fstore2x
                                                              .doc(snapshot
                                                                  .data!
                                                                  .docs[index][
                                                                      'deleteId']
                                                                  .toString())
                                                              .delete();
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Message Deleted");
                                                        }
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            right: 16,
                                                            left: 14),
                                                        width: 250,
                                                        height: 300,
                                                        decoration: BoxDecoration(
                                                            color: snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                            [
                                                                            'id']
                                                                        .toString() ==
                                                                    curruntUser +
                                                                        user
                                                                            .toString()
                                                                ? Colors
                                                                    .deepPurple
                                                                : Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        17),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .deepPurple)),
                                                        child: Column(
                                                            children: [
                                                              Expanded(
                                                                child: Image.network(snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        [
                                                                        'title']
                                                                    .toString()),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        [
                                                                        'time2']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: snapshot.data!.docs[index]['id'].toString() ==
                                                                            curruntUser +
                                                                                user
                                                                                    .toString()
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .deepPurple),
                                                              )
                                                            ]),
                                                      ),
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        if (snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['id']
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
                                                                .data!
                                                                .docs[index]
                                                                    ['id']
                                                                .toString() ==
                                                            curruntUser +
                                                                user.toString()) {
                                                          fstore2x
                                                              .doc(snapshot
                                                                  .data!
                                                                  .docs[index][
                                                                      'deleteId']
                                                                  .toString())
                                                              .delete();
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Message Deleted");
                                                        }
                                                      },
                                                      child: Container(
                                                          margin:
                                                              const EdgeInsets.only(
                                                                  right: 16,
                                                                  left: 14),
                                                          padding: const EdgeInsets.all(
                                                              16),
                                                          constraints: const BoxConstraints(
                                                              maxWidth: 300),
                                                          decoration: BoxDecoration(
                                                              color: snapshot.data!.docs[index]['id'].toString() ==
                                                                      curruntUser +
                                                                          user
                                                                              .toString()
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .white,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      17),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .deepPurple)),
                                                          child: Column(
                                                              children: [
                                                                Text(
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          [
                                                                          'title']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: snapshot.data!.docs[index]['id'].toString() == curruntUser + user.toString()
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .deepPurple),
                                                                ),
                                                                Text(
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          [
                                                                          'time2']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: snapshot.data!.docs[index]['id'].toString() == curruntUser + user.toString()
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .deepPurple),
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
                  }),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 15, right: 16, bottom: 16, top: 4),
              child: ListTile(
                tileColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(250),
                ),
                leading: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageManagement(
                                  curruntUser: curruntUser,
                                  cuadd: ciadd,
                                  cuaadd: ciaadd,
                                )));
                  },
                  icon: const Icon(Icons.source, size: 25),
                ),
                trailing: Container(
                    margin: const EdgeInsets.only(right: 38),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageManagementByCamera(
                                      curruntUser: curruntUser,
                                      cuadd: ciadd,
                                      cuaadd: ciaadd,
                                    )));
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                    )),
                title: TextFormField(
                    cursorColor: Colors.white,
                    maxLines: 1,
                    controller: texter,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Message",
                        hintStyle: TextStyle(color: Colors.white))),
              ),
            )
          ],
        ),
      ),
    );
  }

  massagePageUnknown(String curruntnumber, BuildContext context) {
    final texter = TextEditingController();
    final user = auth.currentUser?.phoneNumber;
    DateTime now = DateTime.now();
    String curruntUser = curruntnumber;
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
    final fstore2 = FirebaseFirestore.instance
        .collection('post')
        .doc(ciadd.toString() + ciaadd.toString())
        .collection('lol')
        .orderBy('time')
        .snapshots();

    var docId = DateTime.now().microsecondsSinceEpoch.toString();

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white38,
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
        backgroundColor: Colors.purpleAccent,
        child: const Icon(Icons.send),
      ),
      appBar: AppBar(
        actions: [
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
              icon: const Icon(Icons.videocam)),
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
              icon: const Icon(Icons.call)),
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Add to contacts",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Media,links and docs",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Search",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Mute notification",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Disappearing messages",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "Wallpaper",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        onTap: () {
                          toast();
                        },
                        title: const Text(
                          "More",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                      ),
                    ),
                  ])
        ],
        backgroundColor: Colors.deepPurple,
        title: InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => contactIdPageUnknown(curruntnumber)));
          },
          child: Text(curruntnumber),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: fstore2,
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.deepPurple,
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
                                        (snapshot.data!.docs[index]['id']
                                                .toString())
                                            .contains(user.toString())
                                    ? Row(
                                        mainAxisAlignment: snapshot
                                                    .data!.docs[index]['id']
                                                    .toString() ==
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
                                                                builder: (context) => PreviewPage(
                                                                    pictureUrl: snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                            [
                                                                            'title']
                                                                        .toString())));
                                                      },
                                                      onLongPress: () {
                                                        if (snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['id']
                                                                .toString() ==
                                                            curruntUser +
                                                                user.toString()) {
                                                          fstore2x
                                                              .doc(snapshot
                                                                  .data!
                                                                  .docs[index][
                                                                      'deleteId']
                                                                  .toString())
                                                              .delete();
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Message Deleted");
                                                        }
                                                      },
                                                      child: Container(
                                                        margin: const EdgeInsets
                                                                .only(
                                                            right: 16,
                                                            left: 14),
                                                        width: 250,
                                                        height: 300,
                                                        decoration: BoxDecoration(
                                                            color: snapshot
                                                                        .data!
                                                                        .docs[
                                                                            index]
                                                                            [
                                                                            'id']
                                                                        .toString() ==
                                                                    curruntUser +
                                                                        user
                                                                            .toString()
                                                                ? Colors
                                                                    .deepPurple
                                                                : Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        17),
                                                            border: Border.all(
                                                                color: Colors
                                                                    .deepPurple)),
                                                        child: Column(
                                                            children: [
                                                              Expanded(
                                                                child: Image.network(snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        [
                                                                        'title']
                                                                    .toString()),
                                                              ),
                                                              const SizedBox(
                                                                height: 5,
                                                              ),
                                                              Text(
                                                                snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                        [
                                                                        'time2']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: snapshot.data!.docs[index]['id'].toString() ==
                                                                            curruntUser +
                                                                                user
                                                                                    .toString()
                                                                        ? Colors
                                                                            .white
                                                                        : Colors
                                                                            .deepPurple),
                                                              )
                                                            ]),
                                                      ),
                                                    )
                                                  : InkWell(
                                                      onTap: () {
                                                        if (snapshot
                                                                .data!
                                                                .docs[index]
                                                                    ['id']
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
                                                                .data!
                                                                .docs[index]
                                                                    ['id']
                                                                .toString() ==
                                                            curruntUser +
                                                                user.toString()) {
                                                          fstore2x
                                                              .doc(snapshot
                                                                  .data!
                                                                  .docs[index][
                                                                      'deleteId']
                                                                  .toString())
                                                              .delete();
                                                          Fluttertoast.showToast(
                                                              msg:
                                                                  "Message Deleted");
                                                        }
                                                      },
                                                      child: Container(
                                                          margin:
                                                              const EdgeInsets.only(
                                                                  right: 16,
                                                                  left: 14),
                                                          padding: const EdgeInsets.all(
                                                              16),
                                                          constraints: const BoxConstraints(
                                                              maxWidth: 300),
                                                          decoration: BoxDecoration(
                                                              color: snapshot.data!.docs[index]['id'].toString() ==
                                                                      curruntUser +
                                                                          user
                                                                              .toString()
                                                                  ? Colors
                                                                      .deepPurple
                                                                  : Colors
                                                                      .white,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                      17),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .deepPurple)),
                                                          child: Column(
                                                              children: [
                                                                Text(
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          [
                                                                          'title']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: snapshot.data!.docs[index]['id'].toString() == curruntUser + user.toString()
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .deepPurple),
                                                                ),
                                                                Text(
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          [
                                                                          'time2']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: snapshot.data!.docs[index]['id'].toString() == curruntUser + user.toString()
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .deepPurple),
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
                  }),
            ),
            Container(
              margin: const EdgeInsets.only(
                  left: 15, right: 16, bottom: 16, top: 4),
              child: ListTile(
                tileColor: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(250),
                ),
                leading: IconButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ImageManagement(
                                  curruntUser: curruntUser,
                                  cuadd: ciadd,
                                  cuaadd: ciaadd,
                                )));
                  },
                  icon: const Icon(Icons.source, size: 25),
                ),
                trailing: Container(
                    margin: const EdgeInsets.only(right: 38),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageManagementByCamera(
                                      curruntUser: curruntUser,
                                      cuadd: ciadd,
                                      cuaadd: ciaadd,
                                    )));
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.white,
                      ),
                    )),
                title: TextFormField(
                    cursorColor: Colors.white,
                    maxLines: 1,
                    controller: texter,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Message",
                        hintStyle: TextStyle(color: Colors.white))),
              ),
            )
          ],
        ),
      ),
    );
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
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.deepPurple,
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.deepPurple),
              itemBuilder: (context) => [
                    PopupMenuItem(
                        child: ListTile(
                      title: const Text("Add to contacts"),
                      onTap: () {
                        toast();
                      },
                    )),
                    PopupMenuItem(
                        child: ListTile(
                      title: const Text("Verify security code"),
                      onTap: () {
                        toast();
                      },
                    ))
                  ])
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.3,
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: ProfilePhotosForOtherContacts(
                      curruntnumber: curruntUser)),
            ),
            ListTile(
              title: Text(
                "${contacts![index].name.first} ${contacts![index].name.last}",
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: Text(
                (contacts![index].phones.isNotEmpty)
                    ? (contacts![index].phones.first.number)
                    : "--",
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              leading: IconButton(
                  onPressed: () {
                    final fstore =
                        FirebaseFirestore.instance.collection('calls');
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
                      deleteId =
                          DateTime.now().millisecondsSinceEpoch.toString();
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
                  icon: const Icon(
                    Icons.videocam,
                    color: Colors.deepPurple,
                    size: 35,
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
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
            ),
            ListTile(
              leading: IconButton(
                  onPressed: () {
                    final fstore =
                        FirebaseFirestore.instance.collection('calls');
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
                      deleteId =
                          DateTime.now().millisecondsSinceEpoch.toString();
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
                  icon: const Icon(
                    Icons.call_outlined,
                    color: Colors.deepPurple,
                    size: 35,
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
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Status",
                  style: TextStyle(color: Colors.deepPurple),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: Colors.black)),
              child: ListTile(
                title: StreamBuilder<QuerySnapshot>(
                    stream: fstore2,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(".....",
                            style:
                                TextStyle(fontSize: 25, color: Colors.black));
                      } else if (snapshot.hasError) {
                        return const Text(".....",
                            style:
                                TextStyle(fontSize: 25, color: Colors.black));
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Text(hinttext,
                            style: const TextStyle(
                                fontSize: 25, color: Colors.black));
                      } else {
                        return snapshot.data!.docs[0]['id'].toString() ==
                                curruntUser
                            ? Text(
                                snapshot.data!.docs[0]['title'],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                              )
                            : const Text("......",
                                style: TextStyle(
                                    fontSize: 25, color: Colors.black));
                      }
                    }),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Media, links and docs",
                  style: TextStyle(color: Colors.deepPurple),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const SwitchMuteNotification(),
            ListTile(
              title: const Text("Custom notifications"),
              onTap: () {
                toast();
              },
              leading: const Icon(
                Icons.music_note,
                color: Colors.deepPurple,
              ),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Media visibility"),
              leading: const Icon(
                Icons.perm_media_outlined,
                color: Colors.deepPurple,
              ),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Encryption"),
              subtitle: const Text(
                  "Messages and calls are end-to-end encrypted.Tap to verify"),
              leading: const Icon(
                Icons.lock,
                color: Colors.deepPurple,
              ),
            ),
            ListTile(
              title: const Text("Disappearing messages"),
              onTap: () {
                toast();
              },
              subtitle: const Text("Off"),
              leading: const Icon(
                Icons.timer_outlined,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: Text(
                "Block ${contacts![index].name.first} ${contacts![index].name.last}",
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
              leading: const Icon(
                Icons.block,
                color: Colors.red,
              ),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: Text(
                "Report ${contacts![index].name.first} ${contacts![index].name.last}",
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
              leading: const Icon(
                Icons.thumb_down_alt,
                color: Colors.red,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  contactIdPageUnknown(String curruntnumber) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser?.phoneNumber;
    String curruntUser = curruntnumber;
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
      appBar: AppBar(
        leading: const BackButton(
          color: Colors.deepPurple,
        ),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.more_vert, color: Colors.deepPurple),
              itemBuilder: (context) => [
                    PopupMenuItem(
                        child: ListTile(
                      title: const Text("Add to contacts"),
                      onTap: () {
                        toast();
                      },
                    )),
                    PopupMenuItem(
                        child: ListTile(
                      title: const Text("Verify security code"),
                      onTap: () {
                        toast();
                      },
                    ))
                  ])
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.3,
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: ProfilePhotosForOtherContacts(
                      curruntnumber: curruntUser)),
            ),
            ListTile(
              title: Text(
                curruntnumber,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: Text(
                curruntnumber,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              leading: IconButton(
                  onPressed: () {
                    final fstore =
                        FirebaseFirestore.instance.collection('calls');
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
                      deleteId =
                          DateTime.now().millisecondsSinceEpoch.toString();
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
                  icon: const Icon(
                    Icons.videocam,
                    color: Colors.deepPurple,
                    size: 35,
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
                "Video call $curruntnumber",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
            ),
            ListTile(
              leading: IconButton(
                  onPressed: () {
                    final fstore =
                        FirebaseFirestore.instance.collection('calls');
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
                      deleteId =
                          DateTime.now().millisecondsSinceEpoch.toString();
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
                  icon: const Icon(
                    Icons.call_outlined,
                    color: Colors.deepPurple,
                    size: 35,
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
                "Voice call $curruntnumber",
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Status",
                  style: TextStyle(color: Colors.deepPurple),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: Colors.black)),
              child: ListTile(
                title: StreamBuilder<QuerySnapshot>(
                    stream: fstore2,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(".....",
                            style:
                                TextStyle(fontSize: 25, color: Colors.black));
                      } else if (snapshot.hasError) {
                        return const Text(".....",
                            style:
                                TextStyle(fontSize: 25, color: Colors.black));
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Text(hinttext,
                            style: const TextStyle(
                                fontSize: 25, color: Colors.black));
                      } else {
                        return snapshot.data!.docs[0]['id'].toString() ==
                                curruntUser
                            ? Text(
                                snapshot.data!.docs[0]['title'],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
                              )
                            : const Text("......",
                                style: TextStyle(
                                    fontSize: 25, color: Colors.black));
                      }
                    }),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Media, links and docs",
                  style: TextStyle(color: Colors.deepPurple),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const SwitchMuteNotification(),
            ListTile(
              title: const Text("Custom notifications"),
              onTap: () {
                toast();
              },
              leading: const Icon(
                Icons.music_note,
                color: Colors.deepPurple,
              ),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Media visibility"),
              leading: const Icon(
                Icons.perm_media_outlined,
                color: Colors.deepPurple,
              ),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: const Text("Encryption"),
              subtitle: const Text(
                  "Messages and calls are end-to-end encrypted.Tap to verify"),
              leading: const Icon(
                Icons.lock,
                color: Colors.deepPurple,
              ),
            ),
            ListTile(
              title: const Text("Disappearing messages"),
              onTap: () {
                toast();
              },
              subtitle: const Text("Off"),
              leading: const Icon(
                Icons.timer_outlined,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: Text(
                "Block $curruntnumber",
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
              leading: const Icon(
                Icons.block,
                color: Colors.red,
              ),
            ),
            ListTile(
              onTap: () {
                toast();
              },
              title: Text(
                "Report $curruntnumber",
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              ),
              leading: const Icon(
                Icons.thumb_down_alt,
                color: Colors.red,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  contactIndexNameFinder(
      String number, String lastmsg, String time2, String deleteId) {
    for (int i = 0; i < contacts!.length; i++) {
      contacts2.add((contacts![i].phones.first.number.toString().contains("+91")
          ? (contacts![i].phones.first.number.toString()).replaceAll(' ', '')
          : "+91${contacts![i].phones.first.number.replaceAll(' ', '')}"));
    }

    for (int i = 0; i < contacts!.length; i++) {
      try {
        String curruntUser = (contacts![i]
                .phones
                .first
                .number
                .toString()
                .contains("+91")
            ? (contacts![i].phones.first.number.toString()).replaceAll(' ', '')
            : "+91${contacts![i].phones.first.number.replaceAll(' ', '')}");
        if (number.contains(curruntUser) &&
            curruntUser != "${auth.currentUser?.phoneNumber.toString()}") {
          return Container(
            margin: const EdgeInsets.only(top: 5),
            child: ListTile(
                tileColor: Colors.white,
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: ProfilePhotosForOtherContacts(
                      curruntnumber: (contacts![i]
                              .phones
                              .first
                              .number
                              .toString()
                              .contains("+91")
                          ? (contacts![i].phones.first.number.toString())
                              .replaceAll(' ', '')
                          : ("+91${contacts![i].phones.first.number}")
                              .replaceAll(' ', ''))),
                ),
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Delete Chat"),
                          content: Text(
                              "Delete whole chat with ${contacts![i].name.first} ${contacts![i].name.last} ?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  final fstore1 = FirebaseFirestore.instance
                                      .collection('post');
                                  fstore1.doc(deleteId).delete();
                                  Fluttertoast.showToast(
                                      msg: "Whole chat deleted");
                                  Navigator.pop(context);
                                },
                                child: const Text("Delete",
                                    style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 18)))
                          ],
                        );
                      });
                },
                title: Text(
                    "${contacts![i].name.first} ${contacts![i].name.last}"),
                subtitle: Text(
                  "Last : $lastmsg",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(time2),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => massagePage(i, context)));
                }),
          );
        } else if (number.toString().substring(0, 13) ==
                auth.currentUser?.phoneNumber.toString() &&
            !contacts2.contains(number.toString().substring(13, 26))) {
          return Container(
            margin: const EdgeInsets.only(top: 5),
            child: ListTile(
                tileColor: Colors.white,
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: ProfilePhotosForOtherContacts(
                      curruntnumber: number.toString().substring(13, 26)),
                ),
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Delete Chat"),
                          content: Text(
                              "Delete whole chat with ${number.toString().substring(13, 26)} ?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  final fstore1 = FirebaseFirestore.instance
                                      .collection('post');
                                  fstore1.doc(deleteId).delete();
                                  Fluttertoast.showToast(
                                      msg: "Whole chat deleted");
                                  Navigator.pop(context);
                                },
                                child: const Text("Delete",
                                    style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 18)))
                          ],
                        );
                      });
                },
                title: Text(number.toString().substring(13, 26)),
                subtitle: Text(
                  "Last : $lastmsg",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(time2),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => massagePageUnknown(
                              number.toString().substring(13, 26), context)));
                }),
          );
        } else if (number.toString().substring(13, 26) ==
                auth.currentUser?.phoneNumber.toString() &&
            !contacts2.contains(number.toString().substring(0, 13))) {
          return Container(
            margin: const EdgeInsets.only(top: 5),
            child: ListTile(
                tileColor: Colors.white,
                leading: CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: ProfilePhotosForOtherContacts(
                      curruntnumber: number.toString().substring(0, 13)),
                ),
                onLongPress: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Delete Chat"),
                          content: Text(
                              "Delete whole chat with ${number.toString().substring(0, 13)} ?"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  final fstore1 = FirebaseFirestore.instance
                                      .collection('post');
                                  fstore1.doc(deleteId).delete();
                                  Fluttertoast.showToast(
                                      msg: "Whole chat deleted");
                                  Navigator.pop(context);
                                },
                                child: const Text("Delete",
                                    style: TextStyle(
                                        color: Colors.deepPurple,
                                        fontSize: 18)))
                          ],
                        );
                      });
                },
                title: Text(number.toString().substring(0, 13)),
                subtitle: Text(
                  "Last : $lastmsg",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(time2),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => massagePageUnknown(
                              number.toString().substring(0, 13), context)));
                }),
          );
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  contactIdFinder(String user, String curruntUser) {
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

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final fstore2 = FirebaseFirestore.instance
        .collection('post')
        .orderBy('time', descending: true)
        .snapshots();
    final user = auth.currentUser?.phoneNumber;
    return Scaffold(
        backgroundColor: Colors.white,
        bottomSheet: Container(
          color: Colors.white,
          child: ListTile(
            tileColor: Colors.white,
            title: Container(
              margin: const EdgeInsets.only(bottom: 17),
              child: const Text(
                "Let's start !",
                style: TextStyle(color: Colors.deepPurple, fontSize: 30),
              ),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: fstore2,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ),
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "Let's start !",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.deepPurple, fontSize: 30),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return (snapshot.data!.docs[index]['id'].toString())
                            .contains(user.toString())
                        ? contactIndexNameFinder(
                            snapshot.data!.docs[index]['id'],
                            snapshot.data!.docs[index]['lastmsg'],
                            snapshot.data!.docs[index]['time2'],
                            contactIdFinder(
                                snapshot.data!.docs[index]['id']
                                    .toString()
                                    .substring(0, 13),
                                snapshot.data!.docs[index]['id']
                                    .toString()
                                    .substring(13, 26)))
                        : Container();
                  },
                );
              }
            }));
  }
}

class ProfilePhotosForOtherContacts extends StatefulWidget {
  const ProfilePhotosForOtherContacts({Key? key, required this.curruntnumber})
      : super(key: key);

  final String curruntnumber;

  @override
  State<ProfilePhotosForOtherContacts> createState() =>
      _ProfilePhotosForOtherContactsState();
}

class _ProfilePhotosForOtherContactsState
    extends State<ProfilePhotosForOtherContacts> {
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
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return const Icon(Icons.people);
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
                : const Icon(Icons.people);
          }
        });
  }
}

class ImageManagement extends StatefulWidget {
  const ImageManagement(
      {Key? key,
      required this.curruntUser,
      required this.cuadd,
      required this.cuaadd})
      : super(key: key);

  final String curruntUser;
  final double cuadd;
  final double cuaadd;

  @override
  State<ImageManagement> createState() => _ImageManagementState();
}

class _ImageManagementState extends State<ImageManagement> {
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
    var fstore1 = FirebaseFirestore.instance.collection('post');
    var fstore = FirebaseFirestore.instance
        .collection('post')
        .doc(widget.cuadd.toString() + widget.cuaadd.toString())
        .collection('lol');
    final user = auth.currentUser?.phoneNumber;
    DateTime now = DateTime.now();
    var docId = DateTime.now().microsecondsSinceEpoch.toString();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Send Image"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: [
          Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 150, right: 40, left: 40),
              decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: Colors.deepPurple)),
              width: 200,
              height: 300,
              child: _image != null
                  ? Image.file(File(_image!.path))
                  : const Icon(
                      Icons.person,
                      size: 35,
                    )),
          const SizedBox(
            height: 30,
          ),
          Container(
            width: 200,
            margin: const EdgeInsets.only(right: 50, left: 50),
            child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.deepPurple)),
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
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: loading == true
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Send Image",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                )),
          )
        ],
      ),
    );
  }
}

class ImageManagementByCamera extends StatefulWidget {
  const ImageManagementByCamera(
      {Key? key,
      required this.curruntUser,
      required this.cuadd,
      required this.cuaadd})
      : super(key: key);

  final String curruntUser;
  final double cuadd;
  final double cuaadd;

  @override
  State<ImageManagementByCamera> createState() =>
      _ImageManagementByCameraState();
}

class _ImageManagementByCameraState extends State<ImageManagementByCamera> {
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
      appBar: AppBar(
        title: const Text("Send Image"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: [
          Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 150, right: 40, left: 40),
              decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: Colors.deepPurple)),
              width: 200,
              height: 300,
              child: _image != null
                  ? Image.file(File(_image!.path))
                  : const Icon(
                      Icons.person,
                      size: 35,
                    )),
          const SizedBox(
            height: 30,
          ),
          Container(
            width: 200,
            margin: const EdgeInsets.only(right: 50, left: 50),
            child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.deepPurple)),
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
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: loading == true
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Send Image",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                )),
          )
        ],
      ),
    );
  }
}

class PreviewPage extends StatelessWidget {
  const PreviewPage({Key? key, required this.pictureUrl}) : super(key: key);

  final String pictureUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Image view'),
            backgroundColor: Colors.deepPurple),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FittedBox(
            child: Image.network(pictureUrl),
          ),
        ));
  }
}

class SwitchMuteNotification extends StatefulWidget {
  const SwitchMuteNotification({super.key});

  @override
  State<SwitchMuteNotification> createState() => _SwitchMuteNotificationState();
}

class _SwitchMuteNotificationState extends State<SwitchMuteNotification> {
  var switchbool = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Mute notification"),
      onTap: () {
        toast();
      },
      leading: const Icon(
        Icons.notifications,
        color: Colors.deepPurple,
      ),
      trailing: Switch(
          activeColor: Colors.deepPurple,
          value: switchbool,
          onChanged: (value) {
            toast();
            setState(() {
              if (switchbool == true) {
                switchbool = false;
              } else {
                switchbool = true;
              }
            });
          }),
    );
  }
}

class VideoCall extends StatelessWidget {
  const VideoCall({Key? key, required this.callID}) : super(key: key);
  final String callID;

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser?.phoneNumber;
    return ZegoUIKitPrebuiltCall(
      appID: 263175443,
      appSign:
          "8af14b6b605b70c3163ac4758156f742c64084c4511b1d62f93249da77db4d05",
      userID: user.toString(),
      userName: user.toString(),
      callID: callID,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        ..onOnlySelfInRoom = (context) => Navigator.of(context).pop(),
    );
  }
}

class VoiceCall extends StatelessWidget {
  const VoiceCall({Key? key, required this.callID}) : super(key: key);
  final String callID;

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser?.phoneNumber;
    return ZegoUIKitPrebuiltCall(
      appID: 263175443,
      appSign:
          "8af14b6b605b70c3163ac4758156f742c64084c4511b1d62f93249da77db4d05",
      userID: user.toString(),
      userName: user.toString(),
      callID: callID,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall()
        ..onOnlySelfInRoom = (context) => Navigator.of(context).pop(),
    );
  }
}

class ProfileEditingPage extends StatefulWidget {
  const ProfileEditingPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditingPage> createState() => _ProfileEditingPageState();
}

class _ProfileEditingPageState extends State<ProfileEditingPage> {
  late String hinttext = "Hey ! there, I am using ChatOFi";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final fstore2 = FirebaseFirestore.instance
        .collection("About${auth.currentUser?.phoneNumber.toString()}")
        .snapshots();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10),
        child: ListView(
          children: [
            const SizedBox(
              height: 60,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Profile photo ",
                  style: TextStyle(color: Colors.deepPurple),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const ListTile(
              title: Text(
                " LongPress on circle to update Profile Pic !",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepPurple),
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
                        builder: (context) =>
                            const ImageManagementForProfile()));
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 10, right: 10),
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.height * 0.3,
                child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: ProfilePhotos()),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: const [
                SizedBox(
                  width: 15,
                ),
                Text(
                  "Status",
                  style: TextStyle(color: Colors.deepPurple),
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const ListTile(
              title: Text(
                " LongPress on your Status to Update !",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.deepPurple),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: Colors.black)),
              child: ListTile(
                title: StreamBuilder<QuerySnapshot>(
                    stream: fstore2,
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(".....",
                            style:
                                TextStyle(fontSize: 25, color: Colors.black));
                      } else if (snapshot.hasError) {
                        return const Text(".....",
                            style:
                                TextStyle(fontSize: 25, color: Colors.black));
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Text(hinttext,
                            style: const TextStyle(
                                fontSize: 25, color: Colors.black));
                      } else {
                        return snapshot.data!.docs[0]['id'].toString() ==
                                auth.currentUser?.phoneNumber
                            ? Text(
                                snapshot.data!.docs[0]['title'],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
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
                          builder: (context) => const ProfileStatusEdit()));
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileStatusEdit extends StatefulWidget {
  const ProfileStatusEdit({
    Key? key,
  }) : super(key: key);

  @override
  State<ProfileStatusEdit> createState() => _ProfileStatusEditState();
}

class _ProfileStatusEditState extends State<ProfileStatusEdit> {
  bool loading = false;
  final phonenumbercontroller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Status"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(children: [
        Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 90),
              child: const Text(
                "Let's Edit Status !",
                style: TextStyle(fontSize: 30, color: Colors.deepPurple),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(20),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextFormField(
                  cursorColor: Colors.deepPurple,
                  controller: phonenumbercontroller,
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "Enter new Status",
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepPurple)),
                    hintStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
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
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.deepPurple)),
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    final user = _auth.currentUser?.phoneNumber;
                    final fstore = FirebaseFirestore.instance
                        .collection("About${user.toString()}");
                    fstore.doc(user.toString()).set({
                      "id": user.toString(),
                      "time": DateTime.now(),
                      "title": phonenumbercontroller.text.toString()
                    }).then((value) {
                      loading = false;
                    }).onError((error, stackTrace) {
                      Fluttertoast.showToast(msg: error.toString());
                    });
                    Navigator.pop(context);
                  },
                  child: (loading == true)
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Update Status",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
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

class ImageManagementForProfile extends StatefulWidget {
  const ImageManagementForProfile({
    Key? key,
  }) : super(key: key);

  @override
  State<ImageManagementForProfile> createState() =>
      _ImageManagementForProfileState();
}

class _ImageManagementForProfileState extends State<ImageManagementForProfile> {
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
      appBar: AppBar(
        title: const Text("Profile Image"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView(
        children: [
          Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 150, right: 40, left: 40),
              decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(17),
                  border: Border.all(color: Colors.deepPurple)),
              width: 200,
              height: 300,
              child: _image != null
                  ? Image.file(File(_image!.path))
                  : const Icon(
                      Icons.person,
                      size: 35,
                    )),
          const SizedBox(
            height: 30,
          ),
          Container(
            width: 200,
            margin: const EdgeInsets.only(right: 50, left: 50),
            child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.deepPurple)),
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });
                  fs.Reference storage =
                      fs.FirebaseStorage.instance.ref(user.toString());
                  fs.UploadTask uploadTask = storage.putFile(_image!.absolute);
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
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: loading == true
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Set as profile Image",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                )),
          )
        ],
      ),
    );
  }
}

class ProfilePhotos extends StatefulWidget {
  const ProfilePhotos({Key? key}) : super(key: key);

  @override
  State<ProfilePhotos> createState() => _ProfilePhotosState();
}

class _ProfilePhotosState extends State<ProfilePhotos> {
  final texter = TextEditingController();
  final auth = FirebaseAuth.instance;
  final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final fstore2 = FirebaseFirestore.instance
        .collection("${auth.currentUser?.phoneNumber.toString()}")
        .snapshots();
    return StreamBuilder<QuerySnapshot>(
        stream: fstore2,
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.deepPurple,
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
                : const Icon(Icons.people);
          }
        });
  }
}

class SearchContactsForStatus extends StatefulWidget {
  const SearchContactsForStatus({Key? key}) : super(key: key);

  @override
  State<SearchContactsForStatus> createState() =>
      _SearchContactsForStatusState();
}

class _SearchContactsForStatusState extends State<SearchContactsForStatus> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.deepPurple,
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Container(
            margin: const EdgeInsets.only(right: 10),
            child: TextFormField(
              autofocus: true,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              onChanged: (value) {
                setState(() {
                  controller = value.toString();
                });
              },
              decoration: const InputDecoration(
                hintText: "Enter Name for Status",
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple)),
                hintStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        body: (contacts) == null
            ? const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple))
            : ListView.builder(
                itemCount: contacts!.length,
                itemBuilder: (BuildContext context, int index) {
                  String num = (contacts![index].phones.isNotEmpty)
                      ? (contacts![index].phones.first.number)
                      : "--";
                  if ("${contacts![index].name.first} ${contacts![index].name.last}"
                          .toString()
                          .toLowerCase()
                          .contains(controller) &&
                      controller != "") {
                    return ListTile(
                      tileColor: Colors.white,
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: ProfilePhotosForOtherContacts(
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
                                    .replaceAll(' ', ''))),
                      ),
                      onTap: () {
                        Fluttertoast.showToast(msg: "Status ComingSoon");
                      },
                      title: Text(
                          "${contacts![index].name.first} ${contacts![index].name.last}"),
                      subtitle: Text(num),
                    );
                  } else if (controller == "") {
                    return ListTile(
                      tileColor: Colors.white,
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: ProfilePhotosForOtherContacts(
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
                                    .replaceAll(' ', ''))),
                      ),
                      onTap: () {
                        Fluttertoast.showToast(msg: "Status ComingSoon");
                      },
                      title: Text(
                          "${contacts![index].name.first} ${contacts![index].name.last}"),
                      subtitle: Text(num),
                    );
                  } else {
                    return Container();
                  }
                },
              ));
  }
}

class SearchContactsForCall extends StatefulWidget {
  const SearchContactsForCall({Key? key}) : super(key: key);

  @override
  State<SearchContactsForCall> createState() => _SearchContactsForCallState();
}

class _SearchContactsForCallState extends State<SearchContactsForCall> {
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
    return Scaffold(
        appBar: AppBar(
          leading: const BackButton(
            color: Colors.deepPurple,
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Container(
            margin: const EdgeInsets.only(right: 10),
            child: TextFormField(
              autofocus: true,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              onChanged: (value) {
                setState(() {
                  controller = value.toString();
                });
              },
              decoration: const InputDecoration(
                hintText: "Enter Name for Call",
                focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple)),
                hintStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        body: (contacts) == null
            ? const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple))
            : ListView.builder(
                itemCount: contacts!.length,
                itemBuilder: (BuildContext context, int index) {
                  String num = (contacts![index].phones.isNotEmpty)
                      ? (contacts![index].phones.first.number)
                      : "--";
                  if ("${contacts![index].name.first} ${contacts![index].name.last}"
                          .toString()
                          .toLowerCase()
                          .contains(controller) &&
                      controller != "") {
                    return ListTile(
                        tileColor: Colors.white,
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: ProfilePhotosForOtherContacts(
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
                                      .replaceAll(' ', ''))),
                        ),
                        title: Text(
                            "${contacts![index].name.first} ${contacts![index].name.last}"),
                        subtitle: Text(num),
                        onTap: () {
                          if ((contacts![index].phones.first.number)
                                  .toString()
                                  .length <
                              10) {
                            Fluttertoast.showToast(
                                msg: "Can't make call with this contact");
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Voice/Video Call"),
                                    content: Text(
                                        "Voice/Video Call to ${contacts![index].name.first} ${contacts![index].name.last}"),
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
                                          child: const Text("Videocall",
                                              style: TextStyle(
                                                  color: Colors.deepPurple,
                                                  fontSize: 18))),
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
                                          child: const Text("Voicecall",
                                              style: TextStyle(
                                                  color: Colors.deepPurple,
                                                  fontSize: 18))),
                                    ],
                                  );
                                });
                          }
                        });
                  } else if (controller == "") {
                    return ListTile(
                        tileColor: Colors.white,
                        leading: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          child: ProfilePhotosForOtherContacts(
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
                                      .replaceAll(' ', ''))),
                        ),
                        title: Text(
                            "${contacts![index].name.first} ${contacts![index].name.last}"),
                        subtitle: Text(num),
                        onTap: () {
                          if ((contacts![index].phones.first.number)
                                  .toString()
                                  .length <
                              10) {
                            Fluttertoast.showToast(
                                msg: "Can't make call with this contact");
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Voice/Video Call"),
                                    content: Text(
                                        "Voice/Video Call to ${contacts![index].name.first} ${contacts![index].name.last}"),
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
                                          child: const Text("Videocall",
                                              style: TextStyle(
                                                  color: Colors.deepPurple,
                                                  fontSize: 18))),
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
                                          child: const Text("Voicecall",
                                              style: TextStyle(
                                                  color: Colors.deepPurple,
                                                  fontSize: 18))),
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

class ContactsCalls extends StatefulWidget {
  const ContactsCalls({Key? key}) : super(key: key);

  @override
  ContactsCallsState createState() => ContactsCallsState();
}

class ContactsCallsState extends State<ContactsCalls> {
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("My contacts"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SearchContactsForCall()));
                },
                icon: const Icon(Icons.search))
          ],
          backgroundColor: Colors.deepPurple,
        ),
        body: (contacts) == null
            ? const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple))
            : ListView.builder(
                itemCount: contacts!.length,
                itemBuilder: (BuildContext context, int index) {
                  String num = (contacts![index].phones.isNotEmpty)
                      ? (contacts![index].phones.first.number)
                      : "--";
                  return ListTile(
                      tileColor: Colors.white,
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: ProfilePhotosForOtherContacts(
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
                                    .replaceAll(' ', ''))),
                      ),
                      title: Text(
                          "${contacts![index].name.first} ${contacts![index].name.last}"),
                      subtitle: Text(num),
                      onTap: () {
                        if ((contacts![index].phones.first.number)
                                .toString()
                                .length <
                            10) {
                          Fluttertoast.showToast(
                              msg: "Can't make call with this contact");
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Voice/Video Call"),
                                  content: Text(
                                      "Voice/Video Call to ${contacts![index].name.first} ${contacts![index].name.last}"),
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
                                        child: const Text("Videocall",
                                            style: TextStyle(
                                                color: Colors.deepPurple,
                                                fontSize: 18))),
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
                                        child: const Text("Voicecall",
                                            style: TextStyle(
                                                color: Colors.deepPurple,
                                                fontSize: 18))),
                                  ],
                                );
                              });
                        }
                      });
                },
              ));
  }
}

class ContactsListCalls extends StatefulWidget {
  const ContactsListCalls({Key? key}) : super(key: key);

  @override
  ContactsListCallsState createState() => ContactsListCallsState();
}

class ContactsListCallsState extends State<ContactsListCalls> {
  List<Contact>? contacts = [];
  final fstore = FirebaseFirestore.instance.collection('post');
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
      contacts2.add((contacts![i].phones.first.number.toString().contains("+91")
          ? (contacts![i].phones.first.number.toString()).replaceAll(' ', '')
          : "+91${contacts![i].phones.first.number.replaceAll(' ', '')}"));
    }

    for (int i = 0; i < contacts!.length; i++) {
      try {
        String curruntUser = (contacts![i]
                .phones
                .first
                .number
                .toString()
                .contains("+91")
            ? (contacts![i].phones.first.number.toString()).replaceAll(' ', '')
            : "+91${contacts![i].phones.first.number.replaceAll(' ', '')}");
        if (number.contains(curruntUser) &&
            curruntUser != "${auth.currentUser?.phoneNumber.toString()}") {
          return Text("${contacts![i].name.first} ${contacts![i].name.last}");
        } else if (number.toString().substring(0, 13) ==
                auth.currentUser?.phoneNumber.toString() &&
            !contacts2.contains(number.toString().substring(13, 26))) {
          return Text(number.toString().substring(13, 26));
        } else if (number.toString().substring(13, 26) ==
                auth.currentUser?.phoneNumber.toString() &&
            !contacts2.contains(number.toString().substring(0, 13))) {
          return Text(number.toString().substring(0, 13));
        }
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }
    }
  }

  contactIndexNameFinderString(String number) {
    for (int i = 0; i < contacts!.length; i++) {
      contacts2.add((contacts![i].phones.first.number.toString().contains("+91")
          ? (contacts![i].phones.first.number.toString()).replaceAll(' ', '')
          : "+91${contacts![i].phones.first.number.replaceAll(' ', '')}"));
    }

    for (int i = 0; i < contacts!.length; i++) {
      try {
        String curruntUser = (contacts![i]
                .phones
                .first
                .number
                .toString()
                .contains("+91")
            ? (contacts![i].phones.first.number.toString()).replaceAll(' ', '')
            : "+91${contacts![i].phones.first.number.replaceAll(' ', '')}");
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
    final fstore2 = FirebaseFirestore.instance
        .collection('calls')
        .orderBy('time', descending: true)
        .snapshots();
    final user = auth.currentUser?.phoneNumber;
    return Scaffold(
        backgroundColor: Colors.white,
        bottomSheet: Container(
          color: Colors.white,
          child: ListTile(
            tileColor: Colors.white,
            title: Container(
              margin: const EdgeInsets.only(bottom: 17),
              child: const Text(
                "Let's start !",
                style: TextStyle(color: Colors.deepPurple, fontSize: 30),
              ),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: fstore2,
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurple,
                  ),
                );
              } else if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "Let's start !",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.deepPurple, fontSize: 30),
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
                              leading: CircleAvatar(
                                  backgroundColor: Colors.deepPurple,
                                  child: ProfilePhotosForOtherContacts(
                                      curruntnumber: snapshot
                                          .data!.docs[index]['id']
                                          .toString()
                                          .substring(13, 26))),
                              title: contactIndexNameFinder(
                                  snapshot.data!.docs[index]['id']),
                              subtitle: const Text("Activity : Outgoing"),
                              trailing: Text(snapshot.data!.docs[index]['time2']
                                  .toString()),
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Delete Call"),
                                        content: Text(
                                            "Delete Call with ${contactIndexNameFinderString(snapshot.data!.docs[index]['id'])} ?"),
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
                                              child: const Text("Delete",
                                                  style: TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontSize: 18)))
                                        ],
                                      );
                                    });
                              },
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Voice/Video Call"),
                                        content: Text(
                                            "make Voice/Video call ${contactIndexNameFinderString(snapshot.data!.docs[index]['id'])}"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                final fstore = FirebaseFirestore
                                                    .instance
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
                                                }).onError((error, stackTrace) {
                                                  Fluttertoast.showToast(
                                                      msg: error.toString());
                                                });
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            VideoCall(
                                                              callID: callIdFinder(
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          ['id']
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          13),
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          ['id']
                                                                      .toString()
                                                                      .substring(
                                                                          13,
                                                                          26)),
                                                            )));
                                              },
                                              child: const Text("Videocall",
                                                  style: TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontSize: 18))),
                                          TextButton(
                                              onPressed: () {
                                                final fstore = FirebaseFirestore
                                                    .instance
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
                                                }).onError((error, stackTrace) {
                                                  Fluttertoast.showToast(
                                                      msg: error.toString());
                                                });
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            VoiceCall(
                                                              callID: callIdFinder(
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          ['id']
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          13),
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          ['id']
                                                                      .toString()
                                                                      .substring(
                                                                          13,
                                                                          26)),
                                                            )));
                                              },
                                              child: const Text("Voicecall",
                                                  style: TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontSize: 18))),
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
                                  backgroundColor: Colors.deepPurple,
                                  child: ProfilePhotosForOtherContacts(
                                      curruntnumber: snapshot
                                          .data!.docs[index]['id']
                                          .toString()
                                          .substring(0, 13))),
                              title: contactIndexNameFinder(
                                  snapshot.data!.docs[index]['id']),
                              subtitle: const Text("Activity : Incoming"),
                              trailing: Text(snapshot.data!.docs[index]['time2']
                                  .toString()),
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Delete Call"),
                                        content: Text(
                                            "Delete Call with ${contactIndexNameFinderString(snapshot.data!.docs[index]['id'])} ?"),
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
                                              child: const Text("Delete",
                                                  style: TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontSize: 18)))
                                        ],
                                      );
                                    });
                              },
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text("Voice/Video Call"),
                                        content: Text(
                                            "Voice/Video Call to ${contactIndexNameFinderString(snapshot.data!.docs[index]['id'])}"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                final fstore = FirebaseFirestore
                                                    .instance
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
                                                }).onError((error, stackTrace) {
                                                  Fluttertoast.showToast(
                                                      msg: error.toString());
                                                });
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            VideoCall(
                                                              callID: callIdFinder(
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          ['id']
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          13),
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          ['id']
                                                                      .toString()
                                                                      .substring(
                                                                          13,
                                                                          26)),
                                                            )));
                                              },
                                              child: const Text("Videocall",
                                                  style: TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontSize: 18))),
                                          TextButton(
                                              onPressed: () {
                                                final fstore = FirebaseFirestore
                                                    .instance
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
                                                }).onError((error, stackTrace) {
                                                  Fluttertoast.showToast(
                                                      msg: error.toString());
                                                });
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            VoiceCall(
                                                              callID: callIdFinder(
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          ['id']
                                                                      .toString()
                                                                      .substring(
                                                                          0,
                                                                          13),
                                                                  snapshot
                                                                      .data!
                                                                      .docs[
                                                                          index]
                                                                          ['id']
                                                                      .toString()
                                                                      .substring(
                                                                          13,
                                                                          26)),
                                                            )));
                                              },
                                              child: const Text("Voicecall",
                                                  style: TextStyle(
                                                      color: Colors.deepPurple,
                                                      fontSize: 18))),
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
            }));
  }
}

// PROJECT COMPLETED
//    ❤️❤️❤️❤️❤️
// Made by PARTH THAKOR
