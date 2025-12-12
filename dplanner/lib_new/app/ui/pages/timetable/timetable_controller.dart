import 'package:calendar_view/calendar_view.dart';
import 'package:dplanner/widgets/snack_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../config/constants/app_colors.dart';
import '../../../data/model/club/club_authority_type.dart';
import '../../../data/model/club/club_member.dart';
import '../../../data/model/reservation/reservation.dart';
import '../../../data/model/resource/resource.dart';
import '../../../service/club_member_service.dart';
import '../../../service/lock_service.dart';
import '../../../service/reservation_service.dart';
import '../../../service/resource_service.dart';
import '../../../utils/datetime_utils.dart';
import '../../base/widgets/bottom_sheet/bottom_sheet_navigator.dart';
import '../../base/widgets/dialog.dart';
import 'dialogs/notice_dialog_view.dart';
import 'views/date_picker/date_picker_view.dart';
import 'views/lock_manage/lock_manage_view.dart';
import 'views/reservation_create/reservation_create_view.dart';
import 'views/reservation_info/reservation_info_view.dart';

class TimetableController extends GetxController {
  final BottomSheetNavigator _navigator = Get.find<BottomSheetNavigator>();
  final ClubMemberService _clubMemberService = Get.find<ClubMemberService>();
  final ResourceService _resourceService = Get.find<ResourceService>();
  final ReservationService _reservationService = Get.find<ReservationService>();
  final LockService _lockService = Get.find<LockService>();

  final GlobalKey<WeekViewState> weekViewStateKey = GlobalKey<WeekViewState>();
  final EventController eventController = Get.find<EventController>();

