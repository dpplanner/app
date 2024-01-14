import 'package:dplanner/widgets/image_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../style.dart';
import '../controllers/size.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    print('ready...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: SizeController.to.screenHeight * 0.1),
              SvgPicture.asset(
                'assets/images/login/dplanner_logo_login.svg',
              ),
              SizedBox(height: SizeController.to.screenHeight * 0.3),

              ///TODO: 이미지 변경 필요
              ImageButton(
                  image: 'assets/images/login/kakao_login.svg',
                  onTap: () {
                    Get.offNamed('/club_list');
                  }),
              SizedBox(height: SizeController.to.screenHeight * 0.005),
              ImageButton(
                  image: 'assets/images/login/naver_login.svg', onTap: () {}),
              SizedBox(height: SizeController.to.screenHeight * 0.005),
              ImageButton(
                  image: 'assets/images/login/facebook_login.svg',
                  onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
