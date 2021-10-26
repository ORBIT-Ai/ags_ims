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

class SalesPage extends StatefulWidget {
  const SalesPage({Key key}) : super(key: key);
  final title = "Sales";

  @override
  _SalesPageState createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
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
      SizedBox(height: 15),
      _ui.headerCard(
        context: context,
        page: "sales",
        header:
        "Sales",
        subhead:
        "Review the items that are present in the warehouse and those that are out-of-stock. Any actions will reflect to the History so others could track what’s happening to the ecosystem.",
        hasButton: false,
        isDesktop: isDesktop,
      ),
      GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 2,
        itemBuilder: (context, i) {
          final icon = i == 0
              ? MdiIcons.packageVariantClosed
              : i == 1
              ? MdiIcons.packageVariant
              : null;

          final title = i == 0
              ? "On Hand"
              : i == 1
              ? "Stockout"
              : null;

          final subhead = i == 0
              ? "Manage items that are currently present in the warehouse."
              : i == 1
              ? "Reviiew those items that aren’t present in the warehouse."
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
      SizedBox(height: 10),
    ];
  }
}
