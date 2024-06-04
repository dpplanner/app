import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/controllers/size.dart';
import 'package:dplanner/pages/post_add_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'dart:async';

import '../controllers/posts.dart';
import '../style.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/post_card.dart';

import 'loading_page.dart';

class ClubHomePage extends StatefulWidget {
  const ClubHomePage({super.key});

  @override
  State<ClubHomePage> createState() => _ClubHomePageState();
}

class _ClubHomePageState extends State<ClubHomePage> {
  // final _formKey = GlobalKey<FormState>();
  // final TextEditingController searchPost = TextEditingController();
  // bool _isFocused = false;
  // String temp = '';
  // bool _hasNextPage = true;
  int _currentPage = 0;
  final RxBool _isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    _isLoading.value = true;
    await PostController.to.fetchPosts(ClubController.to.club().id, _currentPage++);
    _isLoading.value = false;
  }

  void _onScrollNotification(ScrollNotification scrollInfo) {
    if (scrollInfo is ScrollEndNotification &&
        scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      _fetchPosts(); // 스크롤이 끝에 도달하면 다음 페이지의 포스트를 로드
    }
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
                Get.offAllNamed('/club_list');
              },
              icon: const Icon(SFSymbols.menu),
            ),
            title: Text(
              ClubController.to.club().clubName,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Get.toNamed('/notification', arguments: 1);
                },
                icon: const Icon(
                  SFSymbols.bell,
                  color: AppColor.textColor,
                ),
              ),
              SizedBox(width: SizeController.to.screenWidth * 0.05)
            ],
            automaticallyImplyLeading: false,
            centerTitle: true,
          ),
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // todo 검색 기능 구현 이후 주석 해제
              // Container(
              //   color: AppColor.backgroundColor,
              //   child: Padding(
              //     padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
              //     child: Form(
              //         key: _formKey,
              //         child: OutlineTextForm(
              //           hintText: '게시글 제목, 내용, 작성자를 검색해보세요',
              //           controller: searchPost,
              //           isColored: true,
              //           icon: Icon(
              //             SFSymbols.search,
              //             color: _isFocused
              //                 ? AppColor.objectColor
              //                 : AppColor.textColor2,
              //           ),
              //           onChanged: (value) {
              //             setState(() {
              //               _isFocused = value.isNotEmpty;
              //             });
              //           },
              //         )),
              //   ),
              // ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) => RefreshIndicator(
                    onRefresh: () async {
                      setState(() {
                        _currentPage = 0;
                      });
                      _fetchPosts();
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          _onScrollNotification(scrollInfo);
                          return true;
                        },
                        child: Obx(() {
                          if (_isLoading.value) {
                            return LoadingPage(constraints: constraints);
                          } else if (PostController.to.posts.isEmpty) {
                            return ConstrainedBox(
                              constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      "게시글이 없어요",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return ConstrainedBox(
                                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                                child: Column(
                                  children: List.generate(
                                      PostController.to.posts.length,
                                          (index) => Column(children: [
                                        Container(
                                            width: SizeController.to.screenWidth,
                                            height: 10,
                                            color: AppColor.backgroundColor2),
                                        PostCard(rxPost: PostController.to.posts[index]),
                                      ])),
                                )
                            );
                          }
                        }),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () {
            Get.to(PostAddPage(clubID: ClubController.to.club().id)); //게시글
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.objectColor,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(20),
          ),
          child: const Icon(
            SFSymbols.pencil,
            color: AppColor.backgroundColor,
          ),
        ),
        bottomNavigationBar: const BottomBar());
  }
}
