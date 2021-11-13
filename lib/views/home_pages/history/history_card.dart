// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, sized_box_for_whitespace

import 'package:ags_ims/core/enums/history_types.dart';
import 'package:ags_ims/core/models/history.dart';
import 'package:ags_ims/core/models/item_details.dart';
import 'package:ags_ims/core/models/user_details.dart';
import 'package:ags_ims/core/view_models/history_view_model.dart';
import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HistoryCard extends StatefulWidget {
  const HistoryCard({Key key, this.historyID, this.isDesktop})
      : super(key: key);
  final String historyID;
  final bool isDesktop;

  @override
  _HistoryCardState createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  final _ui = locator<UI>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _fireStoreDB = locator<FireStoreDBService>();
  final _userProfile = locator<UserProfileViewModel>();
  final _historyViewModel = locator<HistoryViewModel>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
          future: _fireStoreDB.getHistory(historyID: widget.historyID),
          builder: (context, AsyncSnapshot<History> historyDetails) {
            String historyType = "";
            if(historyDetails.hasData){
              historyType = historyDetails.data.historyInfo['type'];
            }

            return historyDetails.hasData ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: FutureBuilder(
                    future: _fireStoreDB.getUserDetails(
                        userID: historyDetails.data.userID),
                    builder: (context,
                        AsyncSnapshot<UserDetails> userDetails) {
                      return Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: historyType ==
                                HistoryTypes.newUser
                                    .toString()
                                    .split('.')
                                    .last ||
                                historyType ==
                                    HistoryTypes.deletedUser
                                        .toString()
                                        .split('.')
                                        .last
                                ? userDetails.hasData ? Image.network(
                              userDetails.data.profileUrl,
                              width: widget.isDesktop ? 150 : 100,
                              height: widget.isDesktop ? 150 : 100,
                              filterQuality: FilterQuality.low,
                            ) : Container()
                                : FutureBuilder(
                              future: _fireStoreDB.getStocksItem(
                                  itemID: historyDetails
                                      .data.historyInfo['tagID']),
                              builder: (context,
                                  AsyncSnapshot<ItemDetails> itemDetails) {
                                return itemDetails.hasData ? Image.network(
                                  itemDetails.data.itemImage,
                                  width: widget.isDesktop ? 150 : 100,
                                  height: widget.isDesktop ? 150 : 100,
                                  filterQuality: FilterQuality.medium,
                                ) : Container();
                              },
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
                                    content: historyDetails.data.historyInfo['description'],
                                    color: null,
                                    isDesktop: widget.isDesktop),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              widget.isDesktop ? Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: historyInfoWidgets(historyType: historyType, userDetails: userDetails, historyDetails: historyDetails),
                              ) : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: historyInfoWidgets(historyType: historyType, userDetails: userDetails, historyDetails: historyDetails),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Divider(),
              ],
            ) : Container();
          }),
    );
  }

  List<Widget> historyInfoWidgets({@required historyType, @required AsyncSnapshot<UserDetails> userDetails, @required AsyncSnapshot<History> historyDetails}){
    return [
      historyType ==
          HistoryTypes.itemStockOut
              .toString()
              .split('.')
              .last ? _ui.textIcon(
        context: context,
        content:
        userDetails.hasData ? userDetails.data.userName : "",
        icon: Icons.person_rounded,
        contentColor: Colors.grey,
        iconColor: Theme.of(context).primaryColor,
        ratio: 'small',
        isDesktop: widget.isDesktop,
      ) : Container(),
      _ui.textIcon(
        context: context,
        content: historyDetails.data.historyInfo['date'],
        icon: Icons.calendar_today_rounded,
        contentColor: Colors.grey,
        iconColor: Theme.of(context).primaryColor,
        ratio: 'small',
        isDesktop: widget.isDesktop,
      ),
      _ui.textIcon(
        context: context,
        content: historyDetails.data.historyInfo['time'],
        icon: Icons.access_time_rounded,
        contentColor: Colors.grey,
        iconColor: Theme.of(context).primaryColor,
        ratio: 'small',
        isDesktop: widget.isDesktop,
      ),
    ];
  }
}
