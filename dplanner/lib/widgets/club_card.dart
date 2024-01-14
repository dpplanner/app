import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';

class ClubCard extends StatelessWidget {
  const ClubCard({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColor.subColor2.withOpacity(0.8),
      highlightColor: AppColor.subColor2.withOpacity(0.8),
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Get.offAllNamed('/club_root');
      },
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColor.backgroundColor,
        ),
        child: SizedBox(
          width: SizeController.to.screenWidth,
          height: SizeController.to.screenHeight * 0.13,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/dancepozz_logo.png',
                height: SizeController.to.screenWidth * 0.2,
                width: SizeController.to.screenWidth * 0.2,
                fit: BoxFit.fill,
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: SizeController.to.screenWidth * 0.55,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Dance P.O.zz",
                      style: TextStyle(
                        color: AppColor.textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
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
