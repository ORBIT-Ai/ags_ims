
import 'package:flutter/foundation.dart';

class Images {
  final String imageID;
  final String userID;
  final String date;
  final String time;
  final String url;

  Images({
    @required this.imageID,
    @required this.userID,
    @required this.date,
    @required this.time,
    @required this.url,
  });

  Images.fromJson(Map<String, dynamic> json)
      : this(
    imageID: json['imageID'] as String,
    userID: json['userID'] as String,
    date: json['date'] as String,
    time: json['time'] as String,
    url: json['url'] as String,
  );

  toJson() {
    return {
      'imageID': imageID,
      'userID': userID,
      'date': date,
      'time': time,
      'url': url,
    };
  }
}