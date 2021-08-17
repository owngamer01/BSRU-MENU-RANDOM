import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_myapp/model/status_model.dart';

class AuthController {
  Future<StatusResponse> loginWithEmail({
    required username,
    required password
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: username,
        password: password
      );
      log(userCredential.user.toString());
      return StatusResponse(
        status: true,
        data: null
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return StatusResponse(
          status: false,
          message: 'No user found for that email.'
        );
      } else if (e.code == 'wrong-password') {
        return StatusResponse(
          status: false,
          message: 'Wrong password provided for that user.'
        );
      }
      return StatusResponse(
        status: false,
        message: 'Error ${e.code}'
      );
    }
  } 
}