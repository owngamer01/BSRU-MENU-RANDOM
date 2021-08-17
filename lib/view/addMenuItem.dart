import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_myapp/controller/MenuController.dart';
import 'package:test_myapp/model/menu_model.dart';

class AddMenuItem extends StatefulWidget {
  const AddMenuItem({ Key? key }) : super(key: key);

  @override
  _AddMenuItemState createState() => _AddMenuItemState();
}

class _AddMenuItemState extends State<AddMenuItem> {

  final pageController = PageController(initialPage: 0);
  final _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final MenuController menuController = MenuController();
  
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  
  List<XFile> _fileItem = [];
  MenuItemModel _itemModel = MenuItemModel(
    imgPath: [], 
    name: "", 
    description: "", 
    item: []
  );

  _uploadFile() async {
    final List<XFile>? images = await _picker.pickMultiImage();
    if (images != null) {
      setState(() {
        this._fileItem = images;
      });
    }
  }

  _createNewMenu() async {
    _itemModel.name = nameController.text;
    _itemModel.description = descriptionController.text;
    _itemModel.item = _itemModel.item.map((item) {
      return MenuItemModelDetail(
        name: item.controller!.text,
        unit: num.parse(item.unitController!.text)
      );
    }).toList();

    final result = await menuController.addNewMenu(_itemModel, _fileItem);
    log("RESULT : ${result}");
    if (result) {
      Navigator.pop(context, result);
    }
  }

  _addMenuDetail() {
    setState(() {
      this._itemModel.item.add(MenuItemModelDetail(
        name: "",
        unit: 1,
        controller: TextEditingController(),
        unitController: TextEditingController(text: '1')
      ));
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    nameController.dispose();
    descriptionController.dispose();
    for (var item in this._itemModel.item) {
      item.controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Menu Item")
      ),
      body: SafeArea(
        bottom: false,
        child: Container(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(20),
                  padding: EdgeInsets.only(bottom: 80),
                  child: Column(
                    children: [
                      Container(
                        child: _fileItem.isEmpty
                        ? InkWell(
                          onTap: _uploadFile,
                          child: Center(
                            child: Container(
                              color: Colors.grey[400],
                              width: 220,
                              height: 220,
                              alignment: Alignment.center,
                              child: Text("UPLOAD FILES"),
                            ),
                          ),
                        )
                        : Container(
                          height: 250,
                          width: double.infinity,
                          child: PageView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            controller: pageController,
                            children: [
                              ...this._fileItem.map((item) {
                                return Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: FileImage(File(item.path)),
                                      fit: BoxFit.cover
                                    )
                                  )
                                );
                              }).toList(),
                              InkWell(
                                onTap: _uploadFile,
                                child: Container(
                                  alignment: Alignment.center,
                                  child: Text("UPLOAD MORE", style: TextStyle(
                                    fontSize: 20
                                  )),
                                ),
                              )
                            ]
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: "กรอกชื่อรายการอาหาร",
                                labelText: 'ชื่อรายการอาหาร'
                              )
                            ),
                            TextFormField(
                              controller: descriptionController,
                              decoration: InputDecoration(
                                hintText: "กรอกชื่อรายละเอียด",
                                labelText: 'รายละเอียด'
                              )
                            ),

                            SizedBox(height: 20),

                            ElevatedButton(
                              onPressed: _addMenuDetail, 
                              child: Text("เพิ่มสูตร")
                            ),

                            Column(
                              children: this._itemModel.item.map((item) {
                                return Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: item.controller,
                                        decoration: InputDecoration(
                                          hintText: "กรอกชื่อวัสถุดิบ",
                                          labelText: 'ชื่อวัสดุดิบ'
                                        )
                                      ),
                                    ),
                                    SizedBox(width: 30),
                                    SizedBox(
                                      width: 80,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        controller: item.unitController,
                                        decoration: InputDecoration(
                                          hintText: "จำนวนวัสถุดิบ",
                                          labelText: 'จำนวน'
                                        )
                                      ),
                                    )
                                  ]
                                );
                              }).toList(),
                            )
                          ]
                        )
                      )
                    ]
                  )
                ),
              ),
              Positioned(
                bottom: 0,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      this._createNewMenu();
                    },
                    child: Text("บันทึกข้อมูล"),
                  ),
                )
              )
            ],
          ),
        ),
      )
    );
  }
}