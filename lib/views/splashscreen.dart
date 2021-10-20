// ignore_for_file: prefer_const_constructors

import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _ui = locator<UI>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(100),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/ags_logo.png',
              width: 125,
              height: 125,
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
            LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
