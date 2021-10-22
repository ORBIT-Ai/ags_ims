// ignore_for_file: avoid_single_cascade_in_expression_statements, prefer_const_constructors, avoid_print, prefer_null_aware_operators

import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/views/home_page.dart';
import 'package:ags_ims/views/login_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Auth {
  final _firebaseDb = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User> getCurrentUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;

    return user;
  }

  getCurrentUserID() {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final user = _auth.currentUser;
    final uid = user != null ? user.uid : null;

    return user != null ? uid : null;
  }

  Future<void> deleteAccount() async {
    User user = FirebaseAuth.instance.currentUser;
    user != null ? user.delete() : print("NO USER AUTHENTICATED");
  }

  Future<void> signOut({@required BuildContext context}) async {
    _auth.signOut().whenComplete(() {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    });
  }

  Future<void> signInEmailPassword(
    BuildContext context,
    GlobalKey<FormState> _loginFormKey,
    TextEditingController emailInputController,
    TextEditingController pwdInputController,
  ) async {
    if (_loginFormKey.currentState.validate()) {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailInputController.text,
              password: pwdInputController.text)
          .then((currentUser) {
        if (currentUser != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
          BaseUtils().snackBarNoProgress(
              context: context, content: "Successfully Logged In");
        } else {
          BaseUtils().errorDialog(context,
              "The account may not exists or the password is invalid.");
        }
      }).catchError((err) => {
                BaseUtils().errorDialog(context,
                    "The account may not exists or the password is invalid.")
              });
    }
  }

  Future<UserCredential> signUpWithEmailPassword(
      {@required String email, @required String password}) {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((currentUser) {
      return currentUser;
    }).catchError((e) {
      print("ERROR SETTING UP CREDENTIALS: ${e.details}");
    });
  }
}
