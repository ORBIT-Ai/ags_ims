// ignore_for_file: prefer_final_fields, prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, prefer_typing_uninitialized_variables

import 'package:ags_ims/core/models/item_details.dart';
import 'package:ags_ims/core/models/user_details.dart';
import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:ags_ims/views/home_pages/about_page.dart';
import 'package:ags_ims/views/home_pages/account_page.dart';
import 'package:ags_ims/views/home_pages/help_page.dart';
import 'package:ags_ims/views/home_pages/history_page.dart';
import 'package:ags_ims/views/home_pages/home_main_page.dart';
import 'package:ags_ims/views/home_pages/print_page.dart';
import 'package:ags_ims/views/home_pages/sales_page.dart';
import 'package:ags_ims/views/home_pages/scanner_page.dart';
import 'package:ags_ims/views/home_pages/stocks/item_details.dart';
import 'package:ags_ims/views/home_pages/stocks/update_item.dart';
import 'package:ags_ims/views/home_pages/stocks_page.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

class HomePage extends StatefulWidget {
  final String title, itemID;
  final Widget currentPage;
  final AsyncSnapshot<UserDetails> userDetails;
  final AsyncSnapshot<ItemDetails> itemDetails;

  const HomePage(
      {Key key,
      this.title,
      this.currentPage,
      this.userDetails,
      this.itemID,
      this.itemDetails})
      : super(key: key);

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

  Widget _currentPage;
  var _title;
  var _appBarIcon;

