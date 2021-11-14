import 'package:flutter/foundation.dart';

class ItemSoldInfo {
  final String recordID;
  final String description;
  final String date;
  final String time;
  final String type;
  final String itemName;
  final int itemCount;
  final int itemPrice;
  final int itemTotalAmount;

  ItemSoldInfo({
    @required this.recordID,
    @required this.description,
    @required this.date,
    @required this.time,
    @required this.type,
    @required this.itemName,
    @required this.itemCount,
    @required this.itemPrice,
    @required this.itemTotalAmount,
  });

  ItemSoldInfo.fromJson(Map<String, dynamic> json)
      : this(
          recordID: json['recordID'] as String,
          description: json['description'] as String,
          date: json['date'] as String,
          time: json['time'] as String,
          type: json['type'] as String,
          itemName: json['itemName'] as String,
          itemCount: json['itemCount'] as int,
          itemPrice: json['itemPrice'] as int,
          itemTotalAmount: json['itemTotalAmount'] as int,
        );

  toJson() {
    return {
      'recordID': recordID,
      'description': description,
      'date': date,
      'time': time,
      'type': type,
      'itemName': itemName,
      'itemCount': itemCount,
      'itemPrice': itemPrice,
      'itemTotalAmount': itemTotalAmount,
    };
  }
}
