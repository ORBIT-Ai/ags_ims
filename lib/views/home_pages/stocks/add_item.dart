// ignore_for_file: prefer_const_constructors, unnecessary_new, sized_box_for_whitespace

import 'dart:io';
import 'dart:typed_data';

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

class AddItem extends StatefulWidget {
  const AddItem({Key key}) : super(key: key);

  @override
  _AddItemState createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
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

  TextEditingController itemNameInputController;
  TextEditingController itemPriceInputController;
  TextEditingController itemCountInputController;

  File imageFile, barCodeImage;
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
      return Stack(
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
                      children: mainContent(context: context),
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
                    barCodeImage != null &&
                    itemID != null) {
                  _itemViewModel.addItem(
                    context: context,
                    itemID: itemID,
                    itemName: itemNameInputController.text.toString().trim(),
                    itemPrice: int.parse(itemPriceInputController.text.toString().trim()),
                    itemImage: barCodeImage,
                    itemCode: itemID,
                    itemCount: int.parse(itemCountInputController.text.toString().trim()),
                  );
                } else {
                  _baseUtils.snackBarError(context: context, content: "Make sure all fields are filled in.");
                }
              },
            ),
          ),
        ],
      );
    });
  }

  List<Widget> mainContent({BuildContext context}) {
    return [
      _ui.headlineLarge(
          context: context,
          content: "Add Item",
          color: Theme.of(context).primaryColor,
          isDesktop: isDesktop),
      SizedBox(
        height: 15,
      ),
      _ui.subheadMedium(
          context: context,
          content:
              "Fill the specific fields, you can add an image of this item and don't forget to generate the barcode.",
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
          imageFile == null
              ? Container()
              : Container(
                  width: 100,
                  height: 300,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    clipBehavior: Clip.hardEdge,
                    child: imageFile == null
                        ? Container(
                            color: Theme.of(context).primaryColorLight,
                            height: 100,
                            width: 100,
                            child: Icon(
                              Icons.image_rounded,
                              size: 36,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        : Image.file(
                            imageFile,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
          imageFile == null
              ? Container()
              : SizedBox(
                  height: 15,
                ),
          _ui.outlinedButtonIcon(
            context: context,
            label: imageFile != null ? "Change Image" : "Add Item Image",
            backgroundColor: Theme.of(context).colorScheme.background,
            foregroundColor: Theme.of(context).colorScheme.primary,
            icon: Icons.photo_rounded,
            function: () async {
              imageFile = await _baseUtils.imageProcessor(
                  context: context, ratioY: 4, ratioX: 4);
              setState(() {
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
          barCodeGenerated
              ? Container(
                  width: 100,
                  height: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    clipBehavior: Clip.hardEdge,
                    child: barCodeImage == null
                        ? Container(
                            color: Theme.of(context).primaryColorLight,
                            height: 100,
                            width: 100,
                            child: Icon(
                              MdiIcons.barcode,
                              size: 24,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                        : Image.file(
                            barCodeImage,
                            height: 100,
                            width: 100,
                            fit: BoxFit.fitHeight,
                          ),
                  ),
                )
              : Container(),
          barCodeImage == null
              ? Container()
              : SizedBox(
                  height: 15,
                ),
          _ui.outlinedButtonIcon(
            context: context,
            label: barCodeImage != null
                ? "Regenerate Barcode"
                : "Generate Barcode",
            backgroundColor: Theme.of(context).colorScheme.background,
            foregroundColor: Theme.of(context).colorScheme.primary,
            icon: MdiIcons.barcode,
            function: () async {
              // Create an image
              final img = image.Image(300, 120);

              // Fill it with a solid color (white)
              image.fill(img, image.getColor(255, 255, 255));

              itemID = _baseUtils.timeStamp().toString();
              // Draw the barcode
              drawBarcode(
                  img,
                  Barcode.code128(
                    useCode128C: true,
                  ),
                  itemID,
                  font: image.arial_48,
                  textPadding: 1);

              //File('barcode.png').writeAsBytesSync(image.encodePng(img));
              final data = image.encodePng(img);
              Directory tempDir = await getExternalStorageDirectory();
              String tempPath = tempDir.path;
              String barcodeName = _baseUtils.timeStamp().toString();
              XFile barcodeFile = XFile.fromData(
                Uint8List.fromList(data),
                name: '$barcodeName.png',
                mimeType: 'image/png',
              );
              await barcodeFile.saveTo('$tempPath/$barcodeName.png');
              barCodeImage = File('$tempPath/$barcodeName.png');
              setState(() {
                barCodeGenerated = true;
                _baseUtils.snackBarNoProgress(
                    context: context, content: "Image Loaded");
              });
            },
          ),
        ],
      ),
    ];
  }
}
