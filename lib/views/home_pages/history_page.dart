
import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key key}) : super(key: key);
  final title = "History";

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
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
      isMobile =
          sizingInformation.deviceScreenType == DeviceScreenType.mobile;
      isTablet =
          sizingInformation.deviceScreenType == DeviceScreenType.tablet;
      return SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: isDesktop ? MediaQuery.of(context).size.height : null,
            child: isDesktop || isMobile || isTablet
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
    });
  }

  List<Widget> mainContent({BuildContext context}) {
    return [

    ];
  }
}
