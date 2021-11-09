import 'package:flutter/foundation.dart';

class NotificationInfo {
  final String notificationID;
  final String description;
  final String date;
  final String time;
  final String type;
  final String tag;
  final String tagID;

  NotificationInfo({
    @required this.notificationID,
    @required this.description,
    @required this.date,
    @required this.time,
    @required this.type,
    @required this.tag,
    @required this.tagID,
  });

  NotificationInfo.fromJson(Map<String, dynamic> json)
      : this(
          notificationID: json['notificationID'] as String,
          description: json['description'] as String,
          date: json['date'] as String,
          time: json['time'] as String,
          type: json['type'] as String,
          tag: json['tag'] as String,
          tagID: json['tagID'] as String,
        );

  toJson() {
    return {
      'notificationID': notificationID,
      'description': description,
      'date': date,
      'time': time,
      'type': type,
      'tag': tag,
      'tagID': tagID,
    };
  }
}
