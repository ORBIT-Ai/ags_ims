
import 'package:flutter/material.dart';

class StockIn{
  final String stockID;
  final String dateOut;
  final String timeOut;
  final String userID;
  final Map<String, dynamic> itemDetails;

  StockIn({
    @required this.stockID,
    @required this.dateOut,
    @required this.timeOut,
    @required this.userID,
    @required this.itemDetails,
  });

  StockIn.fromJson(Map<String, dynamic> json)
      : this(
    stockID: json['stockID'] as String,
    dateOut: json['dateOut'] as String,
    timeOut: json['timeOut'] as String,
    userID: json['userID'] as String,
    itemDetails: json['itemDetails'] as Map<String, dynamic>,
  );

  toJson() {
    return {
      'stockID': stockID,
      'dateOut': dateOut,
      'timeOut': timeOut,
      'userID': userID,
      'itemDetails': itemDetails,
    };
  }
}