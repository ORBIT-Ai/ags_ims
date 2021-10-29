// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:ags_ims/core/models/item_details.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/cloud_storage_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/views/home_page.dart';
import 'package:ags_ims/views/home_pages/stocks_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ItemViewModel {
  final _fireStoreDB = locator<FireStoreDBService>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _cloudStorage = locator<CloudStorageService>();

  Future<void> addItem({
    @required BuildContext context,
    @required String itemID,
    @required String itemName,
    @required File itemImage,
    @required String itemCode,
    @required int itemPrice,
    @required int itemCount,
  }) async {
    _cloudStorage
        .setItemPhoto(itemID: itemID, imageFile: itemImage)
        .then((value) async {

      ItemDetails itemDetails = ItemDetails(
        itemID: itemID,
        itemName: itemName,
        itemImage: await value.getDownloadURL(),
        itemCode: itemCode,
        itemPrice: itemPrice,
        itemCount: itemCount,
        isOnHand: true,
        isActive: true,
        isDeleted: false,
        isTrashed: false,
      );
      _fireStoreDB.setItem(itemDetails: itemDetails).whenComplete(() {
        _baseUtils.snackBarNoProgress(
            context: context, content: 'Item Successfully Added');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      title: 'Stocks',
                      currentPage: StocksPage(),
                    )));
      });
    });
  }
}
