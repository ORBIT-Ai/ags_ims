// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print

import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/theme_styles.dart';
import 'package:ags_ims/views/splashscreen.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) {
    print('FIREBASE INITIALIZATION || APP ID:: ${value.options.appId}');
  });
  FirebaseAppCheck firebaseAppCheck = FirebaseAppCheck.instance;
  await firebaseAppCheck.activate(
      webRecaptchaSiteKey: '6LfFbacbAAAAAKJ2PIU8EEUtdz0vUwqUBEPRalMM');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yder',
      theme: Theme.of(context),
      home: MainPage(title: 'Yder'),
    );
  }
}

class MainPage extends StatefulWidget {
  MainPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MainPage> {

  @override
  void initState() {
    super.initState();
    setUpLocator();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Styles.themeData(
        context: context,
      ),
      home: SplashScreen(),
    );
  }
}