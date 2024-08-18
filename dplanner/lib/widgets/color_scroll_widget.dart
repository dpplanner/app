import 'package:dplanner/widgets/color_unit_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../const/style.dart';

class ColorScrollWidget extends StatefulWidget {
  final Color defaultColor;
  final List<Color> availableColors;
  final ValueChanged<Color> onColorChanged; // 색상이 변경될 때 호출될 콜백

  const ColorScrollWidget({
    super.key,
    required this.defaultColor,
    required this.availableColors,
    required this.onColorChanged, // 초기 색상 설정은 필요 없으므로 제거
  });

  @override
  State<ColorScrollWidget> createState() => _ColorScrollWidgetState();
}

class _ColorScrollWidgetState extends State<ColorScrollWidget> {
  static const double circleSize = ColorUnitWidget.circleSize;
  static const double circlePadding = 16.0;
  static const double indicatorWidth = 180.0; // 5개의 원이 보여질 정도의 가로 길이
  static const double scrollBarHeight = 4.0; // 스크롤바 높이
  static const Duration animationDuration = Duration(milliseconds: 300); // 스크롤 애니메이션 지속 시간

  List<Color> colors = []; // 실제로 사용할 색상 리스트

  final ScrollController _scrollController = ScrollController();
  int selectedIndex = 2; // 초기 선택된 색상 인덱스

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        colors.addAll([
          Colors.transparent,
          Colors.transparent,
          ...widget.availableColors,
          Colors.transparent,
          Colors.transparent]);
      });
      selectedIndex = _getColorIndex(widget.defaultColor); // 기본 색상 인덱스 설정
      _centerScrollOnSelected();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  int _getColorIndex(Color color) {
    // 기본 색상에 대한 인덱스를 반환합니다.
    int index = colors.indexOf(color);
    if (index == -1) {
      // 색상이 colors 목록에 없으면 기본 색상 인덱스를 설정하지 않습니다.
      return 2; // 기본 색상 인덱스
    }
    return index;
  }

  void _centerScrollOnSelected() {
    // 선택된 색상이 화면 중앙에 오도록 스크롤 위치를 설정합니다.
    double targetOffset = selectedIndex * (circleSize + circlePadding) - (indicatorWidth / 2) + circleSize / 2;
    _scrollController.jumpTo(targetOffset);
  }

  void _onScroll() {
    // 스크롤 위치를 기반으로 인디케이터의 중심에 가장 가까운 색상 인덱스를 계산합니다.
    double offset = _scrollController.offset + (indicatorWidth / 2);
    int newIndex = (offset / (circleSize + circlePadding)).round();

    // 색상이 인디케이터의 중심에 가장 가깝도록 선택합니다.
    double centerOffset = (circleSize + circlePadding) * newIndex;
    double indicatorCenter = _scrollController.offset + (indicatorWidth / 2);
    double colorCenter = centerOffset + circleSize / 2;

    if ((indicatorCenter - colorCenter).abs() < (circleSize + circlePadding) / 2) {
      // 색상 인덱스를 실제 색상 범위로 제한합니다.
      if (newIndex < 2) newIndex = 2; // 첫 번째 색상 (두 번째 인덱스)으로 제한
      if (newIndex >= colors.length - 2) newIndex = colors.length - 3; // 마지막 색상 (마지막에서 두 번째 인덱스)으로 제한

      if (newIndex != selectedIndex && newIndex >= 0 && newIndex < colors.length) {
        setState(() {
          selectedIndex = newIndex;
          HapticFeedback.selectionClick();
          widget.onColorChanged(selectedColor);
        });
      }
    }
  }

  void _onColorTap(int index) async {
    // 사용자가 특정 색상을 탭했을 때 해당 색상이 중앙에 오도록 부드럽게 스크롤합니다.
    int adjustedIndex = index;
    if (index < 2) adjustedIndex = 2; // 첫 번째 색상 (두 번째 인덱스)으로 제한
    if (index >= colors.length - 2) adjustedIndex = colors.length - 3; // 마지막 색상 (마지막에서 두 번째 인덱스)으로 제한

    setState(() {
      selectedIndex = adjustedIndex;
    });

    double targetOffset = adjustedIndex * (circleSize + circlePadding) - (indicatorWidth / 2) + circleSize / 2;

    await _scrollController.animateTo(
      targetOffset,
      duration: animationDuration,
      curve: Curves.easeInOut,
    );

    HapticFeedback.selectionClick();
    widget.onColorChanged(selectedColor);
  }

  Color get selectedColor {
    if (selectedIndex == 0) {
      return AppColor.reservationColors.first; // 첫 번째 더미 색상 선택 시 첫 번째 실제 색상 반환
    } else if (selectedIndex == colors.length - 1) {
      return AppColor.reservationColors.last; // 마지막 더미 색상 선택 시 마지막 실제 색상 반환
    } else {
      return colors[selectedIndex]; // 그 외에는 실제 선택된 색상 반환
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: indicatorWidth,
              height: circleSize + scrollBarHeight,
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollUpdateNotification) {
                    _onScroll();
                  }
                  return true;
                },
                child: ListView.builder(
                  controller: _scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: colors.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _onColorTap(index),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: circlePadding / 2),
                        child: ColorUnitWidget(
                          color: colors[index],
                          showBorder: index >= 2 && index < 2 + widget.availableColors.length,
                          borderWidth: selectedIndex == index ? 0 : 5,
                        )
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
