
import 'package:ags_ims/core/models/images.dart';
import 'package:ags_ims/core/models/item_details.dart';
import 'package:ags_ims/core/models/user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class FireStoreDB{

  //Get User Details
  Future<UserDetails> getUserDetails({String userID});

  //Set User Details
  Future<void> setUserDetails({UserDetails userDetails});

  //Update User Details
  Future<void> updateUserDetails({UserDetails userDetails});

  //Delete User Details
  Future<void> deleteUserDetails({String userID});

  //Set Specific Profile Photo
  Future<void> setProfilePhoto({Images profilePhoto});

  //Add Item
  Future<void> setStocksItem({ItemDetails itemDetails});

  //Get Item
  Future<void> getStocksItem({String itemID});

  //Get Items
  Future<void> getStocks();

  //Update Item
  Future<void> updateStocksItem({ItemDetails itemDetails});

  //Delete Item
  Future<void> deleteStocksItem({ItemDetails itemDetails});
}