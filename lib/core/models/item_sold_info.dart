import 'package:flutter/foundation.dart';

class ItemSoldInfo {
  final String soldID;
  final String description;
  final Map<String, dynamic> date;
  final String type;
  final String itemName;
  final int itemCount;
  final int itemPrice;
  final int itemTotalAmount;

  ItemSoldInfo({
    @required this.soldID,
    @required this.description,
    @required this.date,
    @required this.type,
    @required this.itemName,
    @required this.itemCount,
    @required this.itemPrice,
    @required this.itemTotalAmount,
  });

  ItemSoldInfo.fromJson(Map<String, dynamic> json)
      : this(
          soldID: json['soldID'] as String,
          description: json['description'] as String,
          date: json['date'] as Map<String, dynamic>,
          type: json['type'] as String,
          itemName: json['itemName'] as String,
          itemCount: json['itemCount'] as int,
          itemPrice: json['itemPrice'] as int,
          itemTotalAmount: json['itemTotalAmount'] as int,
        );

  toJson() {
    return {
      'soldID': soldID,
      'description': description,
      'date': date,
      'type': type,
      'itemName': itemName,
      'itemCount': itemCount,
      'itemPrice': itemPrice,
      'itemTotalAmount': itemTotalAmount,
    };
  }
}
