// ignore_for_file: prefer_const_constructors, unnecessary_new

import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key key}) : super(key: key);
  final title = "Help";

  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
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
      SizedBox(height: 15),
      _ui.headerCard(
        context: context,
        page: "help",
        header: "Help",
        subhead:
            "Learn how to use the different features and functionality of the ecosystem.",
        hasButton: false,
        isDesktop: isDesktop,
      ),
      GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, i) {
          final icon = i == 0
              ? MdiIcons.archive
              : i == 1
                  ? MdiIcons.shopping
                  : i == 2
                      ? MdiIcons.printer
                      : i == 3
                          ? MdiIcons.history
                          : null;

          final title = i == 0
              ? "Stocks"
              : i == 1
                  ? "Sales"
                  : i == 2
                      ? "Print"
                      : i == 3
                          ? "History"
                          : null;

          final subhead = i == 0
              ? "Learn how to Add, Update and Delete items in the stocks."
              : i == 1
                  ? "Learn how to review the items that are present in the warehouse and those that are out-of-stock."
                  : i == 2
                      ? "Learn how to  export or print daily, weekly, monthly and annual reports."
                      : i == 3
                          ? "Learn how to  view recent actions made by other employees within the ecosystem."
                          : null;

          return GestureDetector(
            onTap: () {
              helpDialog(position: i);
            },
            child: Card(
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
            ),
          );
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop ? 2 : 1, childAspectRatio: 4 / 1.5),
      ),
      SizedBox(height: 10),
    ];
  }

  Future<void> helpDialog({@required int position}) {
    List<String> procedures;
    procedures = position == 0
        ? [
            "To add an item, go to Stock page. Click the + button. Fill the text fields with item details, don't forget to add an image and generate a barcode. Lastly, click the 'Save' button.",
            "To view an item, go to Stock page and click an item to view its details.",
            "To update an item, go to Stock page, click an item, press the edit button in the toolbar. Tap the update button to saved the changes that have been made.",
            "To delete an item, click an item in the Stock page and tap the 'Delete' button.",
            "To view records, go to Stock page, select an item and press the 'Records' button."
          ]
        : position == 1
            ? ['']
            : position == 2
                ? ['']
                : [''];
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: Text("Procedures"),
        content: ListView.builder(
            itemCount: procedures.length,
            shrinkWrap: true,
            physics: AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              return Text("${i + 1}. ${procedures[i]}");
            }),
      ),
    );
  }
}
