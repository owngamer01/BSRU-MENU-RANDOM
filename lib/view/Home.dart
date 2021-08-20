import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:test_myapp/controller/MenuController.dart';
import 'package:test_myapp/model/menu_model.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final MenuController menuController = MenuController();
  final FirebaseAuth auth = FirebaseAuth.instance;
  int _indexTap = 0;

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
          title: Text("TEST"),
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
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: FutureBuilder<QuerySnapshot?>(
              future: this.menuController.getMenuItem(),
              builder: (context, snapshot) {

                if (snapshot.hasError) {
                  return Text("Has Error");
                }
                if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                  return Text("Docs is empty");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  var data = snapshot.data!.docs;
                  return StaggeredGridView.count(
                    crossAxisCount: 2,
                    staggeredTiles: data.map((_) => StaggeredTile.fit(1)).toList(),
                    children: data.map((doc) {
                      MenuItemModel menuItem = MenuItemModel.fromJson(jsonEncode(doc.data()));
                      return Material(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/update_menu_item', arguments: {
                              "menuItem" : menuItem
                            });
                          },
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.network(menuItem.imgPath.first),
                                  SizedBox(height: 10),
                                  Text(menuItem.name, style: TextStyle(
                                    fontSize: 16
                                  )),
                                  Text(menuItem.description, style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey
                                  ))
                                ]
                              )
                            )
                          ),
                        ),
                      );
                    }).toList()
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }
            )
          )
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