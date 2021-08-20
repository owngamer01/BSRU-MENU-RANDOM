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
  firebase_storage.Reference refMenu = firebase_storage.FirebaseStorage.instance.ref('menu');


  Future<List<String>?> uploadImage(User user, List<XFile> fileItem) async {
    try {
      // # upload image
      var queue = <Future<TaskSnapshot>>[];
      var pathDownload = <String>[];
      for (final file in fileItem) {
        final path = '${user.uid}/${file.name}-${DateTime.now().millisecondsSinceEpoch}.jpg';
        pathDownload.add(path);
        queue.add(
          refMenu
            .child(path)
            .putFile(File(file.path))
        );
      }

      final resultUpload = await Future.wait(queue);
      if (resultUpload.where((snap) => snap.state != TaskState.success).isNotEmpty) {
        log("snap is not success");
        return null;
      }

      return await Future.wait(pathDownload.map((path) => refMenu
        .child(path)
        .getDownloadURL()
      ));
    } catch (e) {
      return null;
    }
  }
  
  Future<bool> addNewMenu(MenuItemModel menuItem, List<XFile> fileItem) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      // # assing img path
      final resultPath = await this.uploadImage(user, fileItem);
      if (resultPath == null) {
        log("upload null check.");
        return false;
      }

      menuItem.imgPath = resultPath;

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

  Future<bool> updateNewMenu(String docId, MenuItemModel menuItem, List<XFile> fileItem) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      final resultPath = await this.uploadImage(user, fileItem);
      if (resultPath == null) {
        log("upload null check.");
        return false;
      }
      
      if (resultPath.length > 0) {
        menuItem.imgPath.addAll(resultPath);
      }

      // # add menu
      await _menustore.doc(docId).update({
        ...menuItem.toMap()
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