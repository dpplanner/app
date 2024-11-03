import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:get/get_connect/http/src/status/http_status.dart';

class CommonResponse extends Response<dynamic> {
  @override
  final Request? request;

  @override
  final Map<String, String>? headers;

  @override
  final int? statusCode;

  @override
  final String? statusText;

  @override
  HttpStatus get status => HttpStatus(statusCode);

  @override
  bool get hasError => status.hasError;

  @override
  bool get isOk => !hasError;

  @override
  bool get unauthorized => status.isUnauthorized;

  @override
  final Stream<List<int>>? bodyBytes;

  @override
  final String? bodyString;

  @override
  final CommonResponseBody? body;

  CommonResponse.from(Response response)
      : request = response.request,
        statusCode = response.statusCode,
        bodyBytes = response.bodyBytes,
        bodyString = response.bodyString,
        statusText = response.statusText,
        headers = response.headers,
        body = response.body != null
            ? CommonResponseBody.fromJson(response.body)
            : null;
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
