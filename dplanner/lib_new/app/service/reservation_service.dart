import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';

import '../data/model/paging_request.dart';
import '../data/model/reservation/request/reservation_request.dart';
import '../data/model/reservation/reservation.dart';
import '../data/provider/api/reservation_api_provider.dart';
import '../utils/compress_utils.dart';
import 'club_member_service.dart';
import 'club_service.dart';

class ReservationService extends GetxService {
  final ReservationApiProvider reservationApiProvider =
      Get.find<ReservationApiProvider>();
  final ClubService clubService = Get.find<ClubService>();
  final ClubMemberService clubMemberService = Get.find<ClubMemberService>();

  Future<Reservation> getReservation({required int reservationId}) async {
    return await reservationApiProvider.getReservation(
        reservationId: reservationId);
  }

  Future<Reservation> createReservation(
      {required int reservationOwnerId,
      required int resourceId,
      required DateTime startDateTime,
      required DateTime endDateTime,
      required String color,
      String? title,
      String? usage,
      List<int>? reservationInvitees,
      bool sharing = true}) async {
    return await reservationApiProvider.createReservation(
        request: ReservationRequest.forCreate(
            reservationOwnerId: reservationOwnerId,
            resourceId: resourceId,
            title: title,
            color: color,
            usage: usage,
            sharing: sharing,
            startDateTime: startDateTime,
            endDateTime: endDateTime,
            reservationInvitees: reservationInvitees));
  }

  Future<Reservation> updateReservation(
      {required Reservation reservation}) async {
    return await reservationApiProvider.updateReservation(
        reservationId: reservation.id,
        request: ReservationRequest.forUpdate(reservation: reservation));
  }

  Future<void> cancelReservation({required Reservation reservation}) async {
    await reservationApiProvider.cancelReservation(
        reservationId: reservation.id,
        request: ReservationRequest.forCancel(reservation: reservation));
  }

  Future<void> deleteReservation({required Reservation reservation}) async {
    await reservationApiProvider.deleteReservation(
        request: ReservationRequest.forDelete(reservation: reservation));
  }

  Future<Reservation> returnReservation(
      {required Reservation reservation,
      String? returnMessage,
      List<XFile>? images}) async {
    List<XFile> compressedImages = [];
    images?.forEach((image) async {
      var compressedImage = await CompressUtils.compressImageFile(image);
      compressedImages.add(compressedImage!);
    });

    return await reservationApiProvider.returnReservation(
        reservationId: reservation.id,
        request: ReservationRequest.forReturn(
            reservation: reservation, returnMessage: returnMessage),
        images: compressedImages);
  }

  Future<List<Reservation>> getReservations(
      {required int resourceId,
      required DateTime startDateTime,
      required DateTime endDateTime}) async {
    return await reservationApiProvider.getReservations(
        resourceId: resourceId,
        startDateTime: startDateTime,
        endDateTime: endDateTime);
  }

  Future<List<Reservation>> getMyReservations(
      {required String status, required PagingRequest paging}) async {
    return await reservationApiProvider.getMyReservations(
        status: status, paging: paging);
  }

  /// Admin
  Future<void> confirmReservation({required Reservation reservation}) async {
    await reservationApiProvider.confirmReservation(
        request: ReservationRequest.forConfirm(reservation: reservation),
        confirm: true);
  }

  Future<void> rejectReservation({required Reservation reservation}) async {
    await reservationApiProvider.confirmReservation(
        request: ReservationRequest.forReject(reservation: reservation),
        confirm: false);
  }

  Future<Reservation> updateReservationOwner(
      {required Reservation reservation,
      required int reservationOwnerId}) async {
    return await reservationApiProvider.updateReservationOwner(
        reservationId: reservation.id,
        request: ReservationRequest.forUpdateOwner(
            reservationOwnerId: reservationOwnerId));
  }

  Future<List<Reservation>> getReservationsForAdmin(
      {required String status, required PagingRequest paging}) async {
    var currentClubId = await clubService.getCurrentClubId();
    return await reservationApiProvider.getReservationsForAdmin(
        clubId: currentClubId, status: status, paging: paging);
  }
}
