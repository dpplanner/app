import 'package:dplanner/models/club_model.dart';
import 'package:dplanner/models/resource_model.dart';
import 'package:get/get.dart';

class ClubController extends GetxController {
  static ClubController get to => Get.find();

  Rx<ClubModel> club = ClubModel(id: 0, clubName: "", info: "").obs;
  RxList<ResourceModel> resources = <ResourceModel>[].obs;
}
