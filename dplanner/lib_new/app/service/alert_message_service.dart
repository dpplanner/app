import 'package:get/get.dart';

import '../data/model/alert-message/alert_message.dart';
import '../data/provider/api/alert_message_api_provider.dart';

class AlertMessageService extends GetxService {
  final AlertMessageApiProvider alertMessageApiProvider =
      Get.find<AlertMessageApiProvider>();

  Future<List<AlertMessage>> getAlertMessages() async {
    return await alertMessageApiProvider.getAlertMessages();
  }

  Future<void> markAsRead({required int messageId}) async {
    await alertMessageApiProvider.markAsRead(messageId: messageId);
  }
}
