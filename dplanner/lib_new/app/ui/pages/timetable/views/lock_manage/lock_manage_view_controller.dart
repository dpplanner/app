import 'package:dplanner/widgets/snack_bar.dart';
import 'package:get/get.dart';

import '../../../../../data/model/lock/lock.dart';
import '../../../../../data/model/reservation/reservation.dart';
import '../../../../../data/model/resource/resource.dart';
import '../../../../../service/lock_service.dart';
import '../../../../../service/reservation_service.dart';
import '../../../../../utils/datetime_utils.dart';
import '../../../../base/widgets/bottom_sheet/bottom_sheet_navigator.dart';
import '../../../../base/widgets/bottom_sheet/bottom_sheet_view_controller.dart';
import '../../widgets/time_picker_grid.dart';
import '../date_picker/date_picker_view.dart';
import 'dialogs/date_change_confirm_dialog.dart';

class LockManageViewController extends BottomSheetViewController {
  final BottomSheetNavigator _navigator = Get.find<BottomSheetNavigator>();
  final LockService _lockService = Get.find<LockService>();
  final ReservationService _reservationService =
      Get.find<ReservationService>();

  late Resource resource;

  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxList<Rx<TimeSlot>> timeSlots = RxList.generate(
    24,
    (idx) => TimeSlot(
      startTime: DateTime.now().copyWith(hour: idx).withoutMinute,
    ).obs,
  );

  List<Lock> originalLocks = [];
  List<Reservation> reservations = [];
  RxBool isInitialLoading = true.obs;
  RxBool isLoading = false.obs;
  RxBool hasChanges = false.obs;

  String get title => "예약 잠금";

  // 예약이 없는 슬롯만 고려하여 전체 선택 여부 판단
  bool get isAllSelected => timeSlots
      .where((slot) => slot.value.status == TimeSlotStatus.available)
      .every((slot) => slot.value.selected);

  void _updateHasChanges() {
    for (int i = 0; i < timeSlots.length; i++) {
      // 예약된 슬롯은 변경 대상에서 제외
      if (timeSlots[i].value.status == TimeSlotStatus.blocked) continue;
      if (_wasLocked(i) != timeSlots[i].value.selected) {
        hasChanges.value = true;
        return;
      }
    }
    hasChanges.value = false;
  }

  @override
  void reset() {
    originalLocks = [];
    reservations = [];
    isInitialLoading.value = true;
    isLoading.value = false;
    hasChanges.value = false;
    for (int i = 0; i < timeSlots.length; i++) {
      timeSlots[i].value = TimeSlot(
        startTime: DateTime.now().copyWith(hour: i).withoutMinute,
        status: TimeSlotStatus.available,
        selected: false,
      );
    }
  }

  @override
  void init(Map<String, dynamic> arguments) {
    resource = arguments["resource"] as Resource;
    selectedDate.value = DateTime.now();
    loadLocks();
  }

  Future<void> loadLocks() async {
    final startOfDay = selectedDate.value.copyWith(hour: 0, minute: 0, second: 0);
    final endOfDay = selectedDate.value.copyWith(hour: 23, minute: 59, second: 59);

    originalLocks = await _lockService.getLocks(
      resourceId: resource.id,
      startDateTime: startOfDay,
      endDateTime: endOfDay,
    );

    reservations = await _reservationService.getReservations(
      resourceId: resource.id,
      startDateTime: startOfDay,
      endDateTime: endOfDay,
    );

    _buildTimeSlots();
    hasChanges.value = false; // 데이터 로드 후 변경사항 없음
    isInitialLoading.value = false;
  }

  Future<void> moveDate(int dayDiff) async {
    if (hasChanges.value) {
      final confirmed = await _confirmDateChange();
      if (!confirmed) return;
    }

    selectedDate.value = selectedDate.value.add(Duration(days: dayDiff));
    await loadLocks();
  }

  void changeDate() async {
    if (hasChanges.value) {
      final confirmed = await _confirmDateChange();
      if (!confirmed) return;
    }

    _navigator.pushView(
      view: DatePickerView(),
      arguments: {
        "selectedDate": selectedDate.value,
        "onSelected": (DateTime date) async {
          selectedDate.value = date;
          await loadLocks();
        },
      },
    );
  }

  void toggleTimeSlot(int index) {
    timeSlots[index].value.selected = !timeSlots[index].value.selected;
    timeSlots.refresh();
    _updateHasChanges();
  }

