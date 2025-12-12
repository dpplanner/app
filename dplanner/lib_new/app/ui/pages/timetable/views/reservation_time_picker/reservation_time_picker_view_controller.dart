import 'package:calendar_view/calendar_view.dart';
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

class ReservationTimePickerViewController extends BottomSheetViewController {
  final BottomSheetNavigator _navigator = Get.find<BottomSheetNavigator>();
  final ReservationService _reservationService = Get.find<ReservationService>();
  final LockService _lockService = Get.find<LockService>();

  late bool isManager;
  late Resource resource;
  late Map<String, DateTime> availableRange;
  Function(DateTime start, DateTime end)? onSelected;

  Map<String, DateTime>? initialTime;
  Rx<DateTime> selectedDate = DateTime.now().obs;
  RxList<Rx<TimeSlot>> timeSlots = RxList.generate(
      24, (idx) => TimeSlot(startTime: DateTime.now().copyWith(hour: idx).withoutMinute).obs);

  bool get isSelected => timeSlots.any((slot) => slot.value.selected);

  @override
  void reset() {
    selectedDate.value = DateTime.now();
    initialTime = null;
    onSelected = null;
    for (var slot in timeSlots) {
      slot.value.status = TimeSlotStatus.available;
      slot.value.selected = false;
    }
  }

  @override
  void init(Map<String, dynamic> arguments) {
    isManager = arguments["isManager"];
    resource = arguments["resource"];
    onSelected = arguments["onSelected"];
    availableRange = {
      "start": DateTime.now().withoutTime,
      "end": DateTime.now()
          .copyWith(hour: 23, minute: 59, second: 59, millisecond: 59)
          .add(Duration(days: resource.bookableSpan!))
    };

    // todo map init late
    if (arguments.containsKey("initialTime")) {
      initialTime = arguments["initialTime"];
    }
  }

  get title => "예약 일시 선택";

  Future<void> initSlots() async {
    await _buildTimeSlots();

    final start = initialTime?["start"];
    final end = initialTime?["end"];

    if (start != null && end != null) {
      _updateSlot(start, end, (slot) => slot.selected = true);
      timeSlots.refresh();
    }
  }

  Future<void> moveDate(int dayDiff) async {
    var targetDate = selectedDate.value.add(Duration(days: dayDiff));
    if (isManager) {
      selectedDate.value = targetDate;
    } else if (targetDate.isWithin(availableRange["start"]!, availableRange["end"]!)) {
      selectedDate.value = targetDate;
    } else {
      snackBar(title: "선택할 수 없는 날짜입니다", content: "선택 가능한 날짜를 선택해주세요");
      return;
    }

    await _buildTimeSlots();
  }

  void changeDate() {
    _navigator.pushView(view: DatePickerView(), arguments: {
      "selectedDate": selectedDate.value,
      "onSelected": (date) => selectedDate.value = date,
      if (!isManager) "availableRange": availableRange
    });
  }

  void toggleTimeSlot(int idx) {
    timeSlots[idx].value.selected = !timeSlots[idx].value.selected;
    timeSlots.refresh(); // UI 갱신
  }

  void selectReservationTime() {
    if (!_validateTimeContinuous()) {
      snackBar(title: "예약 시간이 올바르지 않습니다", content: "연속된 시간만 선택 가능합니다");
      return;
    }

    onSelected?.call(_startDateTime, _endDateTime);
    _navigator.popView();
  }

  /// private methods
  DateTime get _startDateTime => selectedDate.value
      .copyWithTime(timeSlots.firstWhere((slot) => slot.value.selected).value.startTime);

  DateTime get _endDateTime {
    final last = timeSlots.lastWhere((slot) => slot.value.selected).value.startTime;
    return selectedDate.value.copyWithTime(last.add(const Duration(hours: 1))); // 끝나는 시각은 +1시간
  }

  Future<void> _buildTimeSlots() async {
    _clearSlots();

    List<Reservation> reservations = await _loadReservations();
    List<Lock> locks = await _loadLocks();

    for (final r in reservations) {
      _updateSlot(r.startDateTime, r.endDateTime, (slot) => slot.status = TimeSlotStatus.blocked);
    }

    for (final l in locks) {
      _updateSlot(l.startDateTime, l.endDateTime, (slot) => slot.status = TimeSlotStatus.blocked);
    }

    if (!isManager) {
      var dayStart = selectedDate.value.copyWith(hour: 0, minute: 0, second: 0);
      _updateSlot(dayStart, DateTime.now(), (slot) => slot.status = TimeSlotStatus.blocked);
    }

    timeSlots.refresh();
  }

  void _clearSlots() {
    for (var slot in timeSlots) {
      slot.value.status = TimeSlotStatus.available;
      slot.value.selected = false;
    }
  }

  void _updateSlot(DateTime start, DateTime end, void Function(TimeSlot slot) onMatch) {
    for (final slot in timeSlots) {
      final slotStart = selectedDate.value.copyWithTime(slot.value.startTime).withoutMinute;
      final slotEnd = slotStart.add(const Duration(hours: 1));

      final isOverlap =
          slotStart.isBefore(end.withoutMinute) && start.isBefore(slotEnd.withoutMinute);
      if (isOverlap) {
        onMatch(slot.value);
      }
    }
  }

  Future<List<Reservation>> _loadReservations() async {
    return await _reservationService.getReservations(
        resourceId: resource.id,
        startDateTime: selectedDate.value.copyWith(hour: 0, minute: 0, second: 0),
        endDateTime: selectedDate.value.copyWith(hour: 23, minute: 59, second: 59));
  }

  Future<List<Lock>> _loadLocks() async {
    return await _lockService.getLocks(
        resourceId: resource.id,
        startDateTime: selectedDate.value.copyWith(hour: 0, minute: 0, second: 0),
        endDateTime: selectedDate.value.copyWith(hour: 23, minute: 59, second: 59));
  }

  bool _validateTimeContinuous() {
    final selectedIndices = List.generate(timeSlots.length, (i) => i)
        .where((i) => timeSlots[i].value.selected)
        .toList();

    return List.generate(selectedIndices.length, (i) => selectedIndices.first + i)
        .every((v) => selectedIndices.contains(v));
  }
}
