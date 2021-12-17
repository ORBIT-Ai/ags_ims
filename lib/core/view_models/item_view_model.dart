// ignore_for_file: prefer_const_constructors

import 'dart:html';
import 'dart:typed_data';

import 'package:ags_ims/core/enums/history_types.dart';
import 'package:ags_ims/core/models/item_details.dart';
import 'package:ags_ims/core/view_models/history_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/cloud_storage_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/views/home_page.dart';
import 'package:ags_ims/views/home_pages/stocks/item_details.dart';
import 'package:ags_ims/views/home_pages/stocks_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ItemViewModel {
  final _fireStoreDB = locator<FireStoreDBService>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _cloudStorage = locator<CloudStorageService>();
  final _notificationsViewModel = locator<HistoryViewModel>();

  Future<void> addItem({
    @required BuildContext context,
    @required String itemID,
    @required String itemName,
    @required Uint8List itemImage,
    @required Uint8List itemBarcodeImage,
    @required String itemCode,
    @required double itemPrice,
    @required int itemCount,
  }) async {
    _cloudStorage
        .setItemPhoto(itemID: itemID, imageFile: itemImage)
        .then((itemImage) async {
      _cloudStorage
          .setItemBarCodePhoto(itemID: itemID, imageFile: itemBarcodeImage)
          .then((itemBarcodeImage) async {
        ItemDetails itemDetails = ItemDetails(
          itemID: itemID,
          itemName: itemName,
          itemImage: await itemImage.getDownloadURL(),
          itemBarcodeImage: await itemBarcodeImage.getDownloadURL(),
          itemCode: itemCode,
          itemPrice: itemPrice,
          itemCount: itemCount,
          isOnHand: itemCount == 0 ? false : true,
          isActive: true,
          isDeleted: false,
          isTrashed: false,
        );
        _fireStoreDB.setStocksItem(itemDetails: itemDetails).whenComplete(() {
          _notificationsViewModel.newHistory(
            userID: _auth.getCurrentUserID(),
            historyType: HistoryTypes.addedItem,
            tag: itemName,
            tagID: itemID,
          );
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
    });
  }

  Future<void> updateItem({
    @required BuildContext context,
    @required String itemID,
    @required String itemName,
    Uint8List newItemImage,
    String itemImage,
    @required String itemBarcodeImage,
    @required String itemCode,
    @required double itemPrice,
    @required int itemCount,
  }) async {
    if(newItemImage != null){
      _cloudStorage
          .setItemPhoto(itemID: itemID, imageFile: newItemImage)
          .then((newItemImage) async {
        ItemDetails itemDetails = ItemDetails(
          itemID: itemID,
          itemName: itemName,
          itemImage: await newItemImage.getDownloadURL(),
          itemBarcodeImage: itemBarcodeImage,
          itemCode: itemCode,
          itemPrice: itemPrice,
          itemCount: itemCount,
          isOnHand: itemCount == 0 ? false : true,
          isActive: true,
          isDeleted: false,
          isTrashed: false,
        );
        _fireStoreDB.updateStocksItem(itemDetails: itemDetails).whenComplete(() {
          _notificationsViewModel.newHistory(
            userID: _auth.getCurrentUserID(),
            historyType: HistoryTypes.updatedItem,
            tag: itemName,
            tagID: itemID,
          );
          _baseUtils.snackBarNoProgress(
              context: context, content: 'Item Successfully Updated');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => HomePage(
                    title: 'Stocks',
                    currentPage: StocksPage(),
                  )));
        });
      });
    } else {
      ItemDetails itemDetails = ItemDetails(
        itemID: itemID,
        itemName: itemName,
        itemImage: itemImage,
        itemBarcodeImage: itemBarcodeImage,
        itemCode: itemCode,
        itemPrice: itemPrice,
        itemCount: itemCount,
        isOnHand: itemCount == 0 ? false : true,
        isActive: true,
        isDeleted: false,
        isTrashed: false,
      );
      _fireStoreDB.updateStocksItem(itemDetails: itemDetails).whenComplete(() {
        _notificationsViewModel.newHistory(
          userID: _auth.getCurrentUserID(),
          historyType: HistoryTypes.updatedItem,
          tag: itemName,
          tagID: itemID,
        );
        _baseUtils.snackBarNoProgress(
            context: context, content: 'Item Successfully Updated');
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                  title: 'Stocks',
                  currentPage: StocksPage(),
                )));
      });
    }
  }

  Future<void> updateItemCount({
    @required BuildContext context,
    @required String itemID,
    @required String itemName,
    String itemImage,
    @required String itemBarcodeImage,
    @required String itemCode,
    @required double itemPrice,
    @required int itemCount,
  }) async {
    ItemDetails itemDetails = ItemDetails(
      itemID: itemID,
      itemName: itemName,
      itemImage: itemImage,
      itemBarcodeImage: itemBarcodeImage,
      itemCode: itemCode,
      itemPrice: itemPrice,
      itemCount: itemCount,
      isOnHand: itemCount == 0 ? false : true,
      isActive: true,
      isDeleted: false,
      isTrashed: false,
    );
    _fireStoreDB.updateStocksItem(itemDetails: itemDetails).whenComplete(() {
      _notificationsViewModel.newHistory(
        userID: _auth.getCurrentUserID(),
        historyType: HistoryTypes.updatedItem,
        tag: itemName,
        tagID: itemID,
      );
    });
  }

  Future<void> deleteItem({
    @required BuildContext context,
    @required String itemID,
    @required String itemName,
    @required String itemImage,
    @required String itemBarcodeImage,
    @required String itemCode,
    @required double itemPrice,
    @required int itemCount,
  }) async {
    ItemDetails itemDetails = ItemDetails(
      itemID: itemID,
      itemName: itemName,
      itemImage: itemImage,
      itemBarcodeImage: itemBarcodeImage,
      itemCode: itemCode,
      itemPrice: itemPrice,
      itemCount: itemCount,
      isOnHand: false,
      isActive: false,
      isDeleted: false,
      isTrashed: true,
    );
    _fireStoreDB.updateStocksItem(itemDetails: itemDetails).whenComplete(() {
      _notificationsViewModel.newHistory(
        userID: _auth.getCurrentUserID(),
        historyType: HistoryTypes.deletedItem,
        tag: itemName,
        tagID: itemID,
      );
      _baseUtils.snackBarNoProgress(
          context: context, content: 'Item Successfully Updated');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                title: 'Stocks',
                currentPage: StocksPage(),
              )));
    });
  }
}
