// ignore_for_file: public_member_api_docs
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as print_widget;
import 'package:printing/printing.dart';

class PrintPreviewPage extends StatefulWidget {
  const PrintPreviewPage({Key key}) : super(key: key);

  @override
  _PrintPreviewPageState createState() => _PrintPreviewPageState();
}

class _PrintPreviewPageState extends State<PrintPreviewPage> {
  final doc = print_widget.Document();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: PdfPreview(
        build: (format) => _generatePdf(format, "Sample"),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format, String title) async {
    final doc = print_widget.Document();

    doc.addPage(print_widget.Page(
        pageFormat: PdfPageFormat.a4,
        build: (print_widget.Context context) {
          return print_widget.Center(
            child: print_widget.Text('Hello World'),
          ); // Center
        }));

    return doc.save();
  }
}
