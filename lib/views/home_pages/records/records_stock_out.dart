import 'package:ags_ims/core/models/item_records.dart';
import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:ags_ims/views/home_pages/records/item_record_card.dart';
import 'package:flutter/material.dart';

class RecordsStockOut extends StatefulWidget {
  final String itemID;
  final bool isDesktop;

  const RecordsStockOut({Key key, this.itemID, this.isDesktop})
      : super(key: key);

  @override
  _RecordsStockOutState createState() => _RecordsStockOutState();
}

class _RecordsStockOutState extends State<RecordsStockOut> {
  final _ui = locator<UI>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _fireStoreDB = locator<FireStoreDBService>();
  final _userProfile = locator<UserProfileViewModel>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 56),
      child: FutureBuilder(
        future: _fireStoreDB.getItemStockOutRecords(itemID: widget.itemID),
        builder: (context, AsyncSnapshot<List<ItemRecords>> itemRecords) {
          return itemRecords.hasData ? ListView.builder(
            shrinkWrap: true,
            reverse: true,
            itemCount: itemRecords.data.length,
            itemBuilder: (context, i) {
              return itemRecords.data.isNotEmpty ? ItemRecordCard(
                itemID: widget.itemID,
                itemRecords: itemRecords.data[i],
                isDesktop: widget.isDesktop,
              ) : Container();
            },
          ) : Container();
        },
      ),
    );
  }
}
