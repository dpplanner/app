import 'package:dplanner/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';

import '../../../../../data/model/reservation/reservation.dart';
import '../../../../../service/reservation_service.dart';
import '../../../../base/widgets/bottom_sheet/bottom_sheet_navigator.dart';
import '../../../../base/widgets/bottom_sheet/bottom_sheet_view_controller.dart';

class ReservationReturnViewController extends BottomSheetViewController {
  final BottomSheetNavigator _navigator = Get.find<BottomSheetNavigator>();
  final ReservationService _reservationService = Get.find<ReservationService>();

  late Reservation reservation;

  RxList<XFile> returnImages = <XFile>[].obs;
  TextEditingController returnMessageForm = TextEditingController();

  @override
  void reset() {
    returnImages.clear();
    returnMessageForm.clear();
  }

  @override
  void init(Map<String, dynamic> arguments) {
    reservation = arguments["reservation"];
  }

  String get resourceName => reservation.resourceName;

  void onImageChanged(List<XFile> images) {
    returnImages.value = List<XFile>.from(images);
  }

  Future<void> returnReservation() async {
    try {
      await _reservationService.returnReservation(
          reservation: reservation, returnMessage: returnMessageForm.text, images: returnImages);
      _navigator.close(success: true);
    } catch (e) {
      _navigator.close(success: false);
      snackBar(title: "예약을 반납하지 못했습니다.", content: "잠시 후 다시 시도해 주세요");
    }
  }
}
