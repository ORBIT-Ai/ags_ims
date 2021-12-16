// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:ags_ims/core/models/user_details.dart';
import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:ags_ims/views/home_page.dart';
import 'package:ags_ims/views/home_pages/account/account_delete.dart';
import 'package:ags_ims/views/home_pages/update_account.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key key}) : super(key: key);
  final title = "Account";

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _ui = locator<UI>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _fireStoreDB = locator<FireStoreDBService>();
  final _userProfile = locator<UserProfileViewModel>();

  bool isDesktop;
  bool isMobile;
  bool isTablet;

  bool isAdmin;

  TextEditingController emailInputController;
  TextEditingController fullNameInputController;
  TextEditingController positionInputController;
  TextEditingController phoneNumberInputController;
  TextEditingController idNumberInputController;

  @override
  initState() {
    //initializePrefs();
    emailInputController = new TextEditingController();
    fullNameInputController = new TextEditingController();
    positionInputController = new TextEditingController();
    phoneNumberInputController = new TextEditingController();
    idNumberInputController = new TextEditingController();

    isAdmin = _auth.getCurrentUserID() == "uffEWANeSwaopAZolx6VNXbqakA3";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      isDesktop =
          sizingInformation.deviceScreenType == DeviceScreenType.desktop;
      isMobile = sizingInformation.deviceScreenType == DeviceScreenType.mobile;
      isTablet = sizingInformation.deviceScreenType == DeviceScreenType.tablet;
      return Container(
        child: FutureBuilder(
            future:
                _fireStoreDB.getUserDetails(userID: _auth.getCurrentUserID()),
            builder: (context, AsyncSnapshot<UserDetails> userDetails) {
              if (userDetails.hasData) {
                emailInputController.text = userDetails.data.emailAddress;
                fullNameInputController.text = userDetails.data.userName;
                positionInputController.text = userDetails.data.position;
                phoneNumberInputController.text = userDetails.data.phoneNumber;
                idNumberInputController.text = userDetails.data.idNumber;
              }
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.only(
                    left: isDesktop ? 20 : 0,
                    right: isDesktop ? 20 : 0,
                    top: isDesktop ? 20 : 0,
                    bottom: isDesktop ? 20 : 0),
                child: SingleChildScrollView(
                  child: isDesktop || isMobile || isTablet
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: mainContent(
                              context: context, userDetails: userDetails),
                        )
                      : UI().deviceNotSupported(
                          context: context,
                          isDesktop: isDesktop,
                          content: "Device Not Supported"),
                ),
              );
            }),
      );
    });
  }

  List<Widget> mainContent(
      {BuildContext context, AsyncSnapshot<UserDetails> userDetails}) {
    return [
      SizedBox(height: isDesktop ? 5 : 15),
      _ui.headerCard(
        context: context,
        page: "account",
        header: "Account",
        subhead: "Manage your account, update details and credentials.",
        hasButton: false,
        isDesktop: isDesktop,
      ),
      Container(
        padding: EdgeInsets.only(
            left: 20, right: 20, top: 20, bottom: isDesktop ? 0 : 40),
        child: Column(
          children: [
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
                      enabled: false,
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
                    color: null,
                    enabled: false,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: _ui.textFormField(
                    context: context,
                    controller: positionInputController,
                    keyboardType: TextInputType.text,
                    label: "Position",
                    icon: Icons.business_center_rounded,
                    color: null,
                    enabled: false,
                  ),
                ),
                isAdmin ? Container() : SizedBox(
                  width: 10,
                ),
                isAdmin ? Container() : Expanded(
                  child: _ui.textFormField(
                    context: context,
                    controller: phoneNumberInputController,
                    keyboardType: TextInputType.phone,
                    label: "Phone Number",
                    icon: Icons.phone_rounded,
                    color: null,
                    enabled: false,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            _ui.textFormField(
              context: context,
              controller: idNumberInputController,
              keyboardType: TextInputType.text,
              label: "ID Number",
              icon: Icons.person_pin_rounded,
              color: null,
              enabled: false,
            ),
            SizedBox(
              height: 20,
            ),
            isMobile
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: controlsButtons(context, userDetails),
                  )
                : Container(
                    width: MediaQuery.of(context).size.width,
                    height: 112,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: controlsButtons(context, userDetails),
                    ),
                  ),
            SizedBox(
              height: 15,
            ),
            isAdmin ? Container() : Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                      title: "Account Deletion",
                                      currentPage: AccountDelete(),
                                      userDetails: userDetails,
                                    )));
                      },
                      label: Text("Delete Account"),
                      icon: Icon(Icons.delete_rounded),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Theme.of(context).primaryColorLight,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
    ];
  }

  List<Widget> controlsButtons(
      BuildContext context, AsyncSnapshot<UserDetails> userDetails) {
    return [
      isAdmin ? Container() : Expanded(
        child: FloatingActionButton.extended(
          label: Text("Update Account"),
          icon: Icon(Icons.edit_rounded),
          backgroundColor: Theme.of(context).primaryColorLight,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                          title: "Update Account",
                          currentPage: UpdateAccount(
                            userDetails: userDetails,
                          ),
                          userDetails: userDetails,
                        )));
          },
        ),
      ),
      isAdmin ? Container() : SizedBox(
        width: 15,
        height: 15,
      ),
      Expanded(
        child: FloatingActionButton.extended(
          onPressed: () {
            _auth.signOut(context: context);
          },
          label: Text("Logout Account"),
          icon: Icon(Icons.exit_to_app_rounded),
        ),
      ),
    ];
  }
}
