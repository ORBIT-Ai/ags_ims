
import 'package:flutter/material.dart';

class EmployeeID{
  final String employeeID;

  EmployeeID({
    @required this.employeeID,
  });

  EmployeeID.fromJson(Map<String, dynamic> json)
      : this(
    employeeID: json['employeeID'] as String,
  );

  toJson() {
    return {
      'employeeID': employeeID,
    };
  }
}