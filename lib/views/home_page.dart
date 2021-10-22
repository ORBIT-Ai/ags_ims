// ignore_for_file: prefer_final_fields, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_typing_uninitialized_variables

import 'package:ags_ims/core/models/user_details.dart';
import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:ags_ims/views/home_pages/home_main_page.dart';
import 'package:ags_ims/views/home_pages/sales_page.dart';
import 'package:ags_ims/views/home_pages/scanner_page.dart';
import 'package:ags_ims/views/home_pages/stocks_page.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _homeFormKey = GlobalKey<ScaffoldState>();
  final _ui = locator<UI>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _fireStoreDB = locator<FireStoreDBService>();
  final _userProfile = locator<UserProfileViewModel>();

  Widget _currentPage = HomeMainPage();
  var _title;
  var _appBarIcon;

  @override
  void initState() {
    super.initState();
    _title = "Dashboard";
    _appBarIcon = Icons.dashboard_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _baseUtils.closeApp(context),
      child: Form(
        child: ResponsiveBuilder(builder: (context, sizingInformation) {
          bool isDesktop =
              sizingInformation.deviceScreenType == DeviceScreenType.desktop;
          bool isMobile =
              sizingInformation.deviceScreenType == DeviceScreenType.mobile;
          bool isTablet =
              sizingInformation.deviceScreenType == DeviceScreenType.tablet;
          String deviceType = isDesktop
              ? "desktop"
              : isMobile
                  ? "mobile"
                  : "tablet";
          return Scaffold(
            key: _homeFormKey,
            appBar: AppBar(
              backgroundColor: isDesktop
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).canvasColor,
              title: Text(
                _title,
                style: TextStyle(
                    color: isDesktop
                        ? Theme.of(context).canvasColor
                        : Theme.of(context).primaryColor),
              ),
              iconTheme: IconThemeData(
                  color: isDesktop
                      ? Theme.of(context).canvasColor
                      : Theme.of(context).primaryColor),
              leading: isTablet || isMobile
                  ? IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () => _homeFormKey.currentState.openDrawer(),
                    )
                  : Icon(_appBarIcon),
            ),
            drawer: isTablet || isMobile
                ? drawerContent(context, deviceType)
                : Container(),
            body: isDesktop
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isDesktop
                            ? drawerContent(context, deviceType)
                            : Container(),
                        Container(
                          width: MediaQuery.of(context).size.width / 1.3,
                          child: _currentPage,
                        )
                      ],
                    ),
                  )
                : Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 56),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            isDesktop
                                ? drawerContent(context, deviceType)
                                : Container(),
                            Container(
                              child: _currentPage,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
          );
        }),
      ),
    );
  }

  Widget drawerContent(BuildContext context, String _deviceType) {
    return Drawer(
      child: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              SizedBox(
                height: 270,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  child: FutureBuilder(
                      future: _fireStoreDB.getUserDetails(
                          userID: _auth.getCurrentUserID()),
                      builder:
                          (context, AsyncSnapshot<UserDetails> userDetails) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 100,
                              width: 100,
                              child: _ui.profilePhoto(
                                context: context,
                                profileUrl: userDetails.data.profileUrl,
                                filterQuality: FilterQuality.medium,
                              ),
                            ),
                            SizedBox(height: 20),
                            _ui.headlineMedium(
                              context: context,
                              content: userDetails.data.userName,
                              color: Theme.of(context).colorScheme.primary,
                              isDesktop: false,
                            ),
                            SizedBox(height: 10),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                                side: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: _ui.caption(
                                  context: context,
                                  content: userDetails.data.position.trim(),
                                  color: Theme.of(context).colorScheme.primary,
                                  isDesktop: false,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.home_rounded,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(HomeMainPage().title)
                  ],
                ),
                onTap: () {
                  setState(() {
                    _currentPage = HomeMainPage();
                    _title = HomeMainPage().title;
                    _appBarIcon = Icons.dashboard_rounded;
                    _deviceType == "desktop"
                        ? Container()
                        : Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.archive_rounded,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(StocksPage().title)
                  ],
                ),
                onTap: () {
                  setState(() {
                    _currentPage = StocksPage();
                    _title = StocksPage().title;
                    _appBarIcon = Icons.account_box_rounded;
                    _deviceType == "desktop"
                        ? Container()
                        : Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.shopping_bag_rounded,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(SalesPage().title)
                  ],
                ),
                onTap: () {
                  setState(() {
                    _currentPage = SalesPage();
                    _title = SalesPage().title;
                    _appBarIcon = Icons.group_rounded;
                    _deviceType == "desktop"
                        ? Container()
                        : Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.camera_rounded,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(ScannerPage().title)
                  ],
                ),
                onTap: () {
                  setState(() {
                    _currentPage = ScannerPage();
                    _title = ScannerPage().title;
                    _appBarIcon = Icons.group_rounded;
                    _deviceType == "desktop"
                        ? Container()
                        : Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
          Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: _ui.outlinedButtonIcon(
                context: context,
                label: "Sign Out",
                backgroundColor: Theme.of(context).colorScheme.background,
                foregroundColor: Theme.of(context).colorScheme.secondary,
                icon: Icons.exit_to_app_rounded,
                function: () {
                  _auth.signOut();
                },
              ))
        ],
      ),
    );
  }
}
