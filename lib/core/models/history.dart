import 'package:flutter/foundation.dart';

class History {
  final String userID;
  final Map<String, dynamic> historyInfo;

  History({@required this.userID, @required this.historyInfo});

  History.fromJson(Map<String, dynamic> json)
      : this(
          userID: json['userID'] as String,
          historyInfo: json['historyInfo'] as Map<String, dynamic>,
        );

  toJson() {
    return {
      'userID': userID,
      'historyInfo': historyInfo,
    };
  }
}
