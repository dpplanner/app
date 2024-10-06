import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';

import '../../../utils/datetime_utils.dart';
import '../../../utils/url_utils.dart';
import '../../model/common_response.dart';
import '../../model/paging_request.dart';
import '../../model/paging_response.dart';
import '../../model/reservation/request/reservation_request.dart';
import '../../model/reservation/reservation.dart';
import 'base_api_provider.dart';

class ReservationApiProvider extends BaseApiProvider {
  Future<Reservation> getReservation({required int reservationId}) async {
    var response = await get("/reservations/$reservationId") as CommonResponse;
    return Reservation.fromJson(response.body!.data!);
  }

  Future<Reservation> createReservation(
      {required ReservationRequest request}) async {
    var response =
        await post("/reservations", request.toJson()) as CommonResponse;
    return Reservation.fromJson(response.body!.data!);
  }

  Future<Reservation> updateReservation(
      {required int reservationId, required ReservationRequest request}) async {
    var response =
        await put("/reservations/$reservationId/update", request.toJson())
            as CommonResponse;
    return Reservation.fromJson(response.body!.data!);
  }

  Future<void> cancelReservation(
      {required int reservationId, required ReservationRequest request}) async {
    await patch("/reservations/$reservationId/cancel", request.toJson());
  }

  Future<void> deleteReservation({required ReservationRequest request}) async {
    await deleteWithBody("/reservations", request.toJson());
  }

  Future<Reservation> returnReservation(
      {required int reservationId,
      required ReservationRequest request,
      required List<XFile>? images}) async {
    var formData = FormData({});

    formData.fields.addAll(request
        .toJson()
        .entries
        .map((entry) => MapEntry(entry.key, entry.value.toString()))
        .toList());

    formData.files.addAll(images!
        .map((image) =>
            MapEntry("files", MultipartFile(image, filename: image.name)))
        .toList());

    var response = await post("/reservations/$reservationId/return", formData)
        as CommonResponse;
    return Reservation.fromJson(response.body!.data!);
  }

  Future<List<Reservation>> getReservations(
      {required int resourceId,
      required DateTime startDateTime,
      required DateTime endDateTime}) async {
    var queryString = UrlUtils.toQueryString({
      "resourceId": resourceId,
      "start": DateTimeUtils.toFormattedString(startDateTime),
      "end": DateTimeUtils.toFormattedString(endDateTime)
    });

    var response =
        await get("/reservations/scheduler$queryString") as CommonResponse;
    var jsonList = response.body!.data as List<dynamic>;

    return jsonList.map((message) => Reservation.fromJson(message)).toList();
  }

  Future<List<Reservation>> getMyReservations(
      {required String status, required PagingRequest paging}) async {
    var query = paging.toJson();
    query.addAll({"status": status});
    var queryString = UrlUtils.toQueryString(query);

    var response = await get("/reservations/my-reservations$queryString")
        as CommonResponse;
    var pagingResponse = response.body!.data as PagingResponse;

    return pagingResponse.content
        .map((message) => Reservation.fromJson(message))
        .toList();
  }

  /// Admin
  Future<void> confirmReservation(
      {required ReservationRequest request, required bool confirm}) async {
    var queryString = UrlUtils.toQueryString({"confirm": confirm});
    await patch("/reservations$queryString", request.toJson());
  }

  Future<Reservation> updateReservationOwner(
      {required int reservationId, required ReservationRequest request}) async {
    var response = await patch(
            "/reservations/$reservationId/update-owner", request.toJson())
        as CommonResponse;
    return Reservation.fromJson(response.body!.data!);
  }

  Future<List<Reservation>> getReservationsForAdmin(
      {required int clubId,
      required String status,
      required PagingRequest paging}) async {
    var query = paging.toJson();
    query.addAll({"clubId": clubId, "status": status});
    var queryString = UrlUtils.toQueryString(query);

    var response =
        await get("/reservations/admin$queryString") as CommonResponse;
    var pagingResponse = response.body!.data as PagingResponse;

    return pagingResponse.content
        .map((message) => Reservation.fromJson(message))
        .toList();
  }
}
