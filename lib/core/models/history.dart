
import 'package:flutter/material.dart';

class History{
  final String action;
  final String description;
  final String date;
  final String time;
  final String userID;

  History({
    @required this.action,
    @required this.description,
    @required this.date,
    @required this.time,
    @required this.userID,
  });

  History.fromJson(Map<String, dynamic> json)
      : this(
    action: json['action'] as String,
    description: json['description'] as String,
    date: json['date'] as String,
    time: json['time'] as String,
    userID: json['userID'] as String,
  );

  toJson() {
    return {
      'action': action,
      'description': description,
      'date': date,
      'time': time,
      'userID': userID,
    };
  }
}