  bool isDesktop;
  bool isMobile;
  bool isTablet;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.currentPage ?? HomeMainPage();
    _title = widget.title ?? "Home";
    _appBarIcon = Icons.dashboard_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _baseUtils.closeApp(context),
      child: Form(
        child: ResponsiveBuilder(builder: (context, sizingInformation) {
          isDesktop =
              sizingInformation.deviceScreenType == DeviceScreenType.desktop;
          isMobile =
              sizingInformation.deviceScreenType == DeviceScreenType.mobile;
          isTablet =
              sizingInformation.deviceScreenType == DeviceScreenType.tablet;
          String deviceType = isDesktop
              ? "desktop"
              : isMobile
                  ? "mobile"
                  : "tablet";
          return Scaffold(
            key: _homeFormKey,
            appBar: isMobile
                ? appBar()
                : AppBar(
                    toolbarHeight: 0,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shadowColor: Colors.transparent,
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
                          padding: EdgeInsets.only(
                              left: isDesktop ? 0 : 0,
                              right: isDesktop ? 0 : 0,
                              top: isDesktop ? 0 : 0,
                              bottom: isDesktop ? 0 : 0),
                          width: MediaQuery.of(context).size.width / 1.3,
                          height: MediaQuery.of(context).size.height,
                          child: Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 56),
                                child: _currentPage,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width / 1.3,
                                height: 56,
                                child: isDesktop ? appBar() : Container(),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                : Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 0),
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

  Widget appBar() {
    return AppBar(
      toolbarHeight: 56,
      backgroundColor: isDesktop
          ? Theme.of(context).primaryColor
          : Theme.of(context).primaryColor,
      title: Text(
        _title,
        style: TextStyle(
            color: isDesktop
                ? Theme.of(context).canvasColor
                : Theme.of(context).canvasColor),
      ),
      elevation: 12,
      actionsIconTheme: IconThemeData(color: Theme.of(context).canvasColor),
      actions: [
        _title == "Item Details"
            ? IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(
                                title: "Update Item",
                                currentPage: UpdateItem(
                                  isDesktop: isDesktop,
                                  itemID: widget.itemID,
                                  itemDetails: widget.itemDetails,
                                ),
                              )));
                },
                icon: Icon(Icons.edit_rounded))
            : Container()
      ],
      iconTheme: IconThemeData(
          color: isDesktop
              ? Theme.of(context).canvasColor
              : Theme.of(context).canvasColor),
      leading: isTablet || isMobile
          ? IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => _homeFormKey.currentState.openDrawer(),
            )
          : Icon(_appBarIcon),
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
                height: 250,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                  ),
                  child: FutureBuilder(
                      future: _fireStoreDB.getUserDetails(
                          userID: _auth.getCurrentUserID()),
                      builder:
                          (context, AsyncSnapshot<UserDetails> userDetails) {
                        return userDetails.hasData
                            ? Column(
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
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    isDesktop: false,
                                  ),
                                  SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _currentPage = AccountPage();
                                        _title = AccountPage().title;
                                        _appBarIcon = Icons.person_rounded;
                                        _deviceType == "desktop"
                                            ? Container()
                                            : Navigator.pop(context);
                                      });
                                    },
                                    child: Card(
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
                                          content:
                                              userDetails.data.position.trim(),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          isDesktop: false,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            : Container();
                      }),
                ),
              ),
              ListTile(
                tileColor: _title == "Home"
                    ? Theme.of(context).primaryColorLight
                    : null,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.home_rounded,
                      color: _title == "Home"
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      HomeMainPage().title,
                      style: TextStyle(
                        color: _title == "Home"
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    _currentPage = HomeMainPage();
                    _title = HomeMainPage().title;
                    _appBarIcon = Icons.home_rounded;
                    _deviceType == "desktop"
                        ? Container()
                        : Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                tileColor: _title == "Stocks"
                    ? Theme.of(context).primaryColorLight
                    : null,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.archive_rounded,
                      color: _title == "Stocks"
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      StocksPage().title,
                      style: TextStyle(
                        color: _title == "Stocks"
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    _currentPage = StocksPage();
                    _title = StocksPage().title;
                    _appBarIcon = Icons.archive_rounded;
                    _deviceType == "desktop"
                        ? Container()
                        : Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                tileColor: _title == "Sales"
                    ? Theme.of(context).primaryColorLight
                    : null,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.shopping_bag_rounded,
                      color: _title == "Sales"
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      SalesPage().title,
                      style: TextStyle(
                        color: _title == "Sales"
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    _currentPage = SalesPage();
                    _title = SalesPage().title;
                    _appBarIcon = Icons.shopping_bag_rounded;
                    _deviceType == "desktop"
                        ? Container()
                        : Navigator.pop(context);
                  });
                },
              ),
              isMobile
                  ? ListTile(
                      tileColor: _title == "Scanner"
                          ? Theme.of(context).primaryColorLight
                          : null,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.camera_rounded,
                            color: _title == "Scanner"
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            ScannerPage().title,
                            style: TextStyle(
                              color: _title == "Scanner"
                                  ? Theme.of(context).primaryColor
                                  : null,
                            ),
                          )
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          _currentPage = ScannerPage();
                          _title = ScannerPage().title;
                          _appBarIcon = MdiIcons.barcodeScan;
                          _deviceType == "desktop"
                              ? Container()
                              : Navigator.pop(context);
                        });
                      },
                    )
                  : Container(),
              ListTile(
                tileColor: _title == "Print"
                    ? Theme.of(context).primaryColorLight
                    : null,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.print_rounded,
                      color: _title == "Print"
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      PrintPage().title,
                      style: TextStyle(
                        color: _title == "Print"
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    _currentPage = PrintPage();
                    _title = PrintPage().title;
                    _appBarIcon = Icons.print_rounded;
                    _deviceType == "desktop"
                        ? Container()
                        : Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                tileColor: _title == "History"
                    ? Theme.of(context).primaryColorLight
                    : null,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.history_rounded,
                      color: _title == "History"
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      HistoryPage().title,
                      style: TextStyle(
                        color: _title == "History"
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    _currentPage = HistoryPage();
                    _title = HistoryPage().title;
                    _appBarIcon = Icons.history_rounded;
                    _deviceType == "desktop"
                        ? Container()
                        : Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                tileColor: _title == "Help"
                    ? Theme.of(context).primaryColorLight
                    : null,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.help,
                      color: _title == "Help"
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      HelpPage().title,
                      style: TextStyle(
                        color: _title == "Help"
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    _currentPage = HelpPage();
                    _title = HelpPage().title;
                    _appBarIcon = Icons.help_rounded;
                    _deviceType == "desktop"
                        ? Container()
                        : Navigator.pop(context);
                  });
                },
              ),
              ListTile(
                tileColor: _title == "About"
                    ? Theme.of(context).primaryColorLight
                    : null,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info,
                      color: _title == "About"
                          ? Theme.of(context).primaryColor
                          : Colors.grey,
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      AboutPage().title,
                      style: TextStyle(
                        color: _title == "About"
                            ? Theme.of(context).primaryColor
                            : null,
                      ),
                    )
                  ],
                ),
                onTap: () {
                  setState(() {
                    _currentPage = AboutPage();
                    _title = AboutPage().title;
                    _appBarIcon = Icons.info_rounded;
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
                  _auth.signOut(context: context);
                },
              ))
        ],
      ),
    );
  }
}
