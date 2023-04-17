import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import '../../../core/models/invoice_model.dart';

class InvoiceEntity {
  static const String className = 'Invoice';
  static const String id = 'objectId';

  InvoiceModel toModel(ParseObject parseObject) {
    InvoiceModel model = InvoiceModel(
      id: parseObject.objectId!,
    );
    return model;
  }

  Future<ParseObject> toParse(InvoiceModel model) async {
    final parseObject = ParseObject(InvoiceEntity.className);
    parseObject.objectId = model.id;

    return parseObject;
  }
}
