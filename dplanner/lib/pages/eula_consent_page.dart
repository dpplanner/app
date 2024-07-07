import 'package:dplanner/pages/simple_info_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../const/style.dart';
import '../controllers/size.dart';
import '../services/token_api_service.dart';
import '../widgets/nextpage_button.dart';
import 'error_page.dart';

class EulaConsentPage extends StatelessWidget {
  const EulaConsentPage({super.key});

  Future<void> checkUserLogin() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.backgroundColor,
        body: FutureBuilder(
            future: checkUserLogin(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const ErrorPage();
              } else {
                return SafeArea(
                  child: Center(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              top: SizeController.to.screenHeight * 0.22,
                              bottom: SizeController.to.screenHeight * 0.05),
                          child: SvgPicture.asset(
                            'assets/images/login/dplanner_logo_login.svg',
                          ),
                        ),
                        const Text(
                          "DPlanner를 사용하기 위해\n아래 서비스 이용 약관(EULA)에 동의해주세요",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 32.0, left: 32.0),
                          child: Divider(
                            color: Colors.black,
                            thickness: 1.5,
                          ),
                        ),
                        buttonRow(
                            title: "서비스 이용약관(EULA)",
                            onTap: () => Get.to(const SimpleInfoPage(
                                title: "서비스 이용약관",
                                filePath:
                                    "assets/texts/service_term_info.txt"))),
                        const Expanded(child: SizedBox()),
                        NextPageButton(
                          text: const Text(
                            "동의하고 시작하기",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColor.backgroundColor),
                          ),
                          buttonColor: AppColor.objectColor,
                          onPressed: () async {
                            await TokenApiService.postEula();
                            Get.offNamed('/club_list');
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: SizeController.to.screenHeight * 0.005),
                          child: NextPageButton(
                            text: const Text(
                              "동의하지 않음",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColor.backgroundColor),
                            ),
                            buttonColor: AppColor.subColor5,
                            onPressed: () {
                              SystemNavigator.pop();
                            },
                          ),
                        ),
                        SizedBox(
                          height: SizeController.to.screenHeight * 0.05,
                        ),
                      ],
                    ),
                  ),
                );
              }
            }));
  }

  Widget buttonRow({
    required String title,
    required void Function()? onTap,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: AppColor.textColor,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 32),
        backgroundColor: AppColor.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColor.textColor),
          ),
          const Icon(
            SFSymbols.chevron_right,
            size: 16,
            color: AppColor.textColor,
          ),
        ],
      ),
    );
  }
}
