
import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _homeFormKey = GlobalKey<FormState>();
  final _ui = locator<UI>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _fireStoreDB = locator<FireStoreDBService>();
  final _userProfile = locator<UserProfileViewModel>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _baseUtils.closeApp(context),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text("Home"),
        ),
        body: Container(),
      ),
    );
  }
}
