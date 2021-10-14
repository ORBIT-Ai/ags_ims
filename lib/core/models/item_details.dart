
import 'package:flutter/material.dart';

class ItemDetails{

  final String itemID;
  final String itemName;
  final String itemPrice;
  final String itemImage;
  final String itemCode;
  final bool isOnHand;
  final int itemCount;

  ItemDetails({
    @required this.itemID,
    @required this.itemName,
    @required this.itemPrice,
    @required this.itemImage,
    @required this.itemCode,
    @required this.isOnHand,
    @required this.itemCount,
  });

  ItemDetails.fromJson(Map<String, dynamic> json)
      : this(
    itemID: json['itemID'] as String,
    itemName: json['itemName'] as String,
    itemPrice: json['itemPrice'] as String,
    itemImage: json['itemImage'] as String,
    itemCode: json['itemCode'] as String,
    isOnHand: json['isOnHand'] as bool,
    itemCount: json['itemCount'] as int,
  );

  toJson() {
    return {
      'itemID': itemID,
      'itemName': itemName,
      'itemPrice': itemPrice,
      'itemImage': itemImage,
      'itemCode': itemCode,
      'isOnHand': isOnHand,
      'itemCount': itemCount,
    };
  }
}