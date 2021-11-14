
import 'package:flutter/foundation.dart';

class ItemRecords{
  final String userID;
  final String itemID;
  final Map<String, dynamic> itemRecordsInfo;

  ItemRecords({@required this.userID, @required this.itemID, @required this.itemRecordsInfo});

  ItemRecords.fromJson(Map<String, dynamic> json)
      : this(
    userID: json['userID'] as String,
    itemID: json['itemID'] as String,
    itemRecordsInfo: json['itemRecordsInfo'] as Map<String, dynamic>,
  );

  toJson() {
    return {
      'userID': userID,
      'itemID': itemID,
      'itemRecordsInfo': itemRecordsInfo,
    };
  }
}