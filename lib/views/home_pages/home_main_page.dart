import 'package:flutter/material.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({Key key}) : super(key: key);
  final title = "Home";

  @override
  _HomeMainPageState createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Home"),
    );
  }
}
