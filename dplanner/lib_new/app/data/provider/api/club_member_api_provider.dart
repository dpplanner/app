import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';

import '../../model/club/club_member.dart';
import '../../model/club/request/club_member_request.dart';
import '../../model/club/request/club_member_role_update_request.dart';
import '../../model/common_response.dart';
import 'base_api_provider.dart';

class ClubMemberApiProvider extends BaseApiProvider {
  Future<ClubMember> joinClub(
      {required int clubId, required ClubMemberRequest request}) async {
    var response =
        await post("/clubs/$clubId", request.toJson()) as CommonResponse;
    return ClubMember.fromJson(response.data);
  }

  Future<List<ClubMember>> getClubMembers(
      {required int clubId, required bool confirmed}) async {
    var response = await get("/clubs/$clubId/club-members",
        query: {"confirmed": confirmed}) as CommonResponse;
    var jsonList = response.data as List<Map<String, dynamic>>;

    return jsonList.map((message) => ClubMember.fromJson(message)).toList();
  }

  Future<ClubMember> getClubMember(
      {required int clubId, required int clubMemberId}) async {
    var response = await get("/clubs/$clubId/club-members/$clubMemberId")
        as CommonResponse;
    return ClubMember.fromJson(response.data);
  }

  Future<ClubMember> updateClubMemberInfo(
      {required int clubId,
      required int clubMemberId,
      required ClubMemberRequest request}) async {
    var response = await patch(
            "/clubs/$clubId/club-members/$clubMemberId", request.toJson())
        as CommonResponse;
    return ClubMember.fromJson(response.data);
  }

  Future<ClubMember> updateClubMemberProfileImage(
      {required int clubId,
      required int clubMemberId,
      required XFile image}) async {
    var formData =
        FormData({"file": MultipartFile(image, filename: image.name)});

    var response = await patch(
        "/clubs/$clubId/club-members/$clubMemberId/update-profile-image",
        formData) as CommonResponse;
    return ClubMember.fromJson(response.data);
  }

  Future<ClubMember> updateClubMemberRole(
      {required int clubId,
      required int clubMemberId,
      required ClubMemberRoleUpdateRequest request}) async {
    var response = await patch(
            "/clubs/$clubId/club-members/$clubMemberId/role", request.toJson())
        as CommonResponse;
    return ClubMember.fromJson(response.data);
  }

  void leaveClub({required int clubId, required int clubMemberId}) async {
    await delete("/clubs/$clubId/club-members/$clubMemberId");
  }

  void blockClubMember(
      {required int clubId, required int blockedClubMemberId}) async {
    await post("/clubs/$clubId/club-members/$blockedClubMemberId/block", null);
  }

  void confirmClubMember(
      {required int clubId, required ClubMemberRequest request}) async {
    await patch("/clubs/$clubId/club-members/confirm", request.toJson());
  }

  void rejectClubMember(
      {required int clubId, required ClubMemberRequest request}) async {
    await patch("/clubs/$clubId/club-members/reject", request.toJson());
  }

  void kickOutClubMember(
      {required int clubId, required int clubMemberId}) async {
    await delete("/clubs/$clubId/club-members/$clubMemberId/kickout");
  }
}
