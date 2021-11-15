import 'package:ags_ims/core/models/item_records.dart';
import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:ags_ims/views/home_pages/records/item_record_card.dart';
import 'package:flutter/material.dart';

class RecordsSold extends StatefulWidget {
  final String itemID;
  final bool isDesktop;

  const RecordsSold({Key key, this.itemID, this.isDesktop})
      : super(key: key);

  @override
  _RecordsSoldState createState() => _RecordsSoldState();
}

class _RecordsSoldState extends State<RecordsSold> {
  final _ui = locator<UI>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _fireStoreDB = locator<FireStoreDBService>();
  final _userProfile = locator<UserProfileViewModel>();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(bottom: 64),
      child: FutureBuilder(
        future: _fireStoreDB.getItemSoldRecords(itemID: widget.itemID),
        builder: (context, AsyncSnapshot<List<ItemRecords>> itemRecords) {
          return itemRecords.hasData ? ListView.builder(
            shrinkWrap: true,
            itemCount: itemRecords.data.length,
            itemBuilder: (context, i) {
              return ItemRecordCard(
                itemID: widget.itemID,
                itemRecords: itemRecords.data[i],
                isDesktop: widget.isDesktop,
              );
            },
          ) : Container();
        },
      ),
    );
  }
}