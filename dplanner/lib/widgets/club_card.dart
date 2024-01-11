import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';

class ClubCard extends StatelessWidget {
  ClubCard({super.key});
  final sizeController = Get.put((SizeController()));

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColor.subColor2.withOpacity(0.8),
      highlightColor: AppColor.subColor2.withOpacity(0.8),
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColor.backgroundColor, // 원하는 색상으로 변경
        ),
        child: SizedBox(
          width: sizeController.screenWidth.value,
          height: sizeController.screenHeight.value * 0.15,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/dancepozz_logo.png',
                height: 100,
                width: 100,
                fit: BoxFit.fill,
              ),
              const SizedBox(width: 18),
              SizedBox(
                width: sizeController.screenWidth.value * 0.55,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dance P.O.zz",
                      style: TextStyle(
                        color: AppColor.textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      "회원수: 140명",
                      style: TextStyle(
                        color: AppColor.textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "중앙대 유일무이 스트릿댄스 동아리 어쩌구 ㄱ쩌구..",
                      style: TextStyle(
                        color: AppColor.textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
