import 'package:get/get.dart';

class ItemController extends GetxController {
  static ItemController get to => Get.find();

  final RxList<String> items = [
    '동아리방',
    'JBL스피커',
    '풍물패',
    '어쩌구저쩌구..',
  ].obs;
}
