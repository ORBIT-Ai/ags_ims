// ignore_for_file: public_member_api_docs, prefer_const_constructors, avoid_print, sized_box_for_whitespace, avoid_unnecessary_containers
import 'dart:io';
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

class BarcodePrint extends StatefulWidget {
  const BarcodePrint({
    Key key,
  }) : super(key: key);
  final String title = "Print Barcode";

  @override
  _BarcodePrintState createState() => _BarcodePrintState();
}

class _BarcodePrintState extends State<BarcodePrint> {
  final _ui = locator<UI>();
  final _auth = locator<Auth>();
  final _baseUtils = locator<BaseUtils>();
  final _fireStoreDB = locator<FireStoreDBService>();
  final _userProfile = locator<UserProfileViewModel>();

  final doc = print_widget.Document();

  int totalSoldAmount = 0;
  int totalStockAmount = 0;
  int soldAmount = 0;
  int sold = 0;

  @override
  void initState() {
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
                        ? PdfPreview(
                            canChangeOrientation: false,
                            canChangePageFormat: false,
                            canDebug: false,
                            build: (format) => generatePdf(
                              format,
                              "Annual Stocks Report",
                              itemDetails,
                              userDetails,
                            ),
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
  ) async {
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
                      headlineRow(text: "Encoded by: AGS IMS"),
                    ]),
                  ]),
              print_widget.SizedBox(
                height: 20,
              ),
              print_widget.Table(
                  columnWidths: {
                    0: print_widget.FlexColumnWidth(1),
                    1: print_widget.FlexColumnWidth(4),
                  },
                  border: print_widget.TableBorder.all(width: 1),
                  children: [
                    print_widget.TableRow(children: [
                      headerRow(text: "Item Name"),
                      headerRow(text: "Item Barcode"),
                    ]),
                  ]),
              print_widget.ListView.builder(
                itemCount: itemDetails.data.length,
                itemBuilder: (context, i) {
                  int soldTotal = 0;
                  return print_widget.Table(
                      columnWidths: {
                        0: print_widget.FlexColumnWidth(1),
                        1: print_widget.FlexColumnWidth(4),
                      },
                      border: print_widget.TableBorder.all(width: 1),
                      children: [
                        print_widget.TableRow(children: [
                          tableRow(text: itemDetails.data[i].itemName),
                          print_widget.GridView(crossAxisCount: 2, children: [

                          ]),
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
