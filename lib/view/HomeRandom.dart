import 'package:flutter/material.dart';
import 'package:test_myapp/components/ItemMenuComponent.dart';
import 'package:test_myapp/controller/MenuController.dart';
import 'package:test_myapp/model/menu_model.dart';

class HomeRandom extends StatefulWidget {
  const HomeRandom({ Key? key }) : super(key: key);

  @override
  _HomeRandomState createState() => _HomeRandomState();
}

class _HomeRandomState extends State<HomeRandom> {

  final menuController = MenuController();

  Future<Map<String, MenuItemModel>?> _random() async {
    try {
      final queryItem = await menuController.randomMenu();
      if (queryItem == null) return null;
      return queryItem;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [

        FutureBuilder(
          future: _random(),
          builder: (context, snapshot) {

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Text("ERROR");
            }

            if (snapshot.hasData && snapshot.data == null) {
              return Text("Empty menu please add.");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              final menuItem = snapshot.data as Map<String, MenuItemModel>;
              return Container(
                margin: EdgeInsets.all(80),
                child: ItemMenuComponent(
                  docId: menuItem.keys.first,
                  menuItem: menuItem.values.first,
                )
              );
            }

            return Container();
          },
        ),

        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {});
          }, 
          child: Text("Random")
        )
      ],
    );
  }
}