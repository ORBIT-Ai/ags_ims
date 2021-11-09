// ignore_for_file: avoid_print

import 'package:ags_ims/core/enums/notification_types.dart';
import 'package:ags_ims/core/models/notification.dart';
import 'package:ags_ims/core/models/notification_info.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/cloud_storage_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:flutter/foundation.dart';

class NotificationViewModel {
  final _fireStoreDB = locator<FireStoreDBService>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _cloudStorage = locator<CloudStorageService>();

  Future<void> newNotification(
      {@required String userID,
      @required NotificationTypes notificationType,
      String tag,
      String tagID}) async {
    final notificationID = _baseUtils.timeStamp();

    String date = _baseUtils.currentDate();
    String time = _baseUtils.currentTime();

    String description;
    String senderUserName, receiverUserName;

    await _fireStoreDB
        .getUserDetails(userID: userID)
        .then((senderUserDetails) async {
      senderUserName = senderUserDetails.userName;

      switch (notificationType) {
        case NotificationTypes.newUser:
          description = "$senderUserName signed up.";
          break;
        case NotificationTypes.deletedUser:
          description = "$senderUserName deleted his/her account.";
          break;
        case NotificationTypes.addedItem:
          description = "$senderUserName added the item $tag.";
          break;
        case NotificationTypes.updatedItem:
          description = "$senderUserName updated the item $tag.";
          break;
        case NotificationTypes.deletedItem:
          description = "$senderUserName deleted the item $tag.";
          break;
        case NotificationTypes.itemStockIn:
          description = "$senderUserName added stocks to the item $tag.";
          break;
        case NotificationTypes.itemStockOut:
          description = "$tag has been out of stock.";
          break;
        case NotificationTypes.exportedDailyReport:
          description = "$senderUserName exported a daily report.";
          break;
        case NotificationTypes.exportedWeeklyReport:
          description = "$senderUserName exported a weekly report.";
          break;
        case NotificationTypes.exportedMonthlyReport:
          description = "$senderUserName exported a monthly report.";
          break;
        case NotificationTypes.exportedAnnualReport:
          description = "$senderUserName exported an annual report.";
          break;
        default:
          //No Description
          break;
      }

      Notifications notification = Notifications(
        userID: userID,
        notificationInfo: NotificationInfo(
          notificationID: notificationID,
          description: description,
          date: date,
          time: time,
          type: notificationType.toString().split('.').last,
          tag: tag,
          tagID: tagID,
        ).toJson(),
      );

      _fireStoreDB.setNotification(notification: notification).whenComplete(() {
        print("NOTIFICATION SUCCESSFULLY SENT");
      });
    });
  }
}
