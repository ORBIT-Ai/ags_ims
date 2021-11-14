// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:ags_ims/core/models/item_details.dart';
import 'package:ags_ims/core/models/item_records.dart';
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

class ItemRecordCard extends StatefulWidget {
  final String itemID;
  final bool isDesktop;
  final ItemRecords itemRecords;

  const ItemRecordCard({Key key, this.itemID, this.isDesktop, this.itemRecords}) : super(key: key);

  @override
  _ItemRecordCardState createState() => _ItemRecordCardState();
}

class _ItemRecordCardState extends State<ItemRecordCard> {
  final _ui = locator<UI>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _fireStoreDB = locator<FireStoreDBService>();
  final _userProfile = locator<UserProfileViewModel>();
  final _itemViewModel = locator<ItemViewModel>();

  @override
  Widget build(BuildContext context) {
    return widget.itemRecords != null ? Container(
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                /*
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 48,
                  height: 48,
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: Theme.of(context).primaryColor,
                    size: 18,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
               */
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: widget.isDesktop ? 600 : 300,
                      child: _ui.headlineMedium(
                          context: context,
                          content: widget.itemRecords.itemRecordsInfo['description'],
                          color: null,
                          isDesktop: widget.isDesktop),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    _ui.textIcon(
                      context: context,
                      content: widget.itemRecords.itemRecordsInfo['date'],
                      icon: Icons.calendar_today_rounded,
                      contentColor: Colors.grey,
                      iconColor: Theme.of(context).primaryColor,
                      ratio: 'small',
                      isDesktop: widget.isDesktop,
                    ),
                    _ui.textIcon(
                      context: context,
                      content: widget.itemRecords.itemRecordsInfo['time'],
                      icon: Icons.access_time_rounded,
                      contentColor: Colors.grey,
                      iconColor: Theme.of(context).primaryColor,
                      ratio: 'small',
                      isDesktop: widget.isDesktop,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
        ],
      ),
    ) : Container();
  }
}
