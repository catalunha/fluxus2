import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

import 'b4a_exception.dart';

class InitBack4app {
  Future<bool> init() async {
    try {
      const keyApplicationId = 'DJORW0khdQmM9ZrmDt2gKOrVfPHdYFlJkRRY51I1';
      const keyClientKey = '1a84GqtZaTHeVs1UL3UknN0qqcDmfFnwG3LxL2v6';
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
      print('+++ InitBack4app.init');
      print(e);
      print('--- InitBack4app.init');
      throw B4aException('Erro em inicializar o banco de dados',
          where: 'InitBack4app.init');
    }
  }
}
