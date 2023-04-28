// HOME ACTIVITY

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatofi/chatbot.dart';
import 'package:chatofi/chatcontacts.dart';
import 'package:chatofi/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'callcontacts.dart';
import 'contactsorting.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late TabController tabController;
  var length = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(initialIndex: 0, length: 3, vsync: this);
    tabController.addListener(() {
      setState(() {
        length = tabController.index;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: mainScafFoldBody(context),
    );
  }

  appBar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor:
              (darkmode == true) ? const Color(0xFF212121) : Colors.white),
      title: AnimatedTextKit(
        animatedTexts: [
          TypewriterAnimatedText('  ChatOFi...',
              textStyle: GoogleFonts.kaushanScript(
                  fontSize: 23,
                  color: (darkmode) ? Colors.greenAccent : Colors.black,
                  fontWeight: FontWeight.bold)),
        ],
        totalRepeatCount: 1,
      ),
      backgroundColor: (darkmode == true)
          ? const Color(0xFF303030)
          : Colors.white.withOpacity(0.2),
      actions: appBarActionButtons(context),
      bottom: tabBar(),
    );
  }

  appBarActionButtons(BuildContext context) {
    if (length == 2) {
      return [
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
                        "Do you want to Delete all call logs ?",
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
                              await deleteAllCallLog();
                              setState(() {
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                    msg: "All call logs are Deleted");
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
              Icons.delete_rounded,
              color: (darkmode) ? Colors.white : Colors.black,
            )),
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
        IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Settings()));
            },
            icon: Icon(
              Icons.settings,
              color: (darkmode) ? Colors.white : Colors.black,
            ))
      ];
    } else if (length == 1) {
      return [
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
                              await deleteAllChat();
                              setState(() {
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                    msg: "All messages are Deleted");
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
              Icons.delete_rounded,
              color: (darkmode) ? Colors.white : Colors.black,
            )),
        IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Settings()));
            },
            icon: Icon(
              Icons.settings,
              color: (darkmode) ? Colors.white : Colors.black,
            ))
      ];
    } else if (length == 0) {
      return [
        IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SortingForChat()));
            },
            icon: Icon(
              Icons.search,
              color: (darkmode) ? Colors.white : Colors.black,
            )),
        IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Settings()));
            },
            icon: Icon(
              Icons.settings,
              color: (darkmode) ? Colors.white : Colors.black,
            ))
      ];
    }
  }

  tabBar() {
    return TabBar(
      indicatorSize: TabBarIndicatorSize.tab,
      controller: tabController,
      indicatorColor: (darkmode) ? Colors.cyanAccent : Colors.pinkAccent,
      tabs: [
        Tab(
            child: Text(
          "CHATS",
          style: GoogleFonts.orbitron(
              fontSize: 13,
              color: (length == 0)
                  ? (darkmode)
                      ? Colors.cyanAccent
                      : Colors.pinkAccent
                  : (darkmode)
                      ? Colors.white
                      : Colors.black,
              fontWeight: FontWeight.bold),
        )),
        Tab(
            child: Text(
          "CHATBOT",
          style: GoogleFonts.orbitron(
              fontSize: 13,
              color: (length == 1)
                  ? (darkmode)
                      ? Colors.cyanAccent
                      : Colors.pinkAccent
                  : (darkmode)
                      ? Colors.white
                      : Colors.black,
              fontWeight: FontWeight.bold),
        )),
        Tab(
            child: Text(
          "CALLS",
          style: GoogleFonts.orbitron(
              fontSize: 13,
              color: (length == 2)
                  ? (darkmode)
                      ? Colors.cyanAccent
                      : Colors.pinkAccent
                  : (darkmode)
                      ? Colors.white
                      : Colors.black,
              fontWeight: FontWeight.bold),
        )),
      ],
    );
  }

  mainScafFoldBody(BuildContext context) {
    return TabBarView(controller: tabController, children: [
      Scaffold(
        backgroundColor:
            (darkmode == true) ? const Color(0xFF212121) : Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ChatBackEnd()));
          },
          backgroundColor:
              (darkmode == true) ? Colors.cyanAccent : Colors.pinkAccent,
          child: Icon(
            Icons.mark_unread_chat_alt_rounded,
            color: (darkmode) ? Colors.black : Colors.white,
          ),
        ),
        body: const ChatFrontEnd(),
      ),
      const ChatBotPage(),
      Scaffold(
        backgroundColor:
            (darkmode == true) ? const Color(0xFF212121) : Colors.white,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CallContactsBackEnd()));
          },
          backgroundColor:
              (darkmode == true) ? Colors.cyanAccent : Colors.pinkAccent,
          child: Icon(
            Icons.add_call,
            color: (darkmode) ? Colors.black : Colors.white,
          ),
        ),
        body: const CallContactsFrontEnd(),
      )
    ]);
  }
}
