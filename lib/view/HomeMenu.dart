import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:test_myapp/components/ItemMenuComponent.dart';
import 'package:test_myapp/controller/MenuController.dart';
import 'package:test_myapp/model/menu_model.dart';

class HomeMenu extends StatefulWidget {
  const HomeMenu({ Key? key }) : super(key: key);

  @override
  _HomeMenuState createState() => _HomeMenuState();
}

class _HomeMenuState extends State<HomeMenu> {

  final menuController = MenuController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot?>(
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
              return ItemMenuComponent(
                docId: doc.id,
                menuItem: menuItem,
                key: ValueKey(doc.id),
              );
            }).toList()
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}