import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';

import '../../../../config/constants/app_colors.dart';
import '../../base/widgets/buttons/menu_row_button.dart';
import '../../base/widgets/buttons/rounded_rectangle_full_button.dart';
import '../../base/widgets/padded_safe_area.dart';
import 'eula_agree_controller.dart';

class EulaAgreePage extends GetView<EulaAgreeController> {
  const EulaAgreePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bgWhite,
        body: PaddedSafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              Column(
                children: [
                  SvgPicture.asset('assets/images/login/dplanner_logo_login.svg'),
                  const SizedBox(height: 32.0),
                  Text("DPlanner를 사용하기 위해\n아래 서비스 이용 약관(EULA)에 동의해주세요",
                      textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
                  Divider(color: Colors.black, thickness: 1.5),
                  MenuRowButton(title: "서비스 이용약관(EULA)", onTap: controller.toServiceTermInfoPage),
                ],
              ),
              Column(
                children: [
                  RoundedRectangleFullButton(
                    title: "동의하고 시작하기",
                    onTap: controller.agreeEula,
                    isLast: false,
                  ),
                  RoundedRectangleFullButton(
                    title: "동의하지 않음",
                    onTap: controller.backToLoginPage,
                    color: AppColors.subColor5,
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
