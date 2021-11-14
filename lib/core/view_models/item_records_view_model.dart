// ignore_for_file: avoid_print

import 'package:ags_ims/core/enums/history_types.dart';
import 'package:ags_ims/core/enums/record_types.dart';
import 'package:ags_ims/core/models/history.dart';
import 'package:ags_ims/core/models/history_info.dart';
import 'package:ags_ims/core/models/item_records.dart';
import 'package:ags_ims/core/models/item_records_info.dart';
import 'package:ags_ims/core/models/item_sold.dart';
import 'package:ags_ims/core/models/item_sold_info.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/cloud_storage_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:flutter/foundation.dart';

class ItemRecordsViewModel {
  final _fireStoreDB = locator<FireStoreDBService>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _cloudStorage = locator<CloudStorageService>();

  Future<void> newRecord(
      {@required String userID,
      @required RecordTypes recordsType,
      @required String itemID,
      int itemCount,
      int totalItemCount,
      String itemName,
      int itemPrice}) async {
    final recordID = _baseUtils.timeStamp();

    String date = _baseUtils.currentDate();
    String time = _baseUtils.currentTime();

    String description;
    String senderUserName, receiverUserName;

    await _fireStoreDB
        .getUserDetails(userID: userID)
        .then((senderUserDetails) async {
      senderUserName = senderUserDetails.userName;

      switch (recordsType) {
        case RecordTypes.details:
          description = "$senderUserName updated $itemName.";
          break;
        case RecordTypes.stockOut:
          description =
              "$itemName was reduced by $itemCount and has been out of stock.";
          break;
        case RecordTypes.reStock:
          description =
              "$senderUserName added $itemCount stocks to $itemName, $totalItemCount stocks remaining.";
          break;
        case RecordTypes.sold:
          description =
              "$senderUserName sold $itemCount stocks from $itemName, $totalItemCount stocks remaining.";
          break;
        default:
          //No Description
          break;
      }

      ItemRecords itemRecords = ItemRecords(
        userID: userID,
        itemID: itemID,
        itemRecordsInfo: ItemRecordsInfo(
          recordID: recordID,
          description: description,
          date: date,
          time: time,
          type: recordsType.toString().split('.').last,
          itemName: itemName,
          itemCount: itemCount,
          itemPrice: itemPrice,
        ).toJson(),
      );

      recordsType == RecordTypes.details
          ? _fireStoreDB
              .setItemDetailsRecords(itemRecords: itemRecords)
              .whenComplete(() {
              print("RECORDS SUCCESSFULLY ADDED");
            })
          : recordsType == RecordTypes.stockOut
              ? _fireStoreDB
                  .setItemStockOutRecords(itemRecords: itemRecords)
                  .whenComplete(() {
                  print("RECORDS SUCCESSFULLY ADDED");
                })
              : recordsType == RecordTypes.reStock
                  ? _fireStoreDB
                      .setItemReStockRecords(itemRecords: itemRecords)
                      .whenComplete(() {
                      print("RECORDS SUCCESSFULLY ADDED");
                    })
                  : _fireStoreDB
                      .setItemSoldRecords(itemRecords: itemRecords)
                      .whenComplete(() {
                      print("RECORDS SUCCESSFULLY ADDED");
                    });
    });
  }

  Future<void> soldItem(
      {@required String userID,
      @required RecordTypes recordsType,
      @required String itemID,
      int itemCount,
      int totalItemCount,
      String itemName,
      int itemPrice,
      int totalAmount}) async {
    final recordID = _baseUtils.timeStamp();

    String date = _baseUtils.currentDate();
    String time = _baseUtils.currentTime();

    String description;
    String senderUserName, receiverUserName;

    await _fireStoreDB
        .getUserDetails(userID: userID)
        .then((senderUserDetails) async {
      senderUserName = senderUserDetails.userName;

      ItemSold itemSold = ItemSold(
        userID: userID,
        itemID: itemID,
        itemRecordsInfo: ItemSoldInfo(
          recordID: recordID,
          description: description,
          date: date,
          time: time,
          type: recordsType.toString().split('.').last,
          itemName: itemName,
          itemCount: itemCount,
          itemPrice: itemPrice,
          itemTotalAmount: totalAmount,
        ).toJson(),
      );

      _fireStoreDB.setItemSold(itemSold: itemSold).whenComplete(() {
        print("RECORDS SUCCESSFULLY ADDED");
      });
    });
  }
}
