import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';

import '../../../utils/datetime_utils.dart';
import '../../model/common_response.dart';
import '../../model/paging_request.dart';
import '../../model/paging_response.dart';
import '../../model/reservation/request/reservation_request.dart';
import '../../model/reservation/reservation.dart';
import 'base_api_provider.dart';

class ReservationApiProvider extends BaseApiProvider {
  Future<Reservation> getReservation({required int reservationId}) async {
    var response = await get("/reservations/$reservationId") as CommonResponse;
    return Reservation.fromJson(response.data);
  }

  Future<Reservation> createReservation(
      {required ReservationRequest request}) async {
    var response =
        await post("/reservations", request.toJson()) as CommonResponse;
    return Reservation.fromJson(response.data);
  }

  Future<Reservation> updateReservation(
      {required int reservationId, required ReservationRequest request}) async {
    var response =
        await put("/reservations/$reservationId/update", request.toJson())
            as CommonResponse;
    return Reservation.fromJson(response.data);
  }

  void cancelReservation(
      {required int reservationId, required ReservationRequest request}) async {
    await patch("/reservations/$reservationId/cancel", request.toJson());
  }

  void deleteReservation({required ReservationRequest request}) async {
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
            MapEntry("file", MultipartFile(image, filename: image.name)))
        .toList());

    var response = await post("/reservations/$reservationId/return", formData)
        as CommonResponse;
    return Reservation.fromJson(response.data);
  }

  Future<List<Reservation>> getReservations(
      {required int resourceId,
      required DateTime startDateTime,
      required DateTime endDateTime}) async {
    var response = await get("/reservations/scheduler", query: {
      "resourceId": resourceId,
      "start": DateTimeUtils.toFormattedString(startDateTime),
      "end": DateTimeUtils.toFormattedString(endDateTime)
    }) as CommonResponse;
    var jsonList = response.data as List<Map<String, dynamic>>;

    return jsonList.map((message) => Reservation.fromJson(message)).toList();
  }

  Future<List<Reservation>> getMyReservations(
      {required String status, required PagingRequest paging}) async {
    var query = paging.toJson();
    query.addAll({"status": status});

    var response = await get("/reservations/my-reservations", query: query)
        as CommonResponse;
    var pagingResponse = response.data as PagingResponse;
    var jsonList = pagingResponse.content as List<Map<String, dynamic>>;

    return jsonList.map((message) => Reservation.fromJson(message)).toList();
  }

  /// Admin
  void confirmReservation(
      {required ReservationRequest request, required bool confirm}) async {
    await patch("/reservations", request.toJson(), query: {"confirm": confirm});
  }

  Future<Reservation> updateReservationOwner(
      {required int reservationId, required ReservationRequest request}) async {
    var response = await patch(
            "/reservations/$reservationId/update-owner", request.toJson())
        as CommonResponse;
    return Reservation.fromJson(response.data);
  }

  Future<List<Reservation>> getReservationsForAdmin(
      {required int clubId,
      required String status,
      required PagingRequest paging}) async {
    var query = paging.toJson();
    query.addAll({"clubId": clubId, "status": status});

    var response =
        await get("/reservations/admin", query: query) as CommonResponse;
    var pagingResponse = response.data as PagingResponse;
    var jsonList = pagingResponse.content as List<Map<String, dynamic>>;

    return jsonList.map((message) => Reservation.fromJson(message)).toList();
  }
}
