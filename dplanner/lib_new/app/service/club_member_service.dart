import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';

import '../data/model/club/club_member.dart';
import '../data/model/club/request/club_member_request.dart';
import '../data/model/club/request/club_member_role_update_request.dart';
import '../data/provider/api/club_member_api_provider.dart';
import '../utils/compress_utils.dart';
import '../utils/token_utils.dart';
import 'club_service.dart';
import 'secure_storage_service.dart';

class ClubMemberService extends GetxService {
  final ClubMemberApiProvider clubMemberApiProvider =
      Get.find<ClubMemberApiProvider>();
  final ClubService clubService = Get.find<ClubService>();
  final SecureStorageService secureStorageService =
      Get.find<SecureStorageService>();

  Future<int> getCurrentClubMemberId() async {
    var accessToken = await secureStorageService.getAccessToken();
    return TokenUtils.getRecentClubMemberId(accessToken: accessToken!);
  }

  /// ClubMember
  Future<ClubMember> joinClub(
      {required int clubId, required String name, required String info}) async {
    return clubMemberApiProvider.joinClub(
        clubId: clubId,
        request: ClubMemberRequest.forCreate(name: name, info: info));
  }

  Future<List<ClubMember>> getConfirmedClubMembers() async {
    var currentClubId = await clubService.getCurrentClubId();
    return clubMemberApiProvider.getClubMembers(
        clubId: currentClubId, confirmed: true);
  }

  Future<ClubMember> getMyInfo() async {
    var currentClubId = await clubService.getCurrentClubId();
    var currentClubMemberId = await getCurrentClubMemberId();

    return clubMemberApiProvider.getClubMember(
        clubId: currentClubId, clubMemberId: currentClubMemberId);
  }

  Future<ClubMember> updateClubMember({required ClubMember clubMember}) async {
    var currentClubId = await clubService.getCurrentClubId();

    return await clubMemberApiProvider.updateClubMemberInfo(
        clubId: currentClubId,
        clubMemberId: clubMember.id,
        request: ClubMemberRequest.forUpdate(clubMember: clubMember));
  }

  Future<ClubMember> updateClubMemberProfileImage(
      {required XFile image}) async {
    var currentClubId = await clubService.getCurrentClubId();
    var currentClubMemberId = await getCurrentClubMemberId();
    var compressedImage = await CompressUtils.compressImageFile(image);

    return await clubMemberApiProvider.updateClubMemberProfileImage(
        clubId: currentClubId,
        clubMemberId: currentClubMemberId,
        image: compressedImage!);
  }

  Future<void> leaveClub() async {
    var currentClubId = await clubService.getCurrentClubId();
    var currentClubMemberId = await getCurrentClubMemberId();
    await clubMemberApiProvider.leaveClub(
        clubId: currentClubId, clubMemberId: currentClubMemberId);
  }

  Future<void> blockClubMember({required int blockedClubMemberId}) async {
    var currentClubId = await clubService.getCurrentClubId();
    await clubMemberApiProvider.blockClubMember(
        clubId: currentClubId, blockedClubMemberId: blockedClubMemberId);
  }

  /// ADMIN
  Future<List<ClubMember>> getUnConfirmedClubMembers() async {
    var currentClubId = await clubService.getCurrentClubId();

    return clubMemberApiProvider.getClubMembers(
        clubId: currentClubId, confirmed: false);
  }

  Future<ClubMember> updateClubMemberRole(
      {required int clubMemberId,
      required ClubMemberRoleUpdateRequest request}) async {
    var currentClubId = await clubService.getCurrentClubId();

    return await clubMemberApiProvider.updateClubMemberRole(
        clubId: currentClubId, clubMemberId: clubMemberId, request: request);
  }

  Future<void> confirmClubMember({required ClubMember clubMember}) async {
    var currentClubId = await clubService.getCurrentClubId();

    await clubMemberApiProvider.confirmClubMember(
        clubId: currentClubId,
        request: ClubMemberRequest.forConfirm(clubMember: clubMember));
  }

  Future<void> rejectClubMember({required ClubMember clubMember}) async {
    var currentClubId = await clubService.getCurrentClubId();

    await clubMemberApiProvider.rejectClubMember(
        clubId: currentClubId,
        request: ClubMemberRequest.forReject(clubMember: clubMember));
  }

  Future<void> kickOutClubMember({required int clubMemberId}) async {
    var currentClubId = await clubService.getCurrentClubId();

    await clubMemberApiProvider.kickOutClubMember(
        clubId: currentClubId, clubMemberId: clubMemberId);
  }
}
