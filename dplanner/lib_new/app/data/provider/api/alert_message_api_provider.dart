import '../../model/alert-message/alert_message.dart';
import '../../model/common_response.dart';
import 'base_api_provider.dart';

class AlertMessageApiProvider extends BaseApiProvider {
  static const int _defaultSearchMonths = 1;

  Future<List<AlertMessage>> getAlertMessages() async {
    var response =
        await get("/messages", query: {"months": _defaultSearchMonths}) as CommonResponse;
    var jsonList = response.data as List<Map<String, dynamic>>;

    return jsonList.map((message) => AlertMessage.fromJson(message)).toList();
  }

  void markAsRead({required int messageId}) async {
    await patch("/messages/$messageId", null);
  }
}
