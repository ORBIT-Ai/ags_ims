import 'package:flutter/material.dart';

class ItemDetails {
  final String itemID;
  final String itemName;
  final String itemImage;
  final String itemBarcodeImage;
  final String itemCode;
  final int itemPrice;
  final int itemCount;
  final bool isOnHand;
  final bool isActive;
  final bool isDeleted;
  final bool isTrashed;

  ItemDetails({
    @required this.itemID,
    @required this.itemName,
    @required this.itemImage,
    @required this.itemBarcodeImage,
    @required this.itemCode,
    @required this.itemPrice,
    @required this.itemCount,
    @required this.isOnHand,
    @required this.isActive,
    @required this.isDeleted,
    @required this.isTrashed,
  });

  ItemDetails.fromJson(Map<String, dynamic> json)
      : this(
          itemID: json['itemID'] as String,
          itemName: json['itemName'] as String,
          itemImage: json['itemImage'] as String,
          itemBarcodeImage: json['itemBarcodeImage'] as String,
          itemCode: json['itemCode'] as String,
          itemPrice: json['itemPrice'] as int,
          itemCount: json['itemCount'] as int,
          isOnHand: json['isOnHand'] as bool,
          isActive: json['isActive'] as bool,
          isDeleted: json['isDeleted'] as bool,
          isTrashed: json['isTrashed'] as bool,
        );

  toJson() {
    return {
      'itemID': itemID,
      'itemName': itemName,
      'itemImage': itemImage,
      'itemBarcodeImage': itemBarcodeImage,
      'itemCode': itemCode,
      'itemPrice': itemPrice,
      'itemCount': itemCount,
      'isOnHand': isOnHand,
      'isActive': isActive,
      'isDeleted': isDeleted,
      'isTrashed': isTrashed,
    };
  }
}
