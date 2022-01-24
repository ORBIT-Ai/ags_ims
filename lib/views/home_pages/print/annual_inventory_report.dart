// ignore_for_file: public_member_api_docs, prefer_const_constructors, avoid_print
import 'dart:typed_data';

import 'package:ags_ims/core/models/item_details.dart';
import 'package:ags_ims/core/models/item_sold.dart';
import 'package:ags_ims/core/models/user_details.dart';
import 'package:ags_ims/core/view_models/user_profile_view_model.dart';
import 'package:ags_ims/services/auth_service.dart';
import 'package:ags_ims/services/firestore_db_service.dart';
import 'package:ags_ims/services/service_locator.dart';
import 'package:ags_ims/utils/base_utils.dart';
import 'package:ags_ims/utils/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as print_widget;
import 'package:printing/printing.dart';

class AnnualInventoryReport extends StatefulWidget {
  const AnnualInventoryReport({
    Key key,
  }) : super(key: key);
  final String title = "Annual Inventory Report";

  @override
  _AnnualInventoryReportState createState() => _AnnualInventoryReportState();
}

class _AnnualInventoryReportState extends State<AnnualInventoryReport> {
  final _ui = locator<UI>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _fireStoreDB = locator<FireStoreDBService>();
  final _userProfile = locator<UserProfileViewModel>();

  final doc = print_widget.Document();

  double totalSoldAmount = 0.0;
  double totalStockAmount = 0.0;
  double soldAmount = 0.0;
  int sold = 0;

