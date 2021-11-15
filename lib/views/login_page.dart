// ignore_for_file: unnecessary_new, prefer_const_constructors, sized_box_for_whitespace

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

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final _ui = locator<UI>();
  final _auth = locator<Auth>();
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

  Future<void> initializePrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _baseUtils.closeApp(context),
      child: Scaffold(
        body: Form(
          key: _loginFormKey,
          child: ResponsiveBuilder(builder: (context, sizingInformation) {
            isDesktop =
                sizingInformation.deviceScreenType == DeviceScreenType.desktop;
            isMobile =
                sizingInformation.deviceScreenType == DeviceScreenType.mobile;
            isTablet =
                sizingInformation.deviceScreenType == DeviceScreenType.tablet;
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
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
              ),
            );
          }),
        ),
      ),
    );
  }

  List<Widget> mainContent({BuildContext context}) {
    return [
      Container(
        width: isDesktop
            ? MediaQuery.of(context).size.width / 2
            : MediaQuery.of(context).size.width,
        color:
            isDesktop || isTablet ? Theme.of(context).primaryColorLight : null,
        padding: EdgeInsets.all(0),
        height: isDesktop
            ? MediaQuery.of(context).size.height
            : isMobile || isTablet
                ? 330
                : null,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Image.asset(
            "assets/images/login_vector.png",
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(
        width: isDesktop ? 50 : 0,
        height: isDesktop ? 0 : 0,
      ),
      Container(
        width: isDesktop
            ? MediaQuery.of(context).size.width / 2.5
            : MediaQuery.of(context).size.width,
        height: isDesktop ? MediaQuery.of(context).size.height : null,
        padding: EdgeInsets.only(
            left: 40, right: 40, top: 0, bottom: isDesktop ? 0 : 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.start,
          children: [
            _ui.headlineLarge(
                context: context,
                content: "Login",
                color: Theme.of(context).primaryColor,
                isDesktop: isDesktop),
            SizedBox(
              height: 15,
            ),
            _ui.subheadMedium(
                context: context,
                content:
                    "Access the stocks, sales and print reports by logging your account.",
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
            isMobile
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: controlsButtons(context),
                  )
                : Container(
                    width: isDesktop
                        ? MediaQuery.of(context).size.width / 3.0
                        : MediaQuery.of(context).size.width,
                    height: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: controlsButtons(context),
                    ),
                  ),
          ],
        ),
      ),
    ];
  }

  List<Widget> controlsButtons(BuildContext context) {
    return [
      Expanded(
        child: _ui.elevatedButtonIcon(
            context: context,
            label: 'Login',
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).canvasColor,
            icon: Icons.login_outlined,
            function: () {
              if (_loginFormKey.currentState.validate()) {
                _auth
                    .signInEmailPassword(context, _loginFormKey,
                        emailInputController, pwdInputController)
                    .whenComplete(() => {
                          setState(() {
                            signingIn = true;
                          })
                        });
                _baseUtils.snackBarProgress(
                    context: context, content: "Logging In");
              } else {
                _baseUtils.snackBarError(
                    context: context, content: "Enter valid credentials");
              }
            }),
      ),
      SizedBox(
        width: 20,
        height: 20,
      ),
      Expanded(
        child: _ui.outlinedButtonIcon(
            context: context,
            label: 'Sign Up',
            backgroundColor: Theme.of(context).canvasColor,
            foregroundColor: Theme.of(context).primaryColor,
            icon: Icons.person_add_outlined,
            function: () {
              signUp(context);
            }),
      ),
    ];
  }

  void signUp(BuildContext context) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }
}
