import '../../../utils/url_utils.dart';
import '../../model/alert-message/alert_message.dart';
import '../../model/common_response.dart';
import 'base_api_provider.dart';

class AlertMessageApiProvider extends BaseApiProvider {
  static const int _defaultSearchMonths = 1;

  Future<List<AlertMessage>> getAlertMessages() async {
    var queryString = UrlUtils.toQueryString({"months": _defaultSearchMonths});
    var response = await get("/messages$queryString") as CommonResponse;
    var jsonList = response.body!.data["responseList"] as List<dynamic>;

    return jsonList.map((message) => AlertMessage.fromJson(message)).toList();
  }

  Future<void> markAsRead({required int messageId}) async {
    await patch("/messages/$messageId", null);
  }
}
