import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_myapp/model/menu_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MenuController {
  
  final _menustore = FirebaseFirestore.instance.collection('menu');
  firebase_storage.Reference refProfile = firebase_storage.FirebaseStorage.instance.ref('menu');
  
  Future<bool> addNewMenu(MenuItemModel menuItem, List<XFile> fileItem) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      // # upload image
      var queue = <Future<TaskSnapshot>>[];
      var pathDownload = [];
      for (final file in fileItem) {
        final path = '${user.uid}/${file.name}-${DateTime.now().millisecondsSinceEpoch}';
        pathDownload.add(path);
        queue.add(
          refProfile
            .child(path)
            .putFile(File(file.path))
        );
      }

      final resultUpload = await Future.wait(queue);
      if (resultUpload.where((snap) => snap.state != TaskState.success).isNotEmpty) {
        log("snap is not success");
        return false;
      }

      // # assing img path
      final resultDownload = await Future.wait(pathDownload.map((path) => refProfile
        .child(path)
        .getDownloadURL()
      ));

      menuItem.imgPath = resultDownload;

      // # add menu
      await _menustore.doc().set({
        ...menuItem.toMap(),
        "uid": user.uid
      });

      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<QuerySnapshot?> getMenuItem() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return null;
      return _menustore.where('uid', isEqualTo: user.uid).get();
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}