import 'package:get/get_connect/http/src/response/response.dart';

class CommonResponse extends Response<CommonResponseBody> {
  @override
  CommonResponseBody? body;

  CommonResponse({
    required this.body
  });
}

class CommonResponseBody {
  String status;
  String? message;
  dynamic data;

  CommonResponseBody({
    required this.status,
    required this.message,
    required this.data,
  });

  CommonResponseBody.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        message = json['message'],
        data = json['data'];
}
