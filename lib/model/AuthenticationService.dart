import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rgbify/theme/routes.dart';



class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.idTokenChanges();

  //Signs a user in with email + password through firebase
  Future<String> signInWithEmail({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
      );
      return "Signed In";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //Creates a user on firebase with email + password
  Future<String> signUp({BuildContext context, String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password,
      );

      //Closes registrations screen after user is authorized and navigates to controllers screen
      Navigator.pop(context);

      return "Signed Up";

    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //Signs user out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

}