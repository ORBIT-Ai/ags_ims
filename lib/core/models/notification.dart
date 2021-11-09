import 'package:flutter/foundation.dart';

class Notifications {
  final String userID;
  final Map<String, dynamic> notificationInfo;

  Notifications({@required this.userID, @required this.notificationInfo});

  Notifications.fromJson(Map<String, dynamic> json)
      : this(
          userID: json['userID'] as String,
          notificationInfo: json['notificationInfo'] as Map<String, dynamic>,
        );

  toJson() {
    return {
      'userID': userID,
      'notificationInfo': notificationInfo,
    };
  }
}
