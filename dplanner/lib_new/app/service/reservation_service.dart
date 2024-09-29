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
      {required Reservation reservation}) async {
    return await reservationApiProvider.createReservation(
        request: ReservationRequest.forCreate(reservation: reservation));
  }

  Future<Reservation> updateReservation(
      {required Reservation reservation}) async {
    return await reservationApiProvider.updateReservation(
        reservationId: reservation.reservationId,
        request: ReservationRequest.forUpdate(reservation: reservation));
  }

  void cancelReservation({required Reservation reservation}) async {
    reservationApiProvider.cancelReservation(
        reservationId: reservation.reservationId,
        request: ReservationRequest.forCancel(reservation: reservation));
  }

  void deleteReservation({required Reservation reservation}) async {
    reservationApiProvider.deleteReservation(
        request: ReservationRequest.forDelete(reservation: reservation));
  }

  Future<Reservation> returnReservation(
      {required Reservation reservation, required List<XFile>? images}) async {
    List<XFile> compressedImages = [];
    images?.forEach((image) async {
      var compressedImage = await CompressUtils.compressImageFile(image);
      compressedImages.add(compressedImage!);
    });

    return await reservationApiProvider.returnReservation(
        reservationId: reservation.reservationId,
        request: ReservationRequest.forReturn(reservation: reservation),
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
  void confirmReservation({required Reservation reservation}) {
    reservationApiProvider.confirmReservation(
        request: ReservationRequest.forConfirm(reservation: reservation),
        confirm: true);
  }

  void rejectReservation({required Reservation reservation}) {
    reservationApiProvider.confirmReservation(
        request: ReservationRequest.forReject(reservation: reservation),
        confirm: false);
  }

  Future<Reservation> updateReservationOwner(
      {required Reservation reservation}) async {
    return await reservationApiProvider.updateReservationOwner(
        reservationId: reservation.reservationId,
        request: ReservationRequest.forUpdateOwner(reservation: reservation));
  }

  Future<List<Reservation>> getReservationsForAdmin(
      {required String status, required PagingRequest paging}) async {
    var currentClubId = await clubService.getCurrentClubId();
    return await reservationApiProvider.getReservationsForAdmin(
        clubId: currentClubId, status: status, paging: paging);
  }
}
