// ignore_for_file: avoid_print

import 'package:ags_ims/core/enums/history_types.dart';
import 'package:ags_ims/core/models/history.dart';
import 'package:ags_ims/core/models/history_info.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/cloud_storage_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:flutter/foundation.dart';

class HistoryViewModel {
  final _fireStoreDB = locator<FireStoreDBService>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _cloudStorage = locator<CloudStorageService>();

  Future<void> newHistory(
      {@required String userID,
      @required HistoryTypes historyType,
      String tag,
      String tagID}) async {
    final historyID = _baseUtils.timeStamp();

    String date = _baseUtils.currentDate();
    String time = _baseUtils.currentTime();

    String description;
    String senderUserName, receiverUserName;

    await _fireStoreDB
        .getUserDetails(userID: userID)
        .then((senderUserDetails) async {
      senderUserName = senderUserDetails.userName;

      switch (historyType) {
        case HistoryTypes.newUser:
          description = "$senderUserName signed up.";
          break;
        case HistoryTypes.deletedUser:
          description = "$senderUserName deleted his/her account.";
          break;
        case HistoryTypes.addedItem:
          description = "$senderUserName added the item $tag.";
          break;
        case HistoryTypes.updatedItem:
          description = "$senderUserName updated the item $tag.";
          break;
        case HistoryTypes.deletedItem:
          description = "$senderUserName deleted the item $tag.";
          break;
        case HistoryTypes.itemStockIn:
          description = "$senderUserName added stocks to the item $tag.";
          break;
        case HistoryTypes.itemStockOut:
          description = "$tag has been out of stock.";
          break;
        case HistoryTypes.exportedDailyReport:
          description = "$senderUserName exported a daily report.";
          break;
        case HistoryTypes.exportedWeeklyReport:
          description = "$senderUserName exported a weekly report.";
          break;
        case HistoryTypes.exportedMonthlyReport:
          description = "$senderUserName exported a monthly report.";
          break;
        case HistoryTypes.exportedAnnualReport:
          description = "$senderUserName exported an annual report.";
          break;
        default:
          //No Description
          break;
      }

      History history = History(
        userID: userID,
        historyInfo: HistoryInfo(
          historyID: historyID,
          description: description,
          date: date,
          time: time,
          type: historyType.toString().split('.').last,
          tag: tag,
          tagID: tagID,
        ).toJson(),
      );

      _fireStoreDB.setHistory(history: history).whenComplete(() {
        print("NOTIFICATION SUCCESSFULLY SENT");
      });
    });
  }
}
