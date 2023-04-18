import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../core/models/event_model.dart';

class EventPrintPage extends StatelessWidget {
  final List<EventModel> modelList;
  const EventPrintPage({
    Key? key,
    required this.modelList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório'),
      ),
      body: PdfPreview(
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        pdfFileName: 'Event',
        build: (format) => makePdf(),
      ),
    );
  }

  Future<Uint8List> makePdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.copyWith(
          marginTop: 1.0 * PdfPageFormat.cm,
          marginLeft: 1.0 * PdfPageFormat.cm,
          marginRight: 1.0 * PdfPageFormat.cm,
          marginBottom: 1.0 * PdfPageFormat.cm,
        ),
        orientation: pw.PageOrientation.portrait,
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        footer: (pw.Context context) => footerPage(context),
        build: (pw.Context context) => <pw.Widget>[
          pw.Header(
            level: 1,
            child: pw.Text('Relatório de eventos'),
          ),
          ...body(),
        ],
      ),
    );

    return await pdf.save();
  }

  body() {
    List<pw.Widget> lineList = [];
    for (var model in modelList) {
      lineList.add(userBody(model));
    }

    return lineList;
  }

  userBody(EventModel model) {
    final dateFormat = DateFormat('dd/MM/y HH:mm');

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(children: [
          pw.SizedBox(width: 10),
          pw.Expanded(
              child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('id: ${model.id}'),
              pw.Text(
                  'Atendimentos: ${model.attendances?.map((e) => e.id).toList().join(', ')}'),
              pw.Text('Status: ${model.status?.name}'),
              pw.Text('Sala: ${model.room?.name}'),
              pw.Text(
                  'Inicio: ${model.start != null ? dateFormat.format(model.start!) : "..."}'),
              pw.Text(
                  'Fim: ${model.end != null ? dateFormat.format(model.end!) : "..."}'),
              pw.Text('Histórico: ${model.history}'),
            ],
          ))
        ]),
        pw.Divider(),
      ],
    );
  }

  footerPage(context) {
    final dateFormat = DateFormat('dd/MM/y HH:mm');

    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
      decoration: const pw.BoxDecoration(
          border: pw.Border(
              top: pw.BorderSide(width: 1.0, color: PdfColors.black))),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Fluxus - ${dateFormat.format(DateTime.now())}',
            style: const pw.TextStyle(fontSize: 10),
          ),
          pw.Text(
            'Pág.: ${context.pageNumber} de ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}
