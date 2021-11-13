import 'package:flutter/foundation.dart';

class ItemRecordsInfo {
  final String recordID;
  final String description;
  final String date;
  final String time;
  final String type;
  final String tag;
  final String tagID;

  ItemRecordsInfo({
    @required this.recordID,
    @required this.description,
    @required this.date,
    @required this.time,
    @required this.type,
    @required this.tag,
    @required this.tagID,
  });

  ItemRecordsInfo.fromJson(Map<String, dynamic> json)
      : this(
    recordID: json['recordID'] as String,
          description: json['description'] as String,
          date: json['date'] as String,
          time: json['time'] as String,
          type: json['type'] as String,
          tag: json['tag'] as String,
          tagID: json['tagID'] as String,
        );

  toJson() {
    return {
      'recordID': recordID,
      'description': description,
      'date': date,
      'time': time,
      'type': type,
      'tag': tag,
      'tagID': tagID,
    };
  }
}
