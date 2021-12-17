import 'dart:html';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

abstract class CloudStorage{
  final _firebaseStorage = FirebaseStorage.instance;

  //Set New Profile Photo
  Future<void> setProfilePhoto({String userID, Uint8List imageFile});

  //Set New Item Photo
  Future<void> setItemPhoto({String itemID, Uint8List imageFile});

  //Set New Item BarCode Photo
  Future<void> setItemBarCodePhoto({String itemID, Uint8List imageFile});

  //Delete Item Photo
  Future<void> deleteItemPhoto({String itemID});

}