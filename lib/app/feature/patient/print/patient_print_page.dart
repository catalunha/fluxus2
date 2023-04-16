import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../core/models/patient_model.dart';

class PatientPrintPage extends StatelessWidget {
  final List<PatientModel> modelList;
  const PatientPrintPage({
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
        pdfFileName: 'Patient',
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
            child: pw.Text('Relatório de pacientes'),
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

  userBody(PatientModel model) {
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
              pw.Text('email: ${model.email}'),
              pw.Text('Nome: ${model.name}'),
              pw.Text('Nome curto: ${model.nickname}'),
              pw.Text('CPF: ${model.cpf}'),
              pw.Text('Telefone: ${model.phone}'),
              pw.Text(
                  'Sexo: ${model.isFemale ?? true ? "Feminino" : "Masculino"}'),
              pw.Text(
                  'Nome: ${model.birthday != null ? dateFormat.format(model.birthday!) : "..."}'),
              pw.Text('Endereço: ${model.address}'),
              pw.Text(
                  'Regiao: ${model.region?.uf}. ${model.region?.city}${model.region?.name}'),
              pw.Text(
                  'Familiares: ${model.family?.map((e) => e.name).toList().join(', ')}'),
              pw.Text(
                  'Planos de Saude: ${model.healthPlans?.map((e) => e.code).toList().join(', ')}'),
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
