// ignore_for_file: unnecessary_new, prefer_const_constructors, avoid_print

import 'dart:html';
import 'dart:typed_data';

import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:ags_ims/views/login_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:intl/intl.dart';
import 'package:photofilters/filters/preset_filters.dart';
import 'package:photofilters/widgets/photo_filter.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;
import 'package:image/image.dart' as imageLib;

class BaseUtils {
  final _auth = locator<Auth>();

  final _ui = locator<UI>();

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String passwordValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  Future<bool> onBackPressed(
      {BuildContext context,
      StatefulWidget statefulWidget,
      String title,
      String content}) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  "No",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.yellow[900]),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> cancelRegistration({@required BuildContext context}) {
    return showDialog(
          context: context,
          builder: (alertContext) => new AlertDialog(
            title: Text('Cancel Registration'),
            content: Text(
                'Do you want to cancel the registration? Any information you have entered fill be deleted.'),
            actions: <Widget>[
              TextButton(
                child: Text(
                  "No",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              SizedBox(height: 16),
              TextButton(
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.yellow[900]),
                ),
                onPressed: () {
                  Navigator.of(alertContext).pop(false);
                  _auth.getCurrentUserID() != null
                      ? UserProfileViewModel().deleteUserData(
                          context: context, userID: _auth.getCurrentUserID())
                      : Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                },
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> closeApp(BuildContext context) {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: Text('Exit'),
            content: Text('Are you sure you want to exit?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  "No",
                  style: TextStyle(color: Colors.blueAccent[400]),
                ),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () =>
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                child: Text(
                  "Yes",
                  style: TextStyle(color: Colors.yellow[900]),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  errorDialog(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: <Widget>[
              _ui.textButtonIcon(
                context: context,
                label: "Close",
                backgroundColor: Theme.of(context).canvasColor,
                foregroundColor: Theme.of(context).primaryColor,
                icon: Icons.close_rounded,
                function: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  initializeSystemOverlays({@required BuildContext context}) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Theme.of(context).primaryColorDark, // n
      systemNavigationBarIconBrightness:
          Brightness.light, // avigation bar color
      statusBarColor: Colors.black.withAlpha(50), //
      statusBarIconBrightness: Brightness.light, // status// bar color
    ));
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    //SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }

  Future<File> imageProcessor(
      {@required BuildContext context,
      @required double ratioY,
      @required double ratioX}) async {
    final ImagePicker _picker = ImagePicker();

    File imageFile = await ImagePickerWeb.getImageAsFile();

    return imageFile;
  }

  /*
  Future<html.File> imageProcessorWeb(
      {@required BuildContext context,
        @required double ratioY,
        @required double ratioX}) async {

    //imageFile = File(pickedMedia.path);
    html.File imageFile =
    await ImagePickerWeb.getImage(outputType: ImageType.file);

    if (imageFile != null) {
      debugPrint(imageFile.name.toString());
    }

    return imageFile;
  }
   */

  bool isPortrait(BuildContext context) {
    bool portrait;
    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      portrait = true;
    } else {
      portrait = false;
    }
    return portrait;
  }

  String currentDate() {
    var currentDate = DateTime.now();
    var formattedDate = new DateFormat('MMMM dd, yyyy');

    String date = formattedDate.format(currentDate).toString();
    return date;
  }

  String currentTime() {
    var currentTime = DateTime.now();
    var formattedTime = new DateFormat('hh:mm a');
    String time = formattedTime.format(currentTime).toString();
    return time;
  }

  List<int> currentWeek(){
    DateTime now = DateTime.now();
    List<int> weekDays = [];
    for(int i=0; i <= 6 ; i++){
      int start = now.subtract(Duration(days: 6)).day;
      weekDays.add(start + i);
      //print("WEEKLY ${start + i}");
    }
    return weekDays;
  }

  String currentMonth(){
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);

    String month = now.month.toString();
    return month;
  }

  int currentDay(){
    DateTime now = DateTime.now();

    int day = now.day;
    return day;
  }

  int currentYear(){
    DateTime now = DateTime.now();

    int year = now.year;
    return year;
  }

  String timeStamp() {
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    return timestamp;
  }

  void snackBarProgress(
      {@required BuildContext context, @required String content}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: SizedBox(
        height: 36,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SpinKitFadingCube(
              color: Theme.of(context).primaryColorLight,
              size: 18.0,
            ),
            SizedBox(
              width: 15,
            ),
            Text(
              content,
              style: TextStyle(color: Theme.of(context).primaryColorLight),
            )
          ],
        ),
      ),
      //duration: Duration(seconds: 30),
      backgroundColor: Theme.of(context).primaryColor,
    ));
  }

  void snackBarNoProgress(
      {@required BuildContext context, @required String content}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: SizedBox(
        height: 36,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              content,
              style: TextStyle(color: Theme.of(context).primaryColorLight),
            )
          ],
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
    ));
  }

  void snackBarError(
      {@required BuildContext context, @required String content}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: SizedBox(
        height: 36,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              content,
              style: TextStyle(color: Theme.of(context).colorScheme.onError),
            )
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
    ));
  }

}