  @override
  void initState() {
    _fireStoreDB.getItemSold(collectiveTerm: "yearly").then((soldValue) {
      for (int i = 0; i < soldValue.length; i++) {
        if (soldValue != null) {
          setState(() {
            sold = sold + soldValue[i].itemRecordsInfo['itemCount'];
            print("SOLD: $sold");
            totalSoldAmount = totalSoldAmount +
                soldValue[i].itemRecordsInfo['itemTotalAmount'];
            print("TOTAL SOLD AMOUNT: $totalSoldAmount");
          });
        }
      }
    });
    _fireStoreDB.getStocks().then((stockValue) {
      for (int i = 0; i < stockValue.length; i++) {
        if (stockValue != null) {
          setState(() {
            totalStockAmount = totalStockAmount +
                (stockValue[i].itemCount * stockValue[i].itemPrice);
            print("Total Amount $totalStockAmount");
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder(
          future: _fireStoreDB.getUserDetails(userID: _auth.getCurrentUserID()),
          builder: (context, AsyncSnapshot<UserDetails> userDetails) {
            return Container(
              child: FutureBuilder(
                  future: _fireStoreDB.getStocks(),
                  builder:
                      (context, AsyncSnapshot<List<ItemDetails>> itemDetails) {
                    return itemDetails.hasData
                        ? Container(
                            child: FutureBuilder(
                                future: _fireStoreDB.getItemSold(
                                    collectiveTerm: "yearly"),
                                builder: (context,
                                    AsyncSnapshot<List<ItemSold>> itemSold) {
                                  return PdfPreview(
                                    canChangeOrientation: false,
                                    canChangePageFormat: false,
                                    canDebug: false,
                                    build: (format) => generatePdf(
                                        format,
                                        "Annual Stocks Report",
                                        itemDetails,
                                        userDetails,
                                        itemSold),
                                  );
                                }),
                          )
                        : Container();
                  }),
            );
          },
        ));
  }

  Future<Uint8List> generatePdf(
      PdfPageFormat format,
      String title,
      AsyncSnapshot<List<ItemDetails>> itemDetails,
      AsyncSnapshot<UserDetails> userDetails,
      AsyncSnapshot<List<ItemSold>> itemSold) async {
    final doc = print_widget.Document();

    doc.addPage(print_widget.Page(
        pageFormat: PdfPageFormat.a4,
        build: (print_widget.Context context) {
          return print_widget.Container(
              child: print_widget.Column(
            children: [
              print_widget.Text(
                widget.title,
                style: print_widget.TextStyle(fontSize: 18),
              ),
              print_widget.SizedBox(
                height: 20,
              ),
              print_widget.Table(
                  defaultVerticalAlignment:
                      print_widget.TableCellVerticalAlignment.full,
                  children: [
                    print_widget.TableRow(children: [
                      headlineRow(
                          text:
                              "Date: Year ${_baseUtils.currentYear()}"),
                    ]),
                    print_widget.TableRow(children: [
                      headlineRow(text: "Encoded by: AGS IMS"),
                    ]),
                  ]),
              print_widget.SizedBox(
                height: 20,
              ),
              print_widget.Table(
                  defaultVerticalAlignment:
                      print_widget.TableCellVerticalAlignment.full,
                  children: [
                    print_widget.TableRow(children: [
                      headlineRow(
                          text:
                              "Total Amount Sold: PHP ${totalSoldAmount.toString()}"),
                      headlineRow(
                          text:
                              "Total Value Stock IN Hand: PHP ${totalStockAmount.toString()}"),
                    ]),
                  ]),
              print_widget.SizedBox(
                height: 20,
              ),
              print_widget.Table(
                  columnWidths: {
                    0: print_widget.FlexColumnWidth(1),
                    1: print_widget.FlexColumnWidth(2),
                    2: print_widget.FlexColumnWidth(1),
                    3: print_widget.FlexColumnWidth(1),
                    4: print_widget.FlexColumnWidth(1),
                    5: print_widget.FlexColumnWidth(1),
                    6: print_widget.FlexColumnWidth(1),
                  },
                  border: print_widget.TableBorder.all(width: 1),
                  children: [
                    print_widget.TableRow(children: [
                      headerRow(text: "Item Code"),
                      headerRow(text: "Item Name"),
                      headerRow(text: "Item Price"),
                      headerRow(text: "Quantity IN Stock"),
                      headerRow(text: "Value Stock IN Hand"),
                      headerRow(text: "Purchased"),
                      headerRow(text: "Purchased Amount"),
                    ]),
                  ]),
              print_widget.ListView.builder(
                //itemCount: itemDetails.data.length,
                itemCount: 20,
                itemBuilder: (context, i) {
                  int soldTotal = 0;
                  return print_widget.Table(
                      columnWidths: {
                        0: print_widget.FlexColumnWidth(1),
                        1: print_widget.FlexColumnWidth(2),
                        2: print_widget.FlexColumnWidth(1),
                        3: print_widget.FlexColumnWidth(1),
                        4: print_widget.FlexColumnWidth(1),
                        5: print_widget.FlexColumnWidth(1),
                        6: print_widget.FlexColumnWidth(1),
                      },
                      border: print_widget.TableBorder.all(width: 1),
                      children: [
                        print_widget.TableRow(children: [
                          tableRow(text: itemDetails.data[i].itemCode),
                          tableRow(text: itemDetails.data[i].itemName),
                          tableRow(
                              text:
                                  'PHP ${itemDetails.data[i].itemPrice.toString()}'),
                          tableRow(
                              text:
                                  '${itemDetails.data[i].itemCount.toString()}'),
                          tableRow(
                              text:
                                  '${(itemDetails.data[i].itemCount * itemDetails.data[i].itemPrice).toString()}'),
                          itemSold.hasData
                              ? print_widget.ListView.builder(
                                  itemCount: itemSold.data.length,
                                  itemBuilder: (context, j) {
                                    return itemSold.data.indexWhere((element) =>
                                                itemSold.data[j].itemID ==
                                                itemDetails.data[i].itemID) >=
                                            0
                                        ? print_widget.Table(
                                            columnWidths: {
                                              0: print_widget.FlexColumnWidth(
                                                  1),
                                            },
                                            border:
                                                print_widget.TableBorder.all(
                                                    width: 1),
                                            children: [
                                              print_widget.TableRow(
                                                  verticalAlignment: print_widget
                                                      .TableCellVerticalAlignment
                                                      .middle,
                                                  children: [
                                                    print_widget.Center(
                                                        child: tableRow(
                                                            text: (itemSold
                                                                        .data[j]
                                                                        .itemRecordsInfo[
                                                                    "itemCount"])
                                                                .toString()))
                                                  ])
                                            ])
                                        : print_widget.Container();
                                  },
                                )
                              : print_widget.Container(),
                          itemSold.hasData
                              ? print_widget.ListView.builder(
                                  itemCount: itemSold.data.length,
                                  itemBuilder: (context, j) {
                                    return itemSold.data.indexWhere((element) =>
                                                itemSold.data[j].itemID ==
                                                itemDetails.data[i].itemID) >=
                                            0
                                        ? print_widget.Table(
                                            columnWidths: {
                                              0: print_widget.FlexColumnWidth(
                                                  1),
                                            },
                                            border:
                                                print_widget.TableBorder.all(
                                                    width: 1),
                                            children: [
                                              print_widget.TableRow(
                                                  verticalAlignment: print_widget
                                                      .TableCellVerticalAlignment
                                                      .middle,
                                                  children: [
                                                    print_widget.Center(
                                                        child: tableRow(
                                                            text: (itemSold
                                                                        .data[j]
                                                                        .itemRecordsInfo[
                                                                    "itemTotalAmount"])
                                                                .toString()))
                                                  ])
                                            ])
                                        : print_widget.Container();
                                  },
                                )
                              : print_widget.Container(),
                        ]),
                      ]);
                },
              ),
              print_widget.SizedBox(
                height: 20,
              ),
              print_widget.Table(
                  defaultVerticalAlignment:
                      print_widget.TableCellVerticalAlignment.full,
                  children: [
                    print_widget.TableRow(children: [
                      headlineRow(
                          text: "Date Printed: ${_baseUtils.currentDate()}"),
                      headlineRow(
                          text:
                              "User Account Name: ${userDetails.data.userName}"),
                    ]),
                    print_widget.TableRow(children: [
                      headlineRow(
                          text: "Time Printed: ${_baseUtils.currentTime()}"),
                      headlineRow(
                          text: "Position: ${userDetails.data.position}"),
                    ]),
                  ]),
            ],
          )); // Center
        }));

    return doc.save();
  }

  headlineRow({@required String text}) {
    return print_widget.Text(
      text,
      style: print_widget.TextStyle(fontSize: 10),
      textAlign: print_widget.TextAlign.left,
    );
  }

  headerRow({@required String text}) {
    return print_widget.Text(
      text,
      style: print_widget.TextStyle(fontSize: 10),
      textAlign: print_widget.TextAlign.center,
    );
  }

  tableRow({@required String text}) {
    return print_widget.Text(text, style: print_widget.TextStyle(fontSize: 8));
  }
}
