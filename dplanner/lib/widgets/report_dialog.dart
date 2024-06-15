import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../controllers/member.dart';
import '../controllers/size.dart';
import '../const/report_message.dart';
import '../services/club_post_api_service.dart';
import '../const/style.dart';

class ReportDialog extends StatefulWidget {
  final int targetId;
  final String targetType;

  const ReportDialog({required this.targetId, required this.targetType, Key? key}) : super(key: key);

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  String? reportMessage;
  String? warningMessage;
  bool isNotSelected = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColor.backgroundColor,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Center(
          child: Text(
            widget.targetType == "POST" ? "게시글 신고" : "댓글 신고",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ),
      ),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    hint: Align(
                        alignment: Alignment.center,
                        child: Text("신고 사유를 선택해주세요", style: TextStyle(fontSize: 14, color: isNotSelected ? AppColor.markColor : AppColor.textColor2))
                    ),
                    items: ReportMessage.types()
                        .map((message) => DropdownMenuItem<String>(
                      value: message,
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          message,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppColor.textColor
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    )).toList(),
                    value: reportMessage,
                    onChanged: (String? message) {
                      setState(() {
                        reportMessage = message!;
                        warningMessage = ReportMessage.getValue(reportMessage!);
                        isNotSelected = false;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      height: 40,
                      width: SizeController.to.screenWidth * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColor.backgroundColor,
                      ),
                    ),
                    iconStyleData: const IconStyleData(
                        icon: Padding(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: Icon(SFSymbols.chevron_down),
                        ),
                        iconSize: 15,
                        iconEnabledColor: AppColor.textColor

                    ),
                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 200,
                      width: SizeController.to.screenWidth * 0.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: AppColor.backgroundColor,
                      ),
                      direction: DropdownDirection.left,
                      offset: const Offset(0, 40),
                      scrollbarTheme: ScrollbarThemeData(
                        radius: const Radius.circular(40),
                        thickness: MaterialStateProperty.all<double>(6),
                        thumbVisibility: MaterialStateProperty.all<bool>(true),
                      ),
                    ),
                    menuItemStyleData:
                    const MenuItemStyleData(
                      height: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16,),
              warningMessage != null
                  ? Center(
                child: Column(
                  children: [
                    Text(
                      warningMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16,),
                  ],
                ),
              ) : const SizedBox.shrink(),
              const Center(
                child: Text(
                  ReportMessage.commonWarningMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: AppColor.textColor2),
                ),
              )
            ],
          );
        },
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: TextButton(
                onPressed: Get.back,
                child: const Text(
                  "취소",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColor.textColor2),
                ),
              ),
            ), Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12.0),
              child: TextButton(
                child: const Text(
                  "신고하기",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColor.markColor),
                ),
                onPressed: () async {
                  if (reportMessage == null) {
                    setState(() {
                      isNotSelected = true;
                    });
                    return;
                  }

                  try {
                    if (widget.targetType == "POST") {
                      await PostApiService.reportPost(
                          postId: widget.targetId,
                          clubMemberId: MemberController.to.clubMember().id,
                          reportMessage: reportMessage!
                      );
                    } else if (widget.targetType == "COMMENT") {
                      await PostCommentApiService.reportComment(
                          commentId: widget.targetId,
                          clubMemberId: MemberController.to.clubMember().id,
                          reportMessage: reportMessage!
                      );
                    }

                    Get.back(); // 다이얼로그 닫기
                    Get.back(); // 바텀시트 닫기
                    Get.snackbar('알림', '신고가 접수되었습니다.');
                  } catch (e) {
                    Get.back(); // 다이얼로그 닫기
                    Get.snackbar('알림', '게시글을 신고하지 못했습니다.');
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
