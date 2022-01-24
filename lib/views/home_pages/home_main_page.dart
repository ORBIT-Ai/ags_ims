// ignore_for_file: prefer_const_constructors

import 'package:ags_ims/core/models/history.dart';
import 'package:ags_ims/core/models/user_details.dart';
import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:ags_ims/views/home_page.dart';
import 'package:ags_ims/views/home_pages/about_page.dart';
import 'package:ags_ims/views/home_pages/history_page.dart';
import 'package:ags_ims/views/home_pages/print_page.dart';
import 'package:ags_ims/views/home_pages/sales_page.dart';
import 'package:ags_ims/views/home_pages/scanner_page.dart';
import 'package:ags_ims/views/home_pages/stocks_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomeMainPage extends StatefulWidget {
  const HomeMainPage({Key key}) : super(key: key);
  final title = "Home";

  @override
  _HomeMainPageState createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
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
      FutureBuilder(
          future: _fireStoreDB.getUserDetails(userID: _auth.getCurrentUserID()),
          builder: (context, AsyncSnapshot<UserDetails> userDetails) {
            return _ui.headerCard(
              context: context,
              page: "home",
              header:
                  "Welcome ${userDetails.hasData ? userDetails.data.userName : ''}",
              subhead:
                  "You have the access to these features, feel free to access the Stocks, review what remains in the warehouse through Sales, print date-specific reports, view recent actions created by other personnels through History and view your account details.",
              hasButton: false,
              isDesktop: isDesktop,
            );
          }),
      GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, i) {
          final icon = i == 0
              ? Icons.archive_rounded
              : i == 1
                  ? Icons.shopping_bag
                  : i == 2
                      ? isDesktop
                          ? Icons.print_rounded
                          : Icons.camera_rounded
                      : i == 3
                          ? Icons.history_rounded
                          : isDesktop
                              ? ""
                              : Icons.info_rounded;

          final title = i == 0
              ? "Stocks"
              : i == 1
                  ? "Sales"
                  : i == 2
                      ? isDesktop
                          ? "Print"
                          : "Scanner"
                      : i == 3
                          ? "History"
                          : isDesktop
                              ? ""
                              : "About";

          final subhead = i == 0
              ? "Add, Update and Delete items in the stocks."
              : i == 1
                  ? "Review the items that are present in the warehouse and those that are out-of-stock."
                  : i == 2
                      ? isDesktop
                          ? "Export or print daily, weekly, monthly and annual reports."
                          : "Scan barcodes from specific items and get its details."
                      : i == 3
                          ? "View recent actions made by other employees within the ecosystem."
                          : isDesktop
                              ? ""
                              : "View information about the software.";

          return title != "" ? Card(
            margin: EdgeInsets.only(top: 10, right: 10, left: 10),
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomePage(
                            title: i == 0
                                ? StocksPage().title
                                : i == 1
                                    ? SalesPage().title
                                    : i == 2
                                        ? isDesktop
                                            ? PrintPage().title
                                            : ScannerPage().title
                                        : i == 3
                                            ? HistoryPage().title
                                            : AboutPage().title,
                            currentPage: i == 0
                                ? StocksPage()
                                : i == 1
                                    ? SalesPage()
                                    : i == 2
                                        ? isDesktop
                                            ? PrintPage()
                                            : ScannerPage()
                                        : i == 3
                                            ? HistoryPage()
                                            : AboutPage(),
                          ))),
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
          ) : Container();
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isDesktop ? 2 : 1, childAspectRatio: 4 / 1.5),
      ),
      //isDesktop ? Container() : SizedBox(height: 10),
    ];
  }
}
