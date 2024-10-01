import 'json_serializable.dart';

class PagingRequest extends JsonSerializable {
  int page;
  int size;

  PagingRequest({
    required this.page,
    required this.size
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "page": page,
      "size": size
    };
  }
}