  void toggleSelectAll() {
    final newState = !isAllSelected;
    for (var slot in timeSlots) {
      // 예약된 슬롯은 선택 변경하지 않음
      if (slot.value.status == TimeSlotStatus.blocked) continue;
      slot.value.selected = newState;
    }
    timeSlots.refresh();
    _updateHasChanges();
  }

  Future<void> submitLockChanges() async {
    try {
      // 1. 기존 락 모두 삭제
      for (final lock in originalLocks) {
        await _lockService.deleteLock(lockId: lock.id);
      }

      // 2. 현재 선택된 슬롯들로 새 락 생성 (연속된 시간대는 병합)
      final selectedIndices = <int>[];
      for (int i = 0; i < timeSlots.length; i++) {
        if (timeSlots[i].value.selected) {
          selectedIndices.add(i);
        }
      }

      final mergedRanges = _mergeConsecutiveSlots(selectedIndices);
      for (final range in mergedRanges) {
        await _lockService.createLock(
          resourceId: resource.id,
          startDateTime: range.start,
          endDateTime: range.end,
        );
      }

      _navigator.close(success: true);
    } catch (e) {
      _navigator.close(success: false);
      snackBar(title: "오류 발생", content: "잠금 시간 수정에 실패했습니다. 다시 시도해주세요.");
    }
  }

  void cancel() {
    _navigator.popView();
  }

  /// Private methods
  Future<bool> _confirmDateChange() async {
    final result = await Get.dialog<bool>(const DateChangeConfirmDialog());
    return result ?? false;
  }

  bool _wasLocked(int index) {
    final slotStart = selectedDate.value
        .copyWith(hour: index, minute: 0, second: 0)
        .withoutMinute;
    final slotEnd = slotStart.add(const Duration(hours: 1));


    return originalLocks.any((lock) =>
        slotStart.isBefore(lock.endDateTime.withoutMinute) &&
        lock.startDateTime.isBefore(slotEnd.withoutMinute));
  }

  bool _isReserved(int index) {
    final slotStart = selectedDate.value
        .copyWith(hour: index, minute: 0, second: 0)
        .withoutMinute;
    final slotEnd = slotStart.add(const Duration(hours: 1));

    return reservations.any((reservation) =>
        slotStart.isBefore(reservation.endDateTime.withoutMinute) &&
        reservation.startDateTime.isBefore(slotEnd.withoutMinute));
  }

  void _buildTimeSlots() {
    for (int i = 0; i < timeSlots.length; i++) {
      final isReserved = _isReserved(i);
      timeSlots[i].value = TimeSlot(
        startTime: DateTime.now().copyWith(hour: i).withoutMinute,
        status: isReserved ? TimeSlotStatus.blocked : TimeSlotStatus.available,
        selected: isReserved ? false : _wasLocked(i),
      );
    }
    timeSlots.refresh();
  }

  List<({DateTime start, DateTime end})> _mergeConsecutiveSlots(
      List<int> slotIndices) {
    if (slotIndices.isEmpty) return [];

    slotIndices.sort();

    final ranges = <({DateTime start, DateTime end})>[];
    int? rangeStartIdx;
    int? rangeEndIdx;

    for (final idx in slotIndices) {
      if (rangeStartIdx == null) {
        rangeStartIdx = idx;
        rangeEndIdx = idx;
      } else if (idx == rangeEndIdx! + 1) {
        rangeEndIdx = idx;
      } else {
        ranges.add(_buildDateTimeRange(rangeStartIdx, rangeEndIdx));
        rangeStartIdx = idx;
        rangeEndIdx = idx;
      }
    }

    if (rangeStartIdx != null && rangeEndIdx != null) {
      ranges.add(_buildDateTimeRange(rangeStartIdx, rangeEndIdx));
    }

    return ranges;
  }

  ({DateTime start, DateTime end}) _buildDateTimeRange(
      int startIdx, int endIdx) {
    final startDateTime = selectedDate.value
        .copyWith(hour: startIdx, minute: 0, second: 0, millisecond: 0);

    // endIdx가 23이면 hour: 24가 되어 다음날 00:00으로 처리
    final endHour = endIdx + 1;
    final endDateTime = endHour >= 24
        ? selectedDate.value
            .add(const Duration(days: 1))
            .copyWith(hour: 0, minute: 0, second: 0, millisecond: 0)
        : selectedDate.value
            .copyWith(hour: endHour, minute: 0, second: 0, millisecond: 0);

    return (start: startDateTime, end: endDateTime);
  }
}
