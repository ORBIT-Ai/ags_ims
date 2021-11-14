// ignore_for_file: unnecessary_new, prefer_const_constructors, sized_box_for_whitespace

import 'dart:io';

import 'package:ags_ims/core/models/user_details.dart';
import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class UpdateAccount extends StatefulWidget {
  const UpdateAccount({Key key, this.userDetails}) : super(key: key);
  final title = "Update Account";
  final AsyncSnapshot<UserDetails> userDetails;

  @override
  _UpdateAccountState createState() => _UpdateAccountState();
}

class _UpdateAccountState extends State<UpdateAccount> {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  final _ui = locator<UI>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _fireStoreDB = locator<FireStoreDBService>();
  final _userProfile = locator<UserProfileViewModel>();

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

    if (widget.userDetails.hasData) {
      emailInputController.text = widget.userDetails.data.emailAddress;
      fullNameInputController.text = widget.userDetails.data.userName;
      positionInputController.text = widget.userDetails.data.position;
      phoneNumberInputController.text =
          widget.userDetails.data.phoneNumber;
      idNumberInputController.text = widget.userDetails.data.idNumber;
    }
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

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _signUpFormKey,
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

  List<Widget> mainContent({BuildContext context}) {
    return [
      SizedBox(
        width: 40,
        height: 40,
      ),
      Container(
        width: isDesktop
            ? MediaQuery.of(context).size.width / 3.0
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
                content: "Update Account",
                color: Theme.of(context).primaryColor,
                isDesktop: isDesktop),
            SizedBox(
              height: 15,
            ),
            _ui.subheadMedium(
                context: context,
                content: "Edit your account information.",
                color: Colors.grey,
                isDesktop: isDesktop),
            SizedBox(
              height: 30,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  child: Container(
                    width: 86,
                    height: 86,
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      child: ClipOval(
                        child: widget.userDetails.data.profileUrl == null && imageFile == null ?
                        Container(
                          height: 86,
                          width: 86,
                          child: Icon(
                            Icons.person,
                            size: 48,
                            color:
                            Theme.of(context).colorScheme.primary,
                          ),
                        ) : widget.userDetails.data.profileUrl != null
                            ? Image.network(
                                widget.userDetails.data.profileUrl,
                                height: 86,
                                width: 86,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                imageFile,
                                height: 86,
                                width: 86,
                                fit: BoxFit.cover,
                              ),
                      ),
                      radius: 100,
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                Expanded(
                    child: _ui.outlinedButtonIcon(
                  context: context,
                  label: "Change Photo",
                  backgroundColor: Theme.of(context).colorScheme.background,
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
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    label: "Email Address",
                    icon: Icons.email_rounded,
                    color: Theme.of(context).disabledColor,
                    autoFocus: true,
                    enabled: false,
                  ),
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
            _ui.textFormField(
                context: context,
                controller: idNumberInputController,
                keyboardType: TextInputType.text,
                label: "ID Number",
                icon: Icons.person_pin_rounded,
                color: null),
            SizedBox(
              height: 40,
            ),
            isMobile
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: controlsButtons(context),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: controlsButtons(context),
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
            label: 'Save',
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Theme.of(context).canvasColor,
            icon: Icons.cloud_upload_rounded,
            function: () {
              if (_signUpFormKey.currentState.validate()) {
                _baseUtils.snackBarProgress(
                    context: context, content: "Updating...");
                _userProfile.updateAccount(
                  context: context,
                  userID: _auth.getCurrentUserID(),
                  email: emailInputController.text,
                  phoneNumber: phoneNumberInputController.text,
                  position: positionInputController.text,
                  userName: fullNameInputController.text,
                  idNumber: idNumberInputController.text,
                  imageFile: imageFile != null ? imageFile : null,
                  imageUrl: widget.userDetails.data.profileUrl,
                );
              } else {
                _baseUtils.snackBarError(
                    context: context, content: "Enter valid credentials");
              }
            }),
      ),
    ];
  }
}
