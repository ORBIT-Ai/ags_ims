// ignore_for_file: prefer_const_constructors

import 'package:ags_ims/core/models/item_details.dart';
import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:ags_ims/views/home_page.dart';
import 'package:ags_ims/views/home_pages/stocks/item_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({
    Key key,
  }) : super(key: key);
  final title = "Scanner";

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final _ui = locator<UI>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _fireStoreDB = locator<FireStoreDBService>();
  final _userProfile = locator<UserProfileViewModel>();

  bool isDesktop;
  bool isMobile;
  bool isTablet;

  bool isScanned = false;

  TextEditingController itemCodeController = new TextEditingController();

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
        page: "stocks",
        header: "Scanner",
        subhead: "Scan a barcode of an item to get its details.",
        hasButton: false,
        isDesktop: isDesktop,
      ),
      SizedBox(height: 15),
      Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _ui.outlinedButtonIcon(
                context: context,
                label: "Scan Barcode",
                backgroundColor: Theme.of(context).canvasColor,
                foregroundColor: Theme.of(context).primaryColor,
                icon: MdiIcons.barcodeScan,
                function: () async {
                  String itemCode = await FlutterBarcodeScanner.scanBarcode(
                      null, "Back", true, ScanMode.BARCODE);

                  itemCode != null
                      ? setState(() {
                          isScanned = true;
                          itemCodeController.text = itemCode;
                        })
                      : Container();
                }),
            SizedBox(height: 15),
            isScanned == true
                ? _ui.textFieldTransIcon(
              context: context,
              controller: itemCodeController,
              icon: MdiIcons.barcode,
              color: Theme.of(context).primaryColor,
            )
                : Container(),
          ],
        ),
      ),
      isScanned == true
          ? Container(
              child: FutureBuilder(
                  future: _fireStoreDB.getStocksItem(
                      itemID: itemCodeController.text),
                  builder: (context, AsyncSnapshot<ItemDetails> itemDetails) {
                    itemDetails.hasData
                        ? Future.microtask(() => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                      title: "Item Details",
                                      itemID: itemCodeController.text,
                                      itemDetails: itemDetails,
                                      currentPage: ItemDetailedView(
                                        isDesktop: isDesktop,
                                        itemID: itemCodeController.text,
                                        itemDetails: itemDetails,
                                      ),
                                    ))))
                        : Container();
                    return Container();
                  }),
            )
          : Container(),
    ];
  }
}
