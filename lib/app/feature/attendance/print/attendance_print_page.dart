import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../core/models/attendance_model.dart';

class AttendancePrintPage extends StatelessWidget {
  final List<AttendanceModel> modelList;
  const AttendancePrintPage({
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
        pdfFileName: 'Attendance',
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
            child: pw.Text('Relatório de Atendimentos'),
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

  userBody(AttendanceModel model) {
    final dateFormat = DateFormat('dd/MM/y');
    final dateFormatHM = DateFormat('dd/MM/y HH:mm');
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(children: [
          pw.SizedBox(width: 10),
          pw.Expanded(
              child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Id: ${model.id}'),
              pw.Text('Profissional: ${model.professional?.nickname}'),
              pw.Text('Procedimento: ${model.procedure?.code}'),
              pw.Text('Paciente: ${model.patient?.nickname}'),
              pw.Text('Plano de saúde: ${model.healthPlan?.code}'),
              pw.Text(
                  'Tipo de Plano de saúde: ${model.healthPlan?.healthPlanType?.name}'),
              pw.Text('Autorização. Código: ${model.authorizationCode}'),
              pw.Text(
                  'Autorização. Criada em: ${model.authorizationDateCreated == null ? '...' : dateFormat.format(model.authorizationDateCreated!)}'),
              pw.Text(
                  'Autorização. Limitada em: ${model.authorizationDateLimit == null ? '...' : dateFormat.format(model.authorizationDateLimit!)}'),
              pw.Text(
                  'Atendida em: ${model.attendance == null ? '...' : dateFormatHM.format(model.attendance!)}'),
              pw.Text('Descrição: ${model.description}'),
              pw.Text(
                  'Presença confirmada em: ${model.confirmedPresence == null ? '...' : dateFormatHM.format(model.confirmedPresence!)}'),
              pw.Text('Status: ${model.status?.name}'),
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
