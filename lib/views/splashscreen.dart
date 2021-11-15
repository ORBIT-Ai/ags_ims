// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'dart:async';

import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:ags_ims/views/home_page.dart';
import 'package:ags_ims/views/login_page.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _ui = locator<UI>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(100),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/ags_logo.png',
              width: kIsWeb ? 200 : 125,
              height: kIsWeb ? 200 : 125,
            ),
            SizedBox(
              width: 20,
              height: 20,
            ),
            _ui.headlineMedium(
                context: context,
                content: "AGS IMS",
                color: null,
                isDesktop: false),
            SizedBox(
              width: 20,
              height: 70,
            ),
            Container(
              width: kIsWeb
                  ? MediaQuery.of(context).size.width / 4.0
                  : MediaQuery.of(context).size.width,
              height: kIsWeb ? 6 : 4,
              child: LinearProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  Future<Timer> startTime() async {
    var duration = new Duration(seconds: 5);
    return new Timer(duration, route);
  }

  void route() async {
    final userID = await _auth.getCurrentUserID();
    if (_auth.getCurrentUser() == null || userID == null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    }
  }
}
