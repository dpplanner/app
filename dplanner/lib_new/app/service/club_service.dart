import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';

import '../data/model/club/club.dart';
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

  Future<Club> createClub({required Club club}) async {
    return await clubApiProvider.createClub(
        request: ClubRequest.forCreate(club: club));
  }

  Future<Club> getClub({required int clubId}) async {
    return await clubApiProvider.getClub(clubId: clubId);
  }

  Future<Club> updateClub({required int clubId, required Club club}) async {
    return await clubApiProvider.updateClubInfo(
        clubId: clubId, request: ClubRequest.forUpdate(club: club));
  }

  Future<Club> updateClubImage(
      {required int clubId, required XFile? image}) async {
    var compressedImage = await CompressUtils.compressImageFile(image!);
    return await clubApiProvider.updateClubImage(
        clubId: clubId, image: compressedImage!);
  }

  /// ClubInviteCode
  Future<ClubInviteCode> createInviteCode({required int clubId}) async {
    return await clubInviteCodeApiProvider.createClubInviteCode(clubId: clubId);
  }

  Future<int> findClubIdByInviteCode({required String inviteCode}) async {
    var inviteCodeDto = await clubInviteCodeApiProvider.findClubIdByInviteCode(
        inviteCode: inviteCode);

    if (!inviteCodeDto.verify) {
      // 클럽 초대코드가 유효하지 않음
      // todo 커스텀 예외로 변경 -> view나 viewmodel에서 catch 하여 스낵바 노출
      throw Exception("클럽 초대코드가 유효하지 않음");
    }

    return inviteCodeDto.clubId;
  }

  /// ClubManager
  Future<List<ClubManager>> getClubManagersByClubId(
      {required int clubId}) async {
    return clubManagerApiProvider.getClubManagersByClubId(clubId: clubId);
  }

  Future<ClubManager> createClubManager(
      {required int clubId, required ClubManager clubManager}) async {
    return clubManagerApiProvider.createClubManager(
        clubId: clubId,
        request: ClubManagerRequest.forCreate(clubManager: clubManager));
  }

  Future<ClubManager> updateClubManager(
      {required ClubManager clubManager}) async {
    return clubManagerApiProvider.createClubManager(
        clubId: clubManager.clubId,
        request: ClubManagerRequest.forUpdate(clubManager: clubManager));
  }

  void deleteClubManager({required ClubManager clubManager}) async {
    clubManagerApiProvider.deleteClubManager(
        clubId: clubManager.clubId,
        request: ClubManagerRequest.forDelete(clubManager: clubManager));
  }
}
