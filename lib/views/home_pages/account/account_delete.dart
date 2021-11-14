// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:ags_ims/views/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountDelete extends StatefulWidget {
  final String title = "Account Delete";

  const AccountDelete({Key key}) : super(key: key);

  @override
  _AccountDeleteState createState() => _AccountDeleteState();
}

class _AccountDeleteState extends State<AccountDelete> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final _ui = locator<UI>();
  final _auth = locator<Auth>();
  final _userProfile = locator<UserProfileViewModel>();
  final _baseUtils = locator<BaseUtils>();
  final _fireStoreDB = locator<FireStoreDBService>();

  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  bool signingIn = false;

  bool isDesktop;
  bool isMobile;
  bool isTablet;

  bool _obscurePassword = true;

  @override
  initState() {
    //initializePrefs();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  void _togglePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _loginFormKey,
        child: ResponsiveBuilder(builder: (context, sizingInformation) {
          isDesktop =
              sizingInformation.deviceScreenType == DeviceScreenType.desktop;
          isMobile =
              sizingInformation.deviceScreenType == DeviceScreenType.mobile;
          isTablet =
              sizingInformation.deviceScreenType == DeviceScreenType.tablet;
          return SingleChildScrollView(
              child: Container(
            width: MediaQuery.of(context).size.width,
            height: isDesktop ? MediaQuery.of(context).size.height : null,
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: mainContent(context: context),
                  )
                : isMobile || isTablet
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: mainContent(context: context),
                      )
                    : UI().deviceNotSupported(
                        context: context,
                        isDesktop: isDesktop,
                        content: "Device Not Supported"),
          ));
        }),
      ),
    );
  }

  List<Widget> mainContent({@required BuildContext context}) {
    return [
      SizedBox(
        width: isDesktop ? 50 : 0,
        height: isDesktop ? 0 : 50,
      ),
      Container(
        width: isDesktop
            ? MediaQuery.of(context).size.width / 3.0
            : MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(
            left: 40, right: 40, top: 0, bottom: isDesktop ? 0 : 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.start,
          children: [
            _ui.headlineLarge(
                context: context,
                content: "Verify",
                color: Theme.of(context).primaryColor,
                isDesktop: isDesktop),
            SizedBox(
              height: 15,
            ),
            _ui.subheadMedium(
                context: context,
                content:
                    "Verify it's you by filling up your email address and password.",
                color: Colors.grey,
                isDesktop: isDesktop),
            SizedBox(
              height: 15,
            ),
            _ui.textFormField(
                context: context,
                controller: emailInputController,
                keyboardType: TextInputType.emailAddress,
                label: "Email Address",
                icon: Icons.email_rounded,
                color: null),
            SizedBox(
              height: 20,
            ),
            _ui.textFormFieldPassword(
              context: context,
              controller: pwdInputController,
              keyboardType: TextInputType.emailAddress,
              label: "Password",
              icon: Icons.dialpad,
              suffixIcon: Icons.remove_red_eye,
              color: null,
              function: _togglePassword,
              obscureText: _obscurePassword,
            ),
            SizedBox(
              height: 50,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: controlsButtons(context),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ui.textIcon(
                  context: context,
                  content:
                  "Action can't be reverted once\nyou clicked 'Delete Account' button.",
                  iconColor: Colors.amber[800],
                  contentColor: Colors.amber[800],
                  icon: Icons.info_rounded,
                  ratio: "small",
                  isDesktop: isDesktop,
                ),
              ],
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> controlsButtons(BuildContext context) {
    return [
      _ui.elevatedButtonIcon(
          context: context,
          label: 'Delete Account',
          backgroundColor: Theme.of(context).colorScheme.secondaryVariant,
          foregroundColor: Theme.of(context).canvasColor,
          icon: Icons.warning_amber_rounded,
          function: () {
            if (_loginFormKey.currentState.validate()) {
              _userProfile.deleteUserData(
                context: context,
                userID: _auth.getCurrentUserID(),
                email: emailInputController.text,
                password: pwdInputController.text,
              );
              _baseUtils.snackBarProgress(
                  context: context, content: "Deleting Account");
            } else {
              _baseUtils.snackBarError(
                  context: context, content: "Enter valid credentials");
            }
          }),
    ];
  }
}
