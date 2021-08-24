import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
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
  late ShakeDetector detector;

  int shakeCounter = 0;
  final int shakeShouldRandom = 3;

  Future<Map<String, MenuItemModel>?> _random() async {
    try {
      final queryItem = await menuController.randomMenu();
      if (queryItem == null) return null;
      return queryItem;
    } catch (e) {
      return null;
    }
  }

  _shakeHandle() async {
    shakeCounter += 1;
    if (shakeCounter >= shakeShouldRandom) {
      await this._random();
      shakeCounter = 0;
    }
  }

  @override
  void initState() {
    super.initState();
    detector = ShakeDetector.autoStart(
      onPhoneShake: _shakeHandle
    );
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
              return Center(child: Text("ERROR"));
            }

            if (snapshot.data == null) {
              return Center(child: Text("Empty menu please add."));
            }

            if (snapshot.connectionState == ConnectionState.done) {
              final menuItem = snapshot.data as Map<String, MenuItemModel>;
              return Container(
                padding: EdgeInsets.all(50),
                child: Column(
                  children: [
                    ItemMenuComponent(
                      docId: menuItem.keys.first,
                      menuItem: menuItem.values.first,
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      }, 
                      child: Text("Random")
                    )
                  ]
                )
              );
            }
            return Container();
          },
        )
      ],
    );
  }
}