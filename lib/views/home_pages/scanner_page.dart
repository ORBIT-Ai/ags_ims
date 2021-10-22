import 'package:flutter/material.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key key}) : super(key: key);
  final title = "Scanner";

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Scanner"),
    );
  }
}
