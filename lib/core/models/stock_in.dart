
import 'package:flutter/material.dart';

class StockIn{
  final String stockID;
  final String dateAdded;
  final String timeAdded;
  final String userID;
  final Map<String, dynamic> itemDetails;

  StockIn({
    @required this.stockID,
    @required this.dateAdded,
    @required this.timeAdded,
    @required this.userID,
    @required this.itemDetails,
  });

  StockIn.fromJson(Map<String, dynamic> json)
      : this(
    stockID: json['stockID'] as String,
    dateAdded: json['dateAdded'] as String,
    timeAdded: json['timeAdded'] as String,
    userID: json['userID'] as String,
    itemDetails: json['itemDetails'] as Map<String, dynamic>,
  );

  toJson() {
    return {
      'stockID': stockID,
      'dateAdded': dateAdded,
      'timeAdded': timeAdded,
      'userID': userID,
      'itemDetails': itemDetails,
    };
  }
}