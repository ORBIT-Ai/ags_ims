// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:ags_ims/core/models/item_details.dart';
import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:ags_ims/views/home_pages/records/records_details.dart';
import 'package:ags_ims/views/home_pages/records/records_re_stock.dart';
import 'package:ags_ims/views/home_pages/records/records_stock_out.dart';
import 'package:ags_ims/views/home_pages/stocks/item_card.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

class RecordsPage extends StatefulWidget {
  final String itemID;
  final String title = "Records";

  const RecordsPage({Key key, this.itemID}) : super(key: key);

  @override
  _RecordsPageState createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
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

  List<Widget> mainContent({@required BuildContext context}) {
    return [
    Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: TabBar(
            tabs: [
              Tab(text: "Details",icon: Icon(Icons.info_rounded)),
              Tab(text: "Stock-out",icon: Icon(MdiIcons.packageVariant)),
              Tab(text: "Re-stock",icon: Icon(MdiIcons.packageVariantClosed)),
            ],
          ),
          body: TabBarView(
            children: [
              RecordsDetails(itemID: widget.itemID,),
              RecordsStockOut(itemID: widget.itemID,),
              RecordsReStock(itemID: widget.itemID,),
            ],
          ),
        ),
      ),
    ),
    ];
  }
}
