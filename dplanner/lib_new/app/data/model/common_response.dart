class CommonResponse {
  String status;
  String message;
  dynamic data;

  CommonResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  CommonResponse.fromJson(Map<String, dynamic> json)
      : status = json['status'],
        message = json['message'],
        data = json['data'];
}
