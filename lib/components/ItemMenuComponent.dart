import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:test_myapp/model/menu_model.dart';

class ItemMenuComponent extends StatefulWidget {

  final String docId;
  final MenuItemModel menuItem;

  const ItemMenuComponent({ 
    Key? key,
    required this.docId,
    required this.menuItem
  }) : super(key: key);

  @override
  _ItemMenuComponentState createState() => _ItemMenuComponentState();
}

class _ItemMenuComponentState extends State<ItemMenuComponent> {
  @override
  Widget build(BuildContext context) {
    return SlideInUp(
      duration: Duration(milliseconds: 300),
      from: 20,
      child: FadeIn(
        duration: Duration(milliseconds: 300),
        child: Card(
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/update_menu_item', arguments: {
                "docId": widget.docId,
                "menuItem" : widget.menuItem
              }).then((value) {
                if (value == null) return;
                setState(() {});
              });
            },
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(widget.menuItem.imgPath.first),
                  SizedBox(height: 10),
                  Text(widget.menuItem.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16
                    )),
                  Text(widget.menuItem.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey
                    ))
                ]
              )
            )
          ),
        ),
      ),
    );
  }
}