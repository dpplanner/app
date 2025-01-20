import 'package:get/get.dart';

import '../../app/data/provider/api/alert_message_api_provider.dart';
import '../../app/data/provider/api/club_api_provider.dart';
import '../../app/data/provider/api/club_invite_code_api_provider.dart';
import '../../app/data/provider/api/club_manager_api_provider.dart';
import '../../app/data/provider/api/club_member_api_provider.dart';
import '../../app/data/provider/api/comment_api_provider.dart';
import '../../app/data/provider/api/lock_api_provider.dart';
import '../../app/data/provider/api/member_api_provider.dart';
import '../../app/data/provider/api/post_api_provider.dart';
import '../../app/data/provider/api/reservation_api_provider.dart';
import '../../app/data/provider/api/resource_api_provider.dart';
import '../../app/data/provider/api/token_api_provider.dart';
import '../../app/service/alert_message_service.dart';
import '../../app/service/club_member_service.dart';
import '../../app/service/club_service.dart';
import '../../app/service/comment_service.dart';
import '../../app/service/firebase_messaging_service.dart';
import '../../app/service/lock_service.dart';
import '../../app/service/member_service.dart';
import '../../app/service/post_service.dart';
import '../../app/service/reservation_service.dart';
import '../../app/service/resource_service.dart';
import '../../app/service/secure_storage_service.dart';
import '../../app/service/token_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() async {
    /// providers
    Get.lazyPut<AlertMessageApiProvider>(() => AlertMessageApiProvider());
    Get.lazyPut<ClubApiProvider>(() => ClubApiProvider());
    Get.lazyPut<ClubMemberApiProvider>(() => ClubMemberApiProvider());
    Get.lazyPut<ClubManagerApiProvider>(() => ClubManagerApiProvider());
    Get.lazyPut<ClubInviteCodeApiProvider>(() => ClubInviteCodeApiProvider());
    Get.lazyPut<PostApiProvider>(() => PostApiProvider());
    Get.lazyPut<CommentApiProvider>(() => CommentApiProvider());
    Get.lazyPut<ReservationApiProvider>(() => ReservationApiProvider());
    Get.lazyPut<LockApiProvider>(() => LockApiProvider());
    Get.lazyPut<ResourceApiProvider>(() => ResourceApiProvider());
    Get.lazyPut<MemberApiProvider>(() => MemberApiProvider());
    Get.lazyPut<TokenApiProvider>(() => TokenApiProvider());

    /// services
    Get.lazyPut<FirebaseMessagingService>(() => FirebaseMessagingService());
    Get.lazyPut<AlertMessageService>(() => AlertMessageService());
    Get.lazyPut<ClubMemberService>(() => ClubMemberService());
    Get.lazyPut<ClubService>(() => ClubService());
    Get.lazyPut<PostService>(() => PostService());
    Get.lazyPut<CommentService>(() => CommentService());
    Get.lazyPut<ReservationService>(() => ReservationService());
    Get.lazyPut<LockService>(() => LockService());
    Get.lazyPut<ResourceService>(() => ResourceService());
    Get.lazyPut<MemberService>(() => MemberService());
    Get.lazyPut<SecureStorageService>(() => SecureStorageService());
    Get.lazyPut<TokenService>(() => TokenService());
  }

}