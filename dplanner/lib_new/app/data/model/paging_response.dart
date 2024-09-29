class PagingResponse {
  List<dynamic> content;
  int page;
  int size;
  bool hasNext;

  PagingResponse(
      {required this.content,
      required this.page,
      required this.size,
      required this.hasNext});

  PagingResponse.fromJson(Map<String, dynamic> json)
      : content = json["content"],
        page = json["page"],
        size = json["size"],
        hasNext = json["hasNext"];
}
