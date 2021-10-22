import 'package:flutter/material.dart';

class StocksPage extends StatefulWidget {
  const StocksPage({Key key}) : super(key: key);
  final title = "Stocks";

  @override
  _StocksPageState createState() => _StocksPageState();
}

class _StocksPageState extends State<StocksPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Stocks"),
    );
  }
}
