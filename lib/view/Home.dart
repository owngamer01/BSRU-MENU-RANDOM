import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_myapp/view/HomeMenu.dart';
import 'package:test_myapp/view/HomeRandom.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirebaseAuth auth = FirebaseAuth.instance;
  int _indexTap = 0;

  List<Widget> pages = [
    HomeMenu(),
    HomeRandom()
  ];

  _changeTap(int index) {
    setState(() {
      this._indexTap = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/add_menu_item").then((value) {
                  if (value == null) return;
                  setState(() {});
                });
              }, 
              icon: Icon(Icons.add)
            )
          ]
        ),
        body: SafeArea(
          child: pages[_indexTap]
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _changeTap,
          currentIndex: _indexTap,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: "Item"
            )
          ]
        ),
      ),
    );
  }
}