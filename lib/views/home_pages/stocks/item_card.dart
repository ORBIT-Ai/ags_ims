// ignore_for_file: prefer_const_constructors

import 'package:ags_ims/core/models/item_details.dart';
import 'package:ags_ims/core/view_models/item_view_model.dart';
import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
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
                    _baseUtils.snackBarNoProgress(
                        context: context, content: itemDetails.data.itemCode);
                  },
                  child: Column(
                    children: [
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              itemDetails.data.itemImage,
                              width: widget.isDesktop ? 150 : 100,
                              height: widget.isDesktop ? 150 : 100,
                              filterQuality: FilterQuality.medium,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _ui.headlineSmall(
                                  context: context,
                                  content: itemDetails.data.itemName,
                                  color: null,
                                  isDesktop: widget.isDesktop),
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
