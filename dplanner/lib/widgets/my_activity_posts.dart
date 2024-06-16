import 'dart:async';

import 'package:dplanner/controllers/member.dart';
import 'package:dplanner/widgets/post_mini_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/posts.dart';
import '../pages/loading_page.dart';
import '../const/style.dart';
import 'banner_ad_widget.dart';

class MyActivityPosts extends StatefulWidget {
  final Future<void> Function(int clubMemberID, int page) fetchPosts;

  const MyActivityPosts({super.key, required this.fetchPosts});

  @override
  State<MyActivityPosts> createState() => _MyActivityPostsState();
}

class _MyActivityPostsState extends State<MyActivityPosts> {
  int _currentPage = 0;
  final RxBool _isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    _isLoading.value = true;
    await widget.fetchPosts(MemberController.to.clubMember().id, _currentPage++);
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
    return LayoutBuilder(
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
                      return Column(
                        children: [
                          const BannerAdWidget(),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                                minHeight: constraints.maxHeight),
                            child: Container(
                              color: AppColor.backgroundColor2,
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
                            ),
                          ),
                        ],
                      );
                    } else {
                      return ConstrainedBox(
                        constraints: BoxConstraints(minHeight: constraints.maxHeight),
                        child: Container(
                            color: AppColor.backgroundColor2,
                            child: Column(
                              children: [
                                const BannerAdWidget(),
                                const SizedBox(height: 8,),
                                Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 24),
                                    child: Column(
                                      children: List.generate(
                                          PostController.to.posts.length,
                                              (index) => Padding(
                                            padding: const EdgeInsets.only(bottom: 12.0),
                                            child: PostMiniCard(
                                              id: PostController.to.posts[index].value.id,
                                              title: PostController.to.posts[index].value.title ?? '제목 없음',
                                              content: PostController.to.posts[index].value.content,
                                              dateTime: PostController.to.posts[index].value.createdTime,
                                              isPhoto: PostController.to.posts[index].value.attachmentsUrl.isNotEmpty,
                                            ),
                                          )
                                      ),
                                    )
                                ),
                              ],
                            )
                        ),
                      );
                    }
                  })),
            )));
  }
}
