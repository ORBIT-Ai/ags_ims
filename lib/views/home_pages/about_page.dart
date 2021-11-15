// ignore_for_file: prefer_const_constructors

import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key key}) : super(key: key);
  final title = "About";

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final _ui = locator<UI>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _fireStoreDB = locator<FireStoreDBService>();
  final _userProfile = locator<UserProfileViewModel>();

  bool isDesktop;
  bool isMobile;
  bool isTablet;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      isDesktop =
          sizingInformation.deviceScreenType == DeviceScreenType.desktop;
      isMobile = sizingInformation.deviceScreenType == DeviceScreenType.mobile;
      isTablet = sizingInformation.deviceScreenType == DeviceScreenType.tablet;
      return SingleChildScrollView(
          child: Container(
        width: MediaQuery.of(context).size.width,
        height: isDesktop ? MediaQuery.of(context).size.height : null,
        padding: EdgeInsets.only(
            left: isDesktop ? 20 : 0,
            right: isDesktop ? 20 : 0,
            top: isDesktop ? 20 : 0,
            bottom: isDesktop ? 20 : 0),
        child: isDesktop || isMobile || isTablet
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: mainContent(context: context),
              )
            : UI().deviceNotSupported(
                context: context,
                isDesktop: isDesktop,
                content: "Device Not Supported"),
      ));
    });
  }

  List<Widget> mainContent({BuildContext context}) {
    return [
      SizedBox(height: isDesktop ? 5 : 15),
      _ui.headerCard(
        context: context,
        page: "about",
        header: "About",
        subhead:
            "Know more about the application,  what are the services used and the frameworks used to run each features needed.",
        hasButton: false,
        isDesktop: isDesktop,
      ),
      GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 2,
        itemBuilder: (context, i) {
          final icon = i == 0
              ? MdiIcons.firebase
              : i == 1
                  ? MdiIcons.firebase
                  : null;

          final title = i == 0
              ? "Flutter"
              : i == 1
                  ? "Firebase"
                  : null;

          final subhead = i == 0
              ? "Used as a framework to build it for web and mobile."
              : i == 1
                  ? "API used to run each services like Cloud Database, Storage, Hosting and Authentication."
                  : null;

          return Card(
            margin: EdgeInsets.only(top: 10, right: 10, left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(18),
                      topLeft: Radius.circular(18)),
                  child: Container(
                    padding: EdgeInsets.all(30),
                    color: Theme.of(context).colorScheme.primaryVariant,
                    child: Icon(
                      icon,
                      color: Theme.of(context).primaryColor,
                      size: isDesktop ? 72 : 48,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ui.headlineMedium(
                            context: context,
                            content: title,
                            color: null,
                            isDesktop: isDesktop,
                          ),
                          _ui.subheadSmall(
                            context: context,
                            content: subhead,
                            color: null,
                            isDesktop: isDesktop,
                          ),
                        ]),
                  ),
                ),
              ],
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop ? 2 : 1, childAspectRatio: 4 / 1.5),
      ),
      SizedBox(height: 50),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/orbitai_logo.png',
            scale: 10,
          ),
          SizedBox(width: 10),
          _ui.headlineSmall(
              context: context,
              content: "Developed by Orbit Ai",
              color: null,
              isDesktop: isDesktop),
        ],
      ),
      SizedBox(height: isDesktop ? 5 : 15),
    ];
  }
}
