// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({Key key}) : super(key: key);
  final title = "Sales";

  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Sales"),
    );
  }
}
