import 'package:dplanner/models/user_model.dart';
import 'package:get/get.dart';

enum LoginPlatform {
  kakao,
  naver,
  google,
  none;

  String get title => const <LoginPlatform, String>{
        LoginPlatform.kakao: '카카오',
        LoginPlatform.naver: '네이버',
        LoginPlatform.google: '구글',
      }[this]!;
}

class LoginController extends GetxController {
  static LoginController get to => Get.find();

  Rx<UserModel> user = UserModel(email: '', name: '').obs;
  Rx<LoginPlatform> loginPlatform = LoginPlatform.none.obs;
}
