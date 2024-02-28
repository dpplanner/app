// 클럽 목록에서 보이는 클럽 카드

import 'package:dplanner/models/club_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';

class ClubCard extends StatelessWidget {
  final ClubModel thisClub;

  const ClubCard({super.key, required this.thisClub});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: AppColor.subColor2.withOpacity(0.5),
      highlightColor: AppColor.subColor2.withOpacity(0.5),
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Get.offAllNamed('/tab2', arguments: 1);
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
                thisClub.url ?? 'assets/images/dancepozz_logo.png',
                height: SizeController.to.screenWidth * 0.2,
                width: SizeController.to.screenWidth * 0.2,
                fit: BoxFit.fill,
              ),
              const SizedBox(width: 15),
              SizedBox(
                width: SizeController.to.screenWidth * 0.55,
                height: SizeController.to.screenHeight * 0.1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            thisClub.clubName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: AppColor.textColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 18),
                          ),
                        ),
                        if (!(thisClub.isConfirmed ?? false))
                          const Text(
                            "가입 진행 중",
                            style: TextStyle(
                              color: AppColor.objectColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Text(
                        "회원수: ${thisClub.memberCount}",
                        style: const TextStyle(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        thisClub.info,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColor.textColor,
                          fontWeight: FontWeight.w400,
                          fontSize: 10,
                        ),
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
