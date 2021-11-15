
import 'package:flutter/foundation.dart';

class Date{
  final String time;
  final String month;
  final int day;
  final int year;

  Date({
    @required this.time,
    @required this.month,
    @required this.day,
    @required this.year,
  });

  Date.fromJson(Map<String, dynamic> json)
      : this(
    time: json['time'] as String,
    month: json['month'] as String,
    day: json['day'] as int,
    year: json['year'] as int,
  );

  toJson() {
    return {
      'time': time,
      'month': month,
      'day': day,
      'year': year,
    };
  }
}