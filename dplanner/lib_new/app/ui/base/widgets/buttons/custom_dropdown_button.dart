import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import '../../../../../config/constants/app_colors.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  final List<T> items;
  final String Function(T item) itemLabelBuilder;
  final T? initialValue;
  final ValueChanged<T?>? onChanged;
  final double height;
  final double width;
  final double menuItemHeight;
  final Color color;

  const CustomDropdownButton({
    super.key,
    required this.items,
    required this.itemLabelBuilder,
    this.initialValue,
    this.onChanged,
    this.height = 40,
    this.width = 160,
    this.menuItemHeight = 32,
    this.color = AppColors.bgWhite,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        isExpanded: true,
        items: items
            .map((item) => DropdownMenuItem<T>(
                  value: item,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      itemLabelBuilder(item),
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ))
            .toList(),
        value: initialValue,
        onChanged: onChanged,
        buttonStyleData: ButtonStyleData(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color,
          ),
        ),
        iconStyleData: const IconStyleData(
            icon: Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Icon(SFSymbols.chevron_down),
            ),
            iconSize: 16,
            iconEnabledColor: AppColors.textBlack),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color,
          ),
          direction: DropdownDirection.left,
          offset: Offset(0, height),
          scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
              thickness: WidgetStateProperty.all<double>(6),
              thumbVisibility: WidgetStateProperty.all<bool>(true)),
        ),
        menuItemStyleData: MenuItemStyleData(height: menuItemHeight),
      ),
    );
  }
}
