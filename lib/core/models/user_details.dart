
import 'package:flutter/material.dart';

class UserDetails {
  final String userID;
  final String emailAddress;
  final String profileUrl;
  final String userName;
  final String position;
  final String idNumber;
  final String phoneNumber;

  UserDetails({
    @required this.userID,
    @required this.emailAddress,
    @required this.profileUrl,
    @required this.userName,
    @required this.position,
    @required this.idNumber,
    @required this.phoneNumber,
  });

  UserDetails.fromJson(Map<String, dynamic> json)
      : this(
    userID: json['userID'] as String,
    emailAddress: json['emailAddress'] as String,
    profileUrl: json['profileUrl'] as String,
    userName: json['userName'] as String,
    position: json['position'] as String,
    idNumber: json['idNumber'] as String,
    phoneNumber: json['phoneNumber'] as String,
  );

  toJson() {
    return {
      'userID': userID,
      'emailAddress': emailAddress,
      'profileUrl': profileUrl,
      'userName': userName,
      'position': position,
      'idNumber': idNumber,
      'phoneNumber': phoneNumber,
    };
  }
}