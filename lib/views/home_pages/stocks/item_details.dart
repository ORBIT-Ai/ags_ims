// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

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

class ItemDetailedView extends StatefulWidget {
  final String itemID;
  final bool isDesktop;

  const ItemDetailedView({Key key, this.itemID, this.isDesktop})
      : super(key: key);

  @override
  _ItemDetailedViewState createState() => _ItemDetailedViewState();
}

class _ItemDetailedViewState extends State<ItemDetailedView> {
  final _ui = locator<UI>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _fireStoreDB = locator<FireStoreDBService>();
  final _userProfile = locator<UserProfileViewModel>();
  final _itemViewModel = locator<ItemViewModel>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height + 100,
        padding: EdgeInsets.all(20),
        child: FutureBuilder(
            future: _fireStoreDB.getStocksItem(itemID: widget.itemID),
            builder: (context, AsyncSnapshot<ItemDetails> itemDetails) {
              return itemDetails.hasData
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: ClipRRect(
                            clipBehavior: Clip.hardEdge,
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              itemDetails.data.itemImage,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _ui.headlineMedium(
                            context: context,
                            content: itemDetails.data.itemName,
                            color: null,
                            isDesktop: widget.isDesktop),
                        SizedBox(
                          height: 10,
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
                        SizedBox(
                          height: 10,
                        ),
                        _ui.textIcon(
                          context: context,
                          content:
                              '${itemDetails.data.itemCount.toString()} stocks remaining',
                          icon: MdiIcons.archive,
                          contentColor: Colors.grey,
                          iconColor: Colors.grey,
                          ratio: 'small',
                          isDesktop: widget.isDesktop,
                        ),
                        SizedBox(
                          height: 10,
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
                        SizedBox(
                          height: 20,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            itemDetails.data.itemBarcodeImage,
                            height: widget.isDesktop ? 150 : 100,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FloatingActionButton.extended(
                              label: Text('Add Stock'),
                              icon: Icon(MdiIcons.plus),
                              onPressed: () {},
                            ),
                            FloatingActionButton.extended(
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              backgroundColor: Theme.of(context).primaryColor,
                              label: Text('Delete'),
                              icon: Icon(MdiIcons.delete),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container();
            }),
      ),
    );
  }
}
