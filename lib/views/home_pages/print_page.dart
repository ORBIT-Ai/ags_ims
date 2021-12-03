// ignore_for_file: prefer_const_constructors

import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:ags_ims/views/home_page.dart';
import 'package:ags_ims/views/home_pages/print/annual_inventory_report.dart';
import 'package:ags_ims/views/home_pages/print/barcode_print.dart';
import 'package:ags_ims/views/home_pages/print/daily_inventory_report.dart';
import 'package:ags_ims/views/home_pages/print/monthly_inventory_report.dart';
import 'package:ags_ims/views/home_pages/print/weekly_inventory_report.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

class PrintPage extends StatefulWidget {
  const PrintPage({Key key}) : super(key: key);
  final title = "Print";

  @override
  _PrintPageState createState() => _PrintPageState();
}

class _PrintPageState extends State<PrintPage> {
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
        page: "print",
        header: "Print",
        subhead: "Export or print daily, weekly, monthly and annual reports.",
        hasButton: false,
        isDesktop: isDesktop,
      ),
      GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 4,
        itemBuilder: (context, i) {
          final icon = i == 0
              ? MdiIcons.calendarToday
              : i == 1
                  ? MdiIcons.calendarWeek
                  : i == 2
                      ? MdiIcons.calendarMonth
                      : i == 3
                          ? MdiIcons.calendarEnd
                          : null;

          final title = i == 0
              ? "Daily"
              : i == 1
                  ? "Weekly"
                  : i == 2
                      ? "Monthly"
                      : i == 3
                          ? "Annual"
                          : null;

          final subhead = i == 0
              ? "Export or print daily reports."
              : i == 1
                  ? "Export or print weekly reports."
                  : i == 2
                      ? "Export or print monthly reports."
                      : i == 3
                          ? "Export or print annual reports."
                          : null;

          return GestureDetector(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                          title: i == 0
                              ? "Daily Report"
                              : i == 1
                                  ? "Weekly Report"
                                  : i == 2
                                      ? "Monthly Report"
                                      : "Annual Report",
                          currentPage: i == 0
                              ? DailyInventoryReport()
                              : i == 1
                                  ? WeeklyInventoryReport()
                                  : i == 2
                                      ? MonthlyInventoryReport()
                                      : AnnualInventoryReport(),
                        ))),
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
}
