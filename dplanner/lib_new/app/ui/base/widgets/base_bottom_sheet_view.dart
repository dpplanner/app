import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../config/constants/app_colors.dart';
import 'bottom_sheet.dart';
import 'padded_safe_area.dart';

class BaseBottomSheetView extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> buttons;

  const BaseBottomSheetView(
      {super.key, required this.title, required this.content, required this.buttons});

  @override
  Widget build(BuildContext context) {
    return PaddedSafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: SvgPicture.asset('assets/images/extra/showmodal_scrollcontrolbar.svg')),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (canPop)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                            onTap: back,
                            child: const Icon(SFSymbols.chevron_left, color: AppColors.textBlack)),
                      ),
                    Text(title, style: Theme.of(context).textTheme.displaySmall),
                  ],
                ),
              ),
              Expanded(child: SingleChildScrollView(child: content)),
              Column(
                children: buttons,
              )
            ])));
  }

  get canPop => Get.find<BottomSheetController>().canPop();

  void back() {
    Get.find<BottomSheetController>().popView();
  }
}
