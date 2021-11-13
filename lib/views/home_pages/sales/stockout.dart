
// ignore_for_file: prefer_const_constructors

import 'package:ags_ims/core/models/item_details.dart';
import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:ags_ims/views/home_pages/stocks/item_card.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class StockOut extends StatefulWidget {
  const StockOut({Key key}) : super(key: key);

  @override
  _StockOutState createState() => _StockOutState();
}

class _StockOutState extends State<StockOut> {
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
        page: "stock_out",
        header: "Stock Out",
        subhead:
        "Manage items that are currently present in the warehouse.",
        hasButton: false,
        isDesktop: isDesktop,
      ),
      Container(
        padding: EdgeInsets.only(top: 10, left: 10, right: 10),
        child: FutureBuilder(
            future: _fireStoreDB.getStockOut(),
            builder: (context, AsyncSnapshot<List<ItemDetails>> items) {
              return items.hasData
                  ? ListView.builder(
                itemCount: items.data.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return ItemCard(
                    itemID: items.data[i].itemID,
                    isDesktop: isDesktop,
                  );
                },
              )
                  : Container();
            }),
      ),
    ];
  }
}
