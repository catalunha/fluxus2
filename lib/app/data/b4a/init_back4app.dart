import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'b4a_exception.dart';

class InitBack4app {
  Future<bool> init() async {
    const keyApplicationIdDartDefine =
        String.fromEnvironment('keyApplicationId');
    const keyClientKeyDartDefine = String.fromEnvironment('keyClientKey');
    try {
      const keyApplicationId = keyApplicationIdDartDefine;
      const keyClientKey = keyClientKeyDartDefine;
      const keyParseServerUrl = 'https://parseapi.back4app.com';
      await Parse().initialize(
        keyApplicationId,
        keyParseServerUrl,
        clientKey: keyClientKey,
        autoSendSessionId: true,
        debug: true,
      );
      ParseResponse healthCheck = (await Parse().healthCheck());
      if (healthCheck.success) {
        return true;
      }
      throw Exception();
    } catch (e) {
      //print('+++ InitBack4app.init');
      //print(e);
      //print('--- InitBack4app.init');
      throw B4aException('Erro em inicializar o banco de dados',
          where: 'InitBack4app.init');
    }
  }
}
