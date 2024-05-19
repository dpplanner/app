import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:dplanner/services/club_post_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';

import '../widgets/my_activity_posts.dart';

class MyActivityCheckPage extends StatelessWidget {
  const MyActivityCheckPage({super.key});

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
          title: const Text(
            "내 활동보기",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          centerTitle: true,
        ),
      ),
      body: ContainedTabBarView(
        tabs: const [
          Text(
            "내 게시글",
          ),
          Text(
            "댓글 단 글",
          ),
          Text(
            "좋아요한 글",
          ),
        ],
        tabBarProperties: const TabBarProperties(
            height: 48.0,
            indicatorColor: AppColor.objectColor,
            indicatorWeight: 3.0,
            labelColor: AppColor.objectColor,
            labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            unselectedLabelColor: AppColor.textColor,
            unselectedLabelStyle:
            TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        views: const [
          MyActivityPosts(fetchPosts: PostApiService.fetchMyPosts),
          MyActivityPosts(fetchPosts: PostApiService.fetchCommentedPosts),
          MyActivityPosts(fetchPosts: PostApiService.fetchLikedPosts),
        ],
      ),
    );
  }
}
