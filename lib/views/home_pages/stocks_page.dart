// ignore_for_file: prefer_const_constructors

import 'package:ags_ims/core/models/item_details.dart';
import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:ags_ims/views/home_page.dart';
import 'package:ags_ims/views/home_pages/stocks/add_item.dart';
import 'package:ags_ims/views/home_pages/stocks/item_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class StocksPage extends StatefulWidget {
  const StocksPage({Key key}) : super(key: key);
  final title = "Stocks";

  @override
  _StocksPageState createState() => _StocksPageState();
}

class _StocksPageState extends State<StocksPage> {
  final _ui = locator<UI>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _fireStoreDB = locator<FireStoreDBService>();
  final _userProfile = locator<UserProfileViewModel>();

  bool isDesktop;
  bool isMobile;
  bool isTablet;

  int page = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      isDesktop =
          sizingInformation.deviceScreenType == DeviceScreenType.desktop;
      isMobile = sizingInformation.deviceScreenType == DeviceScreenType.mobile;
      isTablet = sizingInformation.deviceScreenType == DeviceScreenType.tablet;
      return Stack(
        children: [
          SingleChildScrollView(
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
          )),
          !kIsWeb
              ? Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    child: Icon(Icons.add_rounded),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                    title: 'Stocks',
                                    currentPage: AddItem(),
                                  )));
                    },
                  ),
                )
              : Container(),
        ],
      );
    });
  }

  List<Widget> mainContent({BuildContext context}) {
    return [
      SizedBox(height: 15),
      _ui.headerCard(
        context: context,
        page: "stocks",
        header: "Stocks",
        subhead:
            "Add update or delete a specific item, click a specific item from the list to view its details. Any actions will reflect to the History so others could track what’s happening to the ecosystem.",
        hasButton: false,
        isDesktop: isDesktop,
      ),
      Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: ListView.builder(
            itemCount: 8,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, i) {
              return TextButton(
                child: Text("Page ${i + 1}"),
                onPressed: () {
                  setState(() {
                    page = i;
                  });
                },
              );
            }),
      ),
      Container(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: FutureBuilder(
            future: _fireStoreDB.getStocks(page: page),
            builder: (context, AsyncSnapshot<List<ItemDetails>> items) {
              return items.hasData
                  ? ListView.builder(
                      itemCount: items.data.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, i) {
                        print("LENGTH ${items.data.length}");
                        return ItemCard(
                          itemID: items.data[i].itemID,
                          isDesktop: isDesktop,
                          position: "${i + 1}",
                        );
                      },
                    )
                  : Container();
            }),
      ),
    ];
  }
}
