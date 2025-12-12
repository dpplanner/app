import 'package:get/get.dart';

import 'timetable_controller.dart';
import 'views/date_picker/date_picker_view_controller.dart';
import 'views/lock_manage/lock_manage_view_controller.dart';
import 'views/member_picker/member_picker_view_controller.dart';
import 'views/reservation_create/reservation_create_view_controller.dart';
import 'views/reservation_info/reservation_info_view_controller.dart';
import 'views/reservation_modify/reservation_modify_view_controller.dart';
import 'views/reservation_return/reservation_return_view_controller.dart';
import 'views/reservation_time_picker/reservation_time_picker_view_controller.dart';

class TimetableBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TimetableController>(() => TimetableController());
    Get.lazyPut<DatePickerViewController>(() => DatePickerViewController(), fenix: true);
    Get.lazyPut<ReservationInfoViewController>(() => ReservationInfoViewController(), fenix: true);
    Get.lazyPut<ReservationReturnViewController>(() => ReservationReturnViewController(), fenix: true);
    Get.lazyPut<ReservationModifyViewController>(() => ReservationModifyViewController(), fenix: true);
    Get.lazyPut<ReservationCreateViewController>(() => ReservationCreateViewController(), fenix: true);
    Get.lazyPut<MemberPickerViewController>(() => MemberPickerViewController(), fenix: true);
    Get.lazyPut<ReservationTimePickerViewController>(() => ReservationTimePickerViewController(), fenix: true);
    Get.lazyPut<LockManageViewController>(() => LockManageViewController(), fenix: true);
  }
}
