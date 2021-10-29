import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

abstract class CloudStorage{
  final _firebaseStorage = FirebaseStorage.instance;

  //Set New Profile Photo
  Future<void> setProfilePhoto({String userID, File imageFile});

  //Set New Item Photo
  Future<void> setItemPhoto({String itemID, File imageFile});

  //Delete Item Photo
  Future<void> deleteItemPhoto({String itemID});

}