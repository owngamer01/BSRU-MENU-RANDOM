import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_myapp/controller/MenuController.dart';
import 'package:test_myapp/model/menu_model.dart';

class AddMenuItem extends StatefulWidget {

  final bool isUpdate;
  final MenuItemModel? menuItem;
  final String? docId;

  const AddMenuItem({ 
    Key? key,
    this.isUpdate = false,
    this.menuItem,
    this.docId
  }) : super(key: key);

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
  List<String> _fileItemURL = [];

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

  _actionMenu() async {
    _itemModel.name = nameController.text;
    _itemModel.description = descriptionController.text;
    _itemModel.item = _itemModel.item.map((item) {
      return MenuItemModelDetail(
        name: item.controller!.text,
        unit: num.parse(item.unitController!.text)
      );
    }).toList();

    if (!widget.isUpdate) {
      final result = await menuController.addNewMenu(_itemModel, _fileItem);
      if (result) {
        Navigator.pop(context, result);
      }
    } else {
      log(widget.docId!);
      final result = await menuController.updateNewMenu(widget.docId!, _itemModel, _fileItem);
      if (result) {
        Navigator.pop(context, result);
      }
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

  List<Widget> _imageRender() {
    List<Widget> render = [];
    if (widget.isUpdate) {
      render = this._fileItemURL.map((path) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(path),
              fit: BoxFit.cover
            )
          )
        );
      }).toList();
    }

    if (this._fileItem.length > 0) {
      render.addAll(this._fileItem.map((item) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: FileImage(File(item.path)),
              fit: BoxFit.cover
            )
          )
        );
      }).toList());
    }
    return render;
  }

  _init() async {
    if(widget.isUpdate) {
      this._fileItemURL = widget.menuItem!.imgPath;
      this.nameController.text = widget.menuItem!.name;
      this.descriptionController.text = widget.menuItem!.description;
      widget.menuItem!.item = widget.menuItem!.item.map((item) {
        return MenuItemModelDetail(
          name: item.name,
          unit: item.unit,
          controller: TextEditingController(text: item.name),
          unitController: TextEditingController(text: item.unit.toString())
        );
      }).toList();
      this._itemModel = widget.menuItem!;
    }
  }

  @override
  void initState() {
    super.initState();
    this._init();
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
        title: Text("Add Menu Item"),
        actions: [
          TextButton(
            onPressed: _actionMenu, 
            child: Text(widget.isUpdate ? "อัพเดท" : "บันทึก", style: TextStyle(
              color: Colors.white
            ))
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  child: _fileItem.isEmpty && _fileItemURL.isEmpty
                  ? SizedBox(
                    width: 220,
                    height: 220,
                    child: InkWell(
                      onTap: _uploadFile,
                      child: Center(
                        child: Container(
                          color: Colors.grey[400],
                          alignment: Alignment.center,
                          child: Text("UPLOAD FILES"),
                        ),
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
                        ...this._imageRender(),
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
      )
    );
  }
}