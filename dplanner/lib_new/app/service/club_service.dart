import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';

import '../base/exceptions.dart';
import '../data/model/club/club.dart';
import '../data/model/club/club_authority_type.dart';
import '../data/model/club/club_invite_code.dart';
import '../data/model/club/club_manager.dart';
import '../data/model/club/request/club_manager_request.dart';
import '../data/model/club/request/club_request.dart';
import '../data/provider/api/club_api_provider.dart';
import '../data/provider/api/club_invite_code_api_provider.dart';
import '../data/provider/api/club_manager_api_provider.dart';
import '../data/provider/api/club_member_api_provider.dart';
import '../utils/compress_utils.dart';
import '../utils/token_utils.dart';
import 'member_service.dart';
import 'secure_storage_service.dart';

class ClubService extends GetxService {
  final MemberService memberService = Get.find<MemberService>();
  final ClubApiProvider clubApiProvider = Get.find<ClubApiProvider>();
  final ClubInviteCodeApiProvider clubInviteCodeApiProvider =
      Get.find<ClubInviteCodeApiProvider>();
  final ClubManagerApiProvider clubManagerApiProvider =
      Get.find<ClubManagerApiProvider>();
  final ClubMemberApiProvider clubMemberApiProvider =
      Get.find<ClubMemberApiProvider>();
  final SecureStorageService secureStorageService =
      Get.find<SecureStorageService>();

  Future<int> getCurrentClubId() async {
    var accessToken = await secureStorageService.getAccessToken();
    return TokenUtils.getRecentClubId(accessToken: accessToken!);
  }

  /// Club
  Future<List<Club>> getMyClubs() async {
    var memberId = await memberService.getMemberId();
    return await clubApiProvider.getClubsByMemberId(memberId: memberId);
  }

  Future<Club> createClub(
      {required String clubName, required String info}) async {
    return await clubApiProvider.createClub(
        request: ClubRequest.forCreate(clubName: clubName, info: info));
  }

  Future<Club> getClub({required int clubId}) async {
    return await clubApiProvider.getClub(clubId: clubId);
  }

  Future<Club> updateClub({required int clubId, required Club club}) async {
    return await clubApiProvider.updateClubInfo(
        clubId: clubId, request: ClubRequest.forUpdate(club: club));
  }

  Future<Club> updateClubImage(
      {required int clubId, required XFile image}) async {
    var compressedImage = await CompressUtils.compressImageFile(image);

    if (compressedImage == null) {
      throw ImageCompressionException();
    }

    return await clubApiProvider.updateClubImage(
        clubId: clubId, image: compressedImage);
  }

  /// ClubInviteCode
  Future<ClubInviteCode> createInviteCode({required int clubId}) async {
    return await clubInviteCodeApiProvider.createClubInviteCode(clubId: clubId);
  }

  Future<int> findClubIdByInviteCode({required String inviteCode}) async {
    var inviteCodeDto = await clubInviteCodeApiProvider.findClubIdByInviteCode(
        inviteCode: inviteCode);

    if (!inviteCodeDto.verify!) {
      throw ClubNotFoundException();
    }

    return inviteCodeDto.clubId!;
  }

  /// ClubManager
  Future<List<ClubManager>> getClubManagersByClubId(
      {required int clubId}) async {
    return clubManagerApiProvider.getClubManagersByClubId(clubId: clubId);
  }

  Future<ClubManager> createClubManager(
      {required int clubId,
      required String name,
      required List<ClubAuthorityType> authorityTypes,
      String? description}) async {
    return clubManagerApiProvider.createClubManager(
        clubId: clubId,
        request: ClubManagerRequest.forCreate(
            clubId: clubId,
            name: name,
            authorityTypes: authorityTypes,
            description: description));
  }

  Future<ClubManager> updateClubManager(
      {required ClubManager clubManager}) async {
    return clubManagerApiProvider.updateClubManager(
        clubId: clubManager.clubId,
        request: ClubManagerRequest.forUpdate(clubManager: clubManager));
  }

  Future<void> deleteClubManager({required ClubManager clubManager}) async {
    return await clubManagerApiProvider.deleteClubManager(
        clubId: clubManager.clubId,
        request: ClubManagerRequest.forDelete(clubManager: clubManager));
  }
}
