// ignore_for_file: prefer_const_constructors, unnecessary_new, sized_box_for_whitespace

import 'dart:io';
import 'dart:typed_data';

import 'package:ags_ims/core/models/item_details.dart';
import 'package:ags_ims/core/view_models/item_view_model.dart';
import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:image/image.dart' as image;
import 'package:barcode_image/barcode_image.dart';

class UpdateItem extends StatefulWidget {
  final String itemID;
  final bool isDesktop;

  const UpdateItem({Key key, this.itemID, this.isDesktop}) : super(key: key);

  @override
  _UpdateItemState createState() => _UpdateItemState();
}

class _UpdateItemState extends State<UpdateItem> {
  final _ui = locator<UI>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _fireStoreDB = locator<FireStoreDBService>();
  final _userProfile = locator<UserProfileViewModel>();
  final _itemViewModel = locator<ItemViewModel>();

  bool isDesktop;
  bool isMobile;
  bool isTablet;

  bool barCodeGenerated = false;
  bool isItemImageChanged = false;

  TextEditingController itemNameInputController;
  TextEditingController itemPriceInputController;
  TextEditingController itemCountInputController;

  File itemImage, barCodeImage;
  ImageCache imageCache = new ImageCache();

  String itemID;

  @override
  initState() {
    //initializePrefs();
    itemNameInputController = new TextEditingController();
    itemPriceInputController = new TextEditingController();
    itemCountInputController = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInformation) {
      isDesktop =
          sizingInformation.deviceScreenType == DeviceScreenType.desktop;
      isMobile = sizingInformation.deviceScreenType == DeviceScreenType.mobile;
      isTablet = sizingInformation.deviceScreenType == DeviceScreenType.tablet;
      return Container(
        child: FutureBuilder(
            future: _fireStoreDB.getStocksItem(itemID: widget.itemID),
            builder: (context, AsyncSnapshot<ItemDetails> itemDetails) {
              return itemDetails.hasData ? Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          width: MediaQuery.of(context).size.width,
                          child: isDesktop || isMobile || isTablet
                              ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: mainContent(context: context, itemDetails: itemDetails),
                          )
                              : UI().deviceNotSupported(
                              context: context,
                              isDesktop: isDesktop,
                              content: "Device Not Supported"),
                        )),
                  ),
                  Positioned(
                    bottom: 20,
                    right: 20,
                    child: FloatingActionButton(
                      child: Icon(Icons.cloud_upload_outlined),
                      onPressed: () {
                        if (itemNameInputController.text != null &&
                            itemPriceInputController.text != null &&
                            itemCountInputController.text != null &&
                            isItemImageChanged
                            ? itemImage != null
                            : null) {
                          _itemViewModel.updateItem(
                            context: context,
                            itemID: itemDetails.data.itemID,
                            itemName:
                            itemNameInputController.text.toString().trim(),
                            itemPrice: int.parse(itemPriceInputController.text
                                .toString()
                                .trim()),
                            newItemImage:
                            isItemImageChanged == true ? itemImage : null,
                            itemImage: isItemImageChanged == false
                                ? itemDetails.data.itemImage
                                : null,
                            itemBarcodeImage: itemDetails.data.itemBarcodeImage,
                            itemCode: itemDetails.data.itemCode,
                            itemCount: int.parse(itemCountInputController.text
                                .toString()
                                .trim()),
                          );
                        } else {
                          _baseUtils.snackBarError(
                              context: context,
                              content: "Make sure all fields were filled in.");
                        }
                      },
                    ),
                  ),
                ],
              ) : Container();
            }),
      );
    });
  }

  List<Widget> mainContent({BuildContext context, AsyncSnapshot<ItemDetails> itemDetails}) {
    itemNameInputController.text = itemDetails.hasData ? itemDetails.data.itemName : '';
    itemPriceInputController.text = itemDetails.hasData ? itemDetails.data.itemPrice.toString() : '';
    itemCountInputController.text = itemDetails.hasData ? itemDetails.data.itemCount.toString() : '';
    return [
      _ui.headlineLarge(
          context: context,
          content: "Update Item",
          color: Theme.of(context).primaryColor,
          isDesktop: isDesktop),
      SizedBox(
        height: 15,
      ),
      _ui.subheadMedium(
          context: context,
          content: "You can edit the item name, item image, price and stocks.",
          color: Colors.grey,
          isDesktop: isDesktop),
      SizedBox(
        height: 15,
      ),
      Divider(),
      _ui.textFormField(
          context: context,
          controller: itemNameInputController,
          keyboardType: TextInputType.text,
          label: "Item Name",
          icon: MdiIcons.shape,
          color: null,
          autoFocus: false),
      _ui.textFormField(
          context: context,
          controller: itemPriceInputController,
          keyboardType: TextInputType.number,
          label: "Item Price",
          prefixText: 'Php ',
          icon: MdiIcons.tag,
          color: null,
          autoFocus: false),
      _ui.textFormField(
          context: context,
          controller: itemCountInputController,
          keyboardType: TextInputType.number,
          label: "Item Count",
          icon: MdiIcons.numericPositive1,
          color: null,
          autoFocus: false),
      SizedBox(
        height: 15,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.hardEdge,
              child: isItemImageChanged == false || itemImage == null
                  ? Image.network(
                      itemDetails.data.itemImage,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                  : Image.file(
                      itemImage,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          _ui.outlinedButtonIcon(
            context: context,
            label: "Change Image",
            backgroundColor: Theme.of(context).colorScheme.background,
            foregroundColor: Theme.of(context).colorScheme.primary,
            icon: Icons.photo_rounded,
            function: () async {
              itemImage = await _baseUtils.imageProcessor(
                  context: context, ratioY: 4, ratioX: 4);
              setState(() {
                isItemImageChanged = true;
                _baseUtils.snackBarNoProgress(
                    context: context, content: "Image Loaded");
              });
            },
          ),
        ],
      ),
      SizedBox(
        height: 15,
      ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              clipBehavior: Clip.hardEdge,
              child: Image.network(
                itemDetails.data.itemBarcodeImage,
                height: 100,
                width: 100,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ],
      ),
    ];
  }
}
