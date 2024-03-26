import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:dplanner/services/club_api_service.dart';
import 'package:dplanner/services/club_post_api_service.dart';
import 'package:dplanner/widgets/post_mini_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';
import 'package:dplanner/models/post_model.dart';
import 'package:dplanner/controllers/member.dart';

class MyActivityCheckPage extends StatefulWidget {
  const MyActivityCheckPage({super.key});

  @override
  State<MyActivityCheckPage> createState() => _MyActivityCheckPageState();
}

class _MyActivityCheckPageState extends State<MyActivityCheckPage> {
  List<Post> _myPosts = [];
  int _currentPage = 0;
  bool _isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _fetchMyPosts();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!_isLoading &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      _fetchMyPosts();
    }
  }

  Future<void> _fetchMyPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Post> newPosts = await PostApiService.fetchMyPosts(
          clubMemberID: MemberController.to.clubMember().id,
          page: _currentPage);
      setState(() {
        _myPosts.addAll(newPosts);
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching posts: $e');
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
            "내 댓글",
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
        views: [
          Container(
            color: AppColor.backgroundColor2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 24, 24, 24),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _myPosts.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index < _myPosts.length) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: PostMiniCard(
                        title: _myPosts[index].title ?? '제목 없음',
                        content: _myPosts[index].content,
                        date: '${_myPosts[index].createdTime}',
                        isPhoto: _myPosts[index].attachmentsUrl.isNotEmpty,
                      ),
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ),
          Container(
            color: AppColor.backgroundColor2,
          ),
          Container(
            color: AppColor.backgroundColor2,
          ),
        ],
      ),
    );
  }
}
