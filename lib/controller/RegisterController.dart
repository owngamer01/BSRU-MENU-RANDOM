import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_myapp/model/auth_model.dart';
import 'package:test_myapp/model/status_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class RegisterController {

  final firebase  = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance.collection('users');
  firebase_storage.Reference refProfile = firebase_storage.FirebaseStorage.instance.ref('users');
  /*
    @true data = UserCredential
  */
  Future<StatusResponse> onRegister({
    required File profile,
    required String username,
    required String password,
    required String fullname,
    String nickname = ''
  }) async {
    try {

      // # สร้าง User ใน Firebase Auth
      UserCredential userCredential = await firebase.createUserWithEmailAndPassword(
        email: username,
        password: password
      );

      // # อัพโหลดรูปลง Store
      String profilePath = '${userCredential.user!.uid}/profile';
      await (refProfile.child(profilePath).putFile(profile));
      final imageFile = await refProfile
        .child(profilePath)
        .getDownloadURL();

      // # เก็บข้อมูล User ลงใน Firestore
      final mapData = {
        "email": userCredential.user!.email,
        "fullname": fullname,
        "nickname": nickname,
        "profile": imageFile
      };
      await firestore.doc(userCredential.user!.uid).set(mapData);

      return StatusResponse(
        status: true,
        data: AuthModel.fromMap(mapData)
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return StatusResponse(
          status: false,
          message: 'The password provided is too weak.'
        );
      } else if (e.code == 'email-already-in-use') {
        return StatusResponse(
          status: false,
          message: 'The account already exists for that email.'
        );
      }
      return StatusResponse(
        status: false,
        message: 'Error ${e.code}'
      );
    }
  }
}