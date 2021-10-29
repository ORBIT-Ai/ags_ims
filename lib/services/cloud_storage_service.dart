// ignore_for_file: prefer_typing_uninitialized_variables, avoid_print

import 'dart:io';

import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/cloud_storage.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class CloudStorageService extends CloudStorage {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final _baseUtils = locator<BaseUtils>();
  final _auth = locator<Auth>();

  @override
  Future<Reference> setProfilePhoto(
      {@required userID, @required File imageFile}) async {
    final imageID = _baseUtils.timeStamp();

    print(_auth.getCurrentUserID());

    var ref;

    try {
      imageFile != null
          ? await _firebaseStorage
              .ref("users")
              .child(userID)
              .child("images")
              .child("profile_photos")
              .child("$imageID.png")
              .putFile(imageFile)
              .then((value) {
              ref = value.ref;
            }).onError((e, stackTrace) {
              print("STORAGE ERROR:: $e");
            })
          : print("EMPTY FILE");
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print("STORAGE EXCEPTION:: $e");
    }
    return ref;
  }

  @override
  Future<Reference> setItemPhoto(
      {@required itemID, @required File imageFile}) async {
    final imageID = _baseUtils.timeStamp();

    print(_auth.getCurrentUserID());

    var ref;

    try {
      imageFile != null
          ? await _firebaseStorage
              .ref("items")
              .child(itemID)
              .child("$imageID.png")
              .putFile(imageFile)
              .then((value) {
              ref = value.ref;
            }).onError((e, stackTrace) {
              print("STORAGE ERROR:: $e");
            })
          : print("EMPTY FILE");
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print("STORAGE EXCEPTION:: $e");
    }
    return ref;
  }

  @override
  Future<Reference> deleteItemPhoto({@required itemID}) async {
    final imageID = _baseUtils.timeStamp();

    print(_auth.getCurrentUserID());

    var ref;

    try {
      await _firebaseStorage
          .ref("items")
          .child(itemID)
          .child("$imageID.png")
          .delete()
          .then((value) {
        print("IMAGE SUCCESSFULLY DELETED");
      }).onError((e, stackTrace) {
        print("STORAGE ERROR:: $e");
      });
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print("STORAGE EXCEPTION:: $e");
    }
    return ref;
  }
}