  Rxn<ClubMember> me = Rxn<ClubMember>();
  RxList<Resource> resources = <Resource>[].obs;
  Rxn<Resource> currentResource = Rxn<Resource>();
  Rx<DateTime> selectedDate = DateTime.now().obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    await initialize();
  }

  bool hasScheduleAuthority() => me.value?.hasAuthority(ClubAuthorityType.SCHEDULE_ALL) == true;

  Future<void> initialize() async {
    me.value = await _clubMemberService.getMyInfo();
    resources.value = await _resourceService.getResourcesOfCurrentClub();
    currentResource.value = resources.first;
    await loadCalendarEvents();
  }

  Future<void> loadCalendarEvents() async {
    List<CalendarEventData<Object?>> events = [];
    _clearEvents();

    final weekdayOfSelectedDate = selectedDate.value.weekday;
    final mondayOfSelectedWeek =
        selectedDate.value.subtract(Duration(days: weekdayOfSelectedDate - 1)); // 해당 주 월요일 날짜
    final sundayOfSelectedWeek =
        selectedDate.value.add(Duration(days: 7 - weekdayOfSelectedDate + 1)); // 해당 주 일요일 날짜
    final endOfResource = DateTime.now()
        .withoutTime
        .add(Duration(days: currentResource.value!.bookableSpan! + 1)); // 예약 가능한 날짜
    final endDate =
        hasScheduleAuthority() || endOfResource.isWithin(mondayOfSelectedWeek, sundayOfSelectedWeek)
            ? sundayOfSelectedWeek // 권한이 있거나 예약 가능한 마지막날이 이번주면 해당 주 전체 조회
            : endOfResource; // 권한이 없고 예약 가능한 마지막날이 이번주가 아니면 월 ~ 예약가능일 까지 조회

    if (mondayOfSelectedWeek.isBefore(endDate)) {
      // reservation 조회 및 캘린더에 추가
      var reservations = await _reservationService.getReservations(
          resourceId: currentResource.value!.id,
          startDateTime: mondayOfSelectedWeek.copyWith(hour: 0, minute: 0, second: 0),
          endDateTime: endDate.copyWith(hour: 0, minute: 0, second: 0));

      for (var reservation in reservations) {
        events.add(_buildReservationEventData(reservation));
      }

      // lock 조회 및 캘린더에 추가
      var locks = await _lockService.getLocks(
          resourceId: currentResource.value!.id,
          startDateTime: mondayOfSelectedWeek.copyWith(hour: 0, minute: 0, second: 0),
          endDateTime: endDate.copyWith(hour: 0, minute: 0, second: 0));

      for (var lock in locks) {
        events.addAll(_buildLockEventData(lock.startDateTime, lock.endDateTime));
      }
    }

    // 일반 사용자에게는 예약가능일 이후는 lock
    if (!hasScheduleAuthority() && sundayOfSelectedWeek.isAfter(endOfResource)) {
      var startDateTime =
          endOfResource.isBefore(mondayOfSelectedWeek) ? endOfResource : mondayOfSelectedWeek;
      events.addAll(_buildLockEventData(startDateTime, sundayOfSelectedWeek));
    }

    eventController.addAll(events);
  }

  void moveToCurrentWeek() async {
    selectedDate.value = DateTime.now();
    await loadCalendarEvents();
    weekViewStateKey.currentState?.jumpToWeek(selectedDate.value);
  }

  Future<void> changeWeek() async {
    await _navigator.open(view: DatePickerView(), arguments: {
      "selectedDate": selectedDate.value,
      "onSelected": (date) => selectedDate.value = date
    });
    await loadCalendarEvents();
    weekViewStateKey.currentState?.jumpToWeek(selectedDate.value);
  }

  void changeResource(Resource? selectedResource) async {
    currentResource.value = selectedResource;
    await loadCalendarEvents();
  }

  void onEventTab(List<CalendarEventData<Object?>> events, DateTime date) async {
    if (events[0].title.isNotEmpty) {
      try {
        var reservationId = int.parse(events[0].title.split(" ")[0]);
        var reservation = await _reservationService.getReservation(reservationId: reservationId);
        var doRefresh = await _navigator.open(view: ReservationInfoView(), arguments: {
          "reservation": reservation,
          "isManager": hasScheduleAuthority(),
          "me": me.value!
        });

        if (doRefresh == true) {
          await loadCalendarEvents();
        }
      } catch (e) {
        snackBar(title: "예약 정보를 불러오지 못했습니다.", content: "잠시 후 다시 시도해 주세요.");
      }
    }
  }

  void onEventLongTab(List<CalendarEventData<Object?>> events, DateTime date) async {}

  void onEventDoubleTab(List<CalendarEventData<Object?>> events, DateTime date) async {}

  void onPageChange(DateTime date, int page) async {
    selectedDate.value = date;
    await loadCalendarEvents();
  }

  Future<void> requestReservation() async {
    bool agreeNotice = true;
    if (currentResource.value?.notice.isNotEmpty == true) {
      agreeNotice = await dialog(view: NoticeDialogView(notice: currentResource.value!.notice));
    }

    if (agreeNotice) {
        var doRefresh = await _navigator.open(view: ReservationCreateView(), arguments: {
          "resource": currentResource.value,
          "isManager": hasScheduleAuthority(),
          "me": me.value!
        });

        if (doRefresh == true) {
          await loadCalendarEvents();
        }
    }

    // addReservation(types: 0, reservation: null);
  }

  Future<void> lockResource() async {
    var doRefresh = await _navigator.open(
      view: LockManageView(),
      arguments: {"resource": currentResource.value},
    );

    if (doRefresh == true) {
      await loadCalendarEvents();
    }
  }

  void toResourceListPage() {
    // Get.toNamed('/resource_list');
  }

  /// private methods
  void _clearEvents() {
    var allEvents = List<CalendarEventData<Object?>>.from(eventController.allEvents);
    eventController.removeAll(allEvents);
  }

  CalendarEventData<Object?> _buildReservationEventData(Reservation reservation) {
    final isRequest = reservation.isRequest();
    final isMyReservation = reservation.isOwner(me.value?.id);
    final isEmptyTitle = reservation.title.isEmpty;

    var title = reservation.id.toString();
    if (!isRequest) {
      if (isEmptyTitle) {
        title += " ${reservation.clubMemberName}";
      } else {
        title += " ${reservation.title}";
      }
    }

    final description = isRequest || !isEmptyTitle ? "" : reservation.usage;

    final reservationColor = isRequest
        ? (isMyReservation ? AppColors.subColor2 : ReservationColors.notConfirmed)
        : ReservationColors.fromHexCode(reservation.color);

    return CalendarEventData(
        date: reservation.startDateTime,
        startTime: reservation.startDateTime,
        endTime: reservation.endDateTime.subtract(const Duration(milliseconds: 1)),
        title: title,
        description: description,
        color: reservationColor);
  }

  List<CalendarEventData<Object?>> _buildLockEventData(
      DateTime startDateTime, DateTime endDateTime) {
    // endDateTime이 자정(00:00:00)이면 전날 끝으로 처리
    final isMidnight = endDateTime.hour == 0 &&
        endDateTime.minute == 0 &&
        endDateTime.second == 0;
    int days = endDateTime.difference(startDateTime).inDays + (isMidnight ? 0 : 1);
    if (days < 1) days = 1;
    return List.generate(days, (index) {
      DateTime lockDate = startDateTime.add(Duration(days: index));

      DateTime startTime = lockDate.withoutTime == startDateTime.withoutTime // 시작일이면
          ? startDateTime // 시작시간
          : lockDate.copyWith(hour: 0, minute: 0, second: 0); // 아니면 00:00:00

      DateTime endTime = lockDate.withoutTime == endDateTime.withoutTime // 종료일이면
          ? endDateTime // 종료시간
          : lockDate.copyWith(hour: 23, minute: 59, second: 59); // 아니면 23:59:59
      return CalendarEventData(
          date: lockDate,
          startTime: startTime,
          endTime: endTime.subtract(const Duration(milliseconds: 1)),
          title: "",
          description: "",
          color: AppColors.lockColor.withOpacity(0.5));
    });
  }
}
