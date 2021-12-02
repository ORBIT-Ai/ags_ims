// ignore_for_file: unnecessary_new, sized_box_for_whitespace, prefer_const_constructors, avoid_print

import 'dart:io';

import 'package:ags_ims/core/view_models/employee_id_view_model.dart';
import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  final _ui = locator<UI>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _fireStoreDB = locator<FireStoreDBService>();
  final _userProfile = locator<UserProfileViewModel>();
  final _employeeIDViewModel = locator<EmployeeIDViewModel>();

  TextEditingController emailInputController;
  TextEditingController fullNameInputController;
  TextEditingController positionInputController;
  TextEditingController phoneNumberInputController;
  TextEditingController idNumberInputController;
  TextEditingController pwdInputController;
  TextEditingController pwdConfInputController;

  bool signingUp = false;

  bool isDesktop;
  bool isMobile;
  bool isTablet;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  File imageFile;
  ImageCache imageCache = new ImageCache();

  @override
  initState() {
    //initializePrefs();
    emailInputController = new TextEditingController();
    fullNameInputController = new TextEditingController();
    positionInputController = new TextEditingController();
    phoneNumberInputController = new TextEditingController();
    idNumberInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    pwdConfInputController = new TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    imageFile = null;
    imageCache.clear();
  }

  void _togglePassword() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPassword() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  Future<void> initializePrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.clear();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _baseUtils.cancelRegistration(context: context),
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar:
            true, //this ensures that the body is drawn behind the navigation bar as well
        body: Form(
          key: _signUpFormKey,
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
            "assets/images/register_vector.png",
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
        padding: EdgeInsets.only(
            left: 40, right: 40, top: 0, bottom: isDesktop ? 0 : 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:
              isDesktop ? CrossAxisAlignment.start : CrossAxisAlignment.start,
          children: [
            _ui.headlineLarge(
                context: context,
                content: "Registration",
                color: Theme.of(context).primaryColor,
                isDesktop: isDesktop),
            SizedBox(
              height: 15,
            ),
            _ui.subheadMedium(
                context: context,
                content:
                    "Create an account to access the stocks, sales and print reports.",
                color: Colors.grey,
                isDesktop: isDesktop),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _ui.textFormField(
                      context: context,
                      controller: emailInputController,
                      keyboardType: TextInputType.emailAddress,
                      label: "Email Address",
                      icon: Icons.email_rounded,
                      color: null,
                      autoFocus: true),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: _ui.textFormField(
                      context: context,
                      controller: fullNameInputController,
                      keyboardType: TextInputType.name,
                      label: "Full Name",
                      icon: Icons.person_rounded,
                      color: null),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _ui.textFormField(
                      context: context,
                      controller: positionInputController,
                      keyboardType: TextInputType.text,
                      label: "Position",
                      icon: Icons.business_center_rounded,
                      color: null),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: _ui.textFormField(
                    context: context,
                    controller: phoneNumberInputController,
                    keyboardType: TextInputType.phone,
                    label: "Phone Number",
                    icon: Icons.phone_rounded,
                    color: null,
                    maxLength: 11,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 0,
            ),
            _ui.textFormField(
                context: context,
                controller: idNumberInputController,
                keyboardType: TextInputType.text,
                label: "ID Number",
                icon: Icons.person_pin_rounded,
                color: null),
            SizedBox(
              height: 15,
            ),
            imageFile != null
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            child: Container(
                              width: 48,
                              height: 48,
                              child: CircleAvatar(
                                backgroundColor:
                                    Theme.of(context).primaryColorLight,
                                child: ClipOval(
                                  child: imageFile == null
                                      ? Container(
                                          height: 48,
                                          width: 48,
                                          child: Icon(
                                            Icons.person,
                                            size: 18,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                        )
                                      : Image.file(
                                          imageFile,
                                          height: 48,
                                          width: 48,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                radius: 100,
                              ),
                            ),
                          ),
                          signingUp
                              ? Positioned(
                                  left: 5,
                                  right: 5,
                                  top: 5,
                                  bottom: 5,
                                  child: CircularProgressIndicator(
                                    color: Theme.of(context).primaryColorLight,
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                          child: _ui.outlinedButtonIcon(
                        context: context,
                        label:
                            imageFile != null ? "Change Image" : "Add Profile",
                        backgroundColor:
                            Theme.of(context).colorScheme.background,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        icon: Icons.photo_rounded,
                        function: () async {
                          imageFile = await _baseUtils.imageProcessor(
                              context: context, ratioY: 4, ratioX: 4);
                          setState(() {
                            _baseUtils.snackBarNoProgress(
                                context: context, content: "Image Loaded");
                          });
                        },
                      ))
                    ],
                  )
                : Container(),
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
              height: 15,
            ),
            _ui.textFormFieldPassword(
              context: context,
              controller: pwdConfInputController,
              keyboardType: TextInputType.emailAddress,
              label: "Confirm Password",
              icon: Icons.dialpad,
              suffixIcon: Icons.remove_red_eye,
              color: null,
              function: _toggleConfirmPassword,
              obscureText: _obscureConfirmPassword,
            ),
            SizedBox(
              height: 20,
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
                    height: 50,
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
      !signingUp
          ? Expanded(
              child: _ui.elevatedButtonIcon(
                  context: context,
                  label: 'Proceed',
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Theme.of(context).canvasColor,
                  icon: Icons.person_add_outlined,
                  function: () {
                    if (_signUpFormKey.currentState.validate()) {
                      _employeeIDViewModel
                          .isEmployeeIDValid(employeeID: idNumberInputController.text)
                          .then((isValid) {
                        _employeeIDViewModel
                            .isEmployeeIDExists(employeeID: idNumberInputController.text)
                            .then((isExist) {
                          print("EMPLOYEE ID VALIDITY: $isValid");
                          print("EMPLOYEE ID EXIST: $isExist");

                          if (pwdInputController.text ==
                              pwdConfInputController.text) {
                            if (isValid && !isExist) {
                              _baseUtils.snackBarProgress(
                                  context: context, content: "Signing Up");
                              _auth
                                  .signUpWithEmailPassword(
                                context: context,
                                email: emailInputController.text,
                                password: pwdInputController.text,
                              )
                                  .then((value) {
                                if(value != null){
                                  if (value.user != null) {
                                    _userProfile.setUserInfo(
                                      context: context,
                                      userID: value.user.uid,
                                      email: value.user.email,
                                      phoneNumber:
                                      phoneNumberInputController.text,
                                      position: positionInputController.text,
                                      userName: fullNameInputController.text,
                                      idNumber: idNumberInputController.text,
                                      imageFile: imageFile,
                                    );
                                    setState(() {
                                      signingUp == true;
                                    });
                                  }
                                }
                              });
                            } else if (!isValid) {
                              _baseUtils.snackBarError(
                                  context: context,
                                  content: "ID Number is not valid");
                            } else if (isExist) {
                              _baseUtils.snackBarError(
                                  context: context,
                                  content:
                                      "Other employee uses this ID Number");
                            } else {
                              _baseUtils.snackBarError(
                                  context: context,
                                  content: "Check your ID Number");
                            }
                          } else {
                            _baseUtils.snackBarError(
                                context: context,
                                content: "Check your password");
                          }
                        });
                      });
                    } else {
                      _baseUtils.snackBarError(
                          context: context, content: "Enter valid credentials");
                    }
                  }),
            )
          : Container(),
    ];
  }
}
