import 'package:dplanner/controllers/posts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../controllers/size.dart';
import '../const/style.dart';
import '../widgets/banner_ad_widget.dart';
import '../widgets/outline_textform.dart';
import '../widgets/underline_textform.dart';
import 'package:dplanner/models/post_model.dart';

class PostAddPage extends StatefulWidget {
  final bool isEdit;
  final Post? post;
  final int clubID;
  const PostAddPage(
      {Key? key, this.isEdit = false, this.post, required this.clubID})
      : super(key: key);

  @override
  State<PostAddPage> createState() => _PostAddPageState();
}

class _PostAddPageState extends State<PostAddPage> {
  final _formKey1 = GlobalKey<FormState>();
  late TextEditingController postSubject = TextEditingController();
  bool _isFocused1 = false;

  final _formKey2 = GlobalKey<FormState>();
  late TextEditingController postContent = TextEditingController();
  bool _isFocused2 = false;

  List<XFile> selectedImages = []; // 이미지를 저장할 리스트
  int maxImageCount = 10; // 최대 선택 가능한 이미지 수

  Future<void> pickImage() async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          selectedImages.add(image); // 선택한 이미지를 리스트에 추가
        });
      }
    } catch (e) {
      print('Error while picking an image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    // post가 null이 아닌 경우, 해당 post의 내용을 텍스트 필드에 채워넣기
    postSubject = TextEditingController(text: widget.post?.title ?? '');
    postContent = TextEditingController(text: widget.post?.content ?? '');
  }

  @override
  void dispose() {
    postSubject.dispose();
    postContent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: AppColor.backgroundColor,
          scrolledUnderElevation: 0,
          leadingWidth: SizeController.to.screenWidth * 0.2,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(SFSymbols.chevron_left)),
          title: Text(
            widget.isEdit ? "글 수정" : "글 쓰기",
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          actions: [
            TextButton(
              onPressed: widget.isEdit
                  ? () {
                PostController.to.updatePost(
                    postId: widget.post!.id,
                    title: postSubject.text,
                    content: postContent.text,
                    imageFileList: selectedImages,
                    previousImageFileList: widget.post!.attachmentsUrl);
              }
                  : () {
                      if (_formKey1.currentState!.validate() &&
                          _formKey2.currentState!.validate()) {
                        //TODO: 비어있지 않은 것 제대로 확인하도록 수정
                        PostController.to.createPost(
                            clubId: widget.clubID,
                            title: postSubject.text,
                            content: postContent.text,
                            imageFileList: selectedImages);
                      }
                    },
              child: const Text(
                "완료",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: AppColor.markColor),
              ),
            ),
            SizedBox(width: SizeController.to.screenWidth * 0.03)
          ],
          centerTitle: true,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const BannerAdWidget(),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: Form(
                  key: _formKey1,
                  child: UnderlineTextForm(
                    hintText: widget.isEdit ? postSubject.text : '제목을 입력하세요',
                    controller: postSubject,
                    isFocused: _isFocused1,
                    noLine: true,
                    fontSize: 20,
                    onChanged: (value) {
                      setState(() {
                        _isFocused1 = value.isNotEmpty;
                      });
                    },
                  )),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: Divider(
                color: AppColor.backgroundColor2,
                thickness: 2, // 줄의 색상 설정
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                child: Form(
                    key: _formKey2,
                    child: OutlineTextForm(
                      hintText: widget.isEdit ? postContent.text : '내용을 입력하세요',
                      controller: postContent,
                      isFocused: _isFocused2,
                      noLine: true,
                      fontSize: 16,
                      maxLines: 20,
                      onChanged: (value) {
                        setState(() {
                          _isFocused2 = value.isNotEmpty;
                        });
                      },
                    )),
              ),
            ),
            const Divider(
              color: AppColor.backgroundColor2,
              thickness: 2, // 줄의 색상 설정
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 2, // Adjust the flex value as needed
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 12, 12, 18),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            if (widget.isEdit) {
                              if (selectedImages.length +
                                      widget.post!.attachmentsUrl.length <
                                  maxImageCount) {
                                pickImage();
                              }
                            } else {
                              if (selectedImages.length < maxImageCount)
                                pickImage();
                            }
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: SvgPicture.asset(
                            'assets/images/base_image/base_post_image.svg',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3, // Adjust the flex value as needed
                  child: Container(
                    height:
                        100, // Set the height according to your requirements
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        if (widget.isEdit &&
                            widget.post!.attachmentsUrl != null)
                          ...widget.post!.attachmentsUrl!.map((url) {
                            String formattedUrl = url.startsWith('https://')
                                ? url
                                : 'https://$url';
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(formattedUrl), // 원격 이미지를 표시
                            );
                          }).toList(),
                        ...selectedImages.map((image) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Image.file(File(image.path),
                                  fit: BoxFit.fill), // 로컬 이미지를 표시
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
                Text(
                  '${selectedImages.length + (widget.post != null ? widget.post!.attachmentsUrl.length : 0)}/$maxImageCount',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: AppColor.textColor2,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
