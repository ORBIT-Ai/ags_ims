// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:ags_ims/core/models/item_details.dart';
import 'package:ags_ims/core/view_models/item_view_model.dart';
import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:ags_ims/views/home_page.dart';
import 'package:ags_ims/views/home_pages/stocks/item_details.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ItemCard extends StatefulWidget {
  final String itemID;
  final bool isDesktop;

  const ItemCard({Key key, this.itemID, this.isDesktop}) : super(key: key);

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  final _ui = locator<UI>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _fireStoreDB = locator<FireStoreDBService>();
  final _userProfile = locator<UserProfileViewModel>();
  final _itemViewModel = locator<ItemViewModel>();

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.only(right: 10),
      child: FutureBuilder(
        future: _fireStoreDB.getStocksItem(itemID: widget.itemID),
        builder: (context, AsyncSnapshot<ItemDetails> itemDetails) {
          return itemDetails.hasData
              ? GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePage(
                            title: "Item Details",
                            itemID: widget.itemID,
                            itemDetails: itemDetails,
                            currentPage: ItemDetailedView(
                              isDesktop: widget.isDesktop,
                              itemID: widget.itemID,
                              itemDetails: itemDetails,
                            ),
                          ),
                        ));
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: itemDetails.data.itemImage != null
                                ? Image.network(
                                    itemDetails.data.itemImage,
                                    width: widget.isDesktop ? 150 : 100,
                                    height: widget.isDesktop ? 150 : 100,
                                    filterQuality: FilterQuality.low,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace stackTrace) {
                                      return Container(
                                        width: widget.isDesktop ? 150 : 100,
                                        height: widget.isDesktop ? 150 : 100,
                                        color:
                                            Theme.of(context).primaryColorLight,
                                        child: Icon(
                                          Icons.image_not_supported_rounded,
                                          size: 18,
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                        ),
                                      );
                                    },
                                  )
                                : Container(
                                    width: widget.isDesktop ? 150 : 100,
                                    height: widget.isDesktop ? 150 : 100,
                                    color: Theme.of(context).primaryColorLight,
                                    child: Icon(
                                      Icons.image_not_supported_rounded,
                                      size: 18,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                  ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: widget.isDesktop ? 600 : 200,
                                child: _ui.headlineSmall(
                                    context: context,
                                    content: itemDetails.data.itemName,
                                    color: null,
                                    isDesktop: widget.isDesktop),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              _ui.textIcon(
                                context: context,
                                content:
                                    'PHP ${itemDetails.data.itemPrice.toString()}',
                                icon: MdiIcons.tag,
                                contentColor: Colors.grey,
                                iconColor: Colors.grey,
                                ratio: 'small',
                                isDesktop: widget.isDesktop,
                              ),
                              _ui.textIcon(
                                context: context,
                                content: itemDetails.data.itemCode,
                                icon: MdiIcons.barcode,
                                contentColor: Colors.grey,
                                iconColor: Colors.grey,
                                ratio: 'small',
                                isDesktop: widget.isDesktop,
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 80, top: 20, bottom: 20, right: 20,),
                            child: _ui.iconButton(
                              context: context,
                              iconColor: Theme.of(context).primaryColor,
                              icon: Icons.download_rounded,
                              ratio: "medium",
                              function: () {
                                _baseUtils.downloadImage(
                                    url: itemDetails.data.itemBarcodeImage,
                                    code: itemDetails.data.itemCode);
                              },
                              isDesktop: true,
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                    ],
                  ),
                )
              : Container();
        },
      ),
    );
  }
}
