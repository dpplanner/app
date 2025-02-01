import 'dart:io';

import 'package:dplanner/widgets/image_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../../config/constants/app_colors.dart';
import '../../base/pages/error_page.dart';
import '../../base/widgets/buttons/full_button_frame.dart';
import '../../base/widgets/padded_safe_area.dart';
import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.bgWhite,
        body: FutureBuilder(
            future: controller.checkUserLogin(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const ErrorPage();
              } else {
                return PaddedSafeArea(
                  child: Center(
                    child: Column(
                      children: [
                        Expanded(
                            child: SvgPicture.asset(
                          'assets/images/login/dplanner_logo_login.svg',
                        )),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //카카오 로그인 버튼
                            FullButtonFrame(
                                child: ImageButton(
                                    image:
                                        'assets/images/login/login_kakao.png',
                                    onTap: controller.loginWithKakao)),

                            //네이버 로그인 버튼
                            FullButtonFrame(
                                child: ImageButton(
                                    image:
                                        'assets/images/login/login_naver.png',
                                    onTap: controller.loginWithNaver)),

                            //구글 로그인 버튼
                            FullButtonFrame(
                                child: ImageButton(
                                    image:
                                        'assets/images/login/login_google.png',
                                    onTap: controller.loginWithGoogle)),

                            if (Platform.isIOS)
                              FullButtonFrame(
                                  child: SignInWithAppleButton(
                                      onPressed: controller.loginWithApple)),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                      ],
                    ),
                  ),
                );
              }
            }));
  }
}
