import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/controllers/size.dart';
import 'package:dplanner/pages/post_add_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';
import 'dart:async';

import '../style.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/outline_textform.dart';
import '../widgets/post_card.dart';
import 'package:dplanner/models/post_model.dart';
import 'package:dplanner/services/club_post_api_service.dart';

import 'error_page.dart';
import 'loading_page.dart';

class ClubHomePage extends StatefulWidget {
  const ClubHomePage({super.key});

  @override
  State<ClubHomePage> createState() => _ClubHomePageState();
}

class _ClubHomePageState extends State<ClubHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController searchPost = TextEditingController();
  bool _isFocused = false;
  final List<Post> _posts = [];
  String temp = '';
  int _currentPage = 0;
  bool _hasNextPage = true;
  bool _isLoading = false;

  final StreamController<List<Post>> _postsController =
      StreamController<List<Post>>();

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  @override
  void dispose() {
    _postsController.close();
    searchPost.dispose();
    super.dispose();
  }

  Future<void> _fetchPosts() async {
    if (!_hasNextPage) return; // 다음 페이지가 없으면 요청을 중단합니다.
    setState(() {
      _isLoading = true; // 데이터를 불러오는 중임을 표시합니다.
    });
    if (_currentPage == 0) _posts.clear();

    final posts = await PostApiService.fetchPosts(
      clubID: ClubController.to.club().id,
      page: _currentPage++,
    );
    setState(() {
      _isLoading = false; // 데이터 불러오기가 완료되었음을 표시합니다.
    });

    if (posts.isNotEmpty) {
      setState(() {
        _posts.addAll(posts);
      });
      _postsController.add(_posts);
    } else {
      _hasNextPage = false; // 받아온 포스트가 없다면, 다음 페이지가 없는 것으로 간주합니다.
    }
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
              Container(
                color: AppColor.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 18, 0),
                  child: Form(
                      key: _formKey,
                      child: OutlineTextForm(
                        hintText: '게시글 제목, 내용, 작성자를 검색해보세요',
                        controller: searchPost,
                        isColored: true,
                        icon: Icon(
                          SFSymbols.search,
                          color: _isFocused
                              ? AppColor.objectColor
                              : AppColor.textColor2,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _isFocused = value.isNotEmpty;
                          });
                        },
                      )),
                ),
              ),
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
                              child: StreamBuilder<List<Post>>(
                                stream: _postsController.stream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<Post>> snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.waiting ||
                                      snapshot.hasData == false) {
                                    return LoadingPage(
                                        constraints: constraints);
                                  } else if (snapshot.hasError) {
                                    return ErrorPage(constraints: constraints);
                                  } else if (snapshot.data!.isEmpty &&
                                      !_isLoading) {
                                    return Column(
                                      children: [
                                        SizedBox(
                                          height:
                                              SizeController.to.screenHeight *
                                                  0.4,
                                        ),
                                        const Center(
                                          child: Text(
                                            "승인 대기중인 예약이 없어요",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      children: List.generate(
                                        snapshot.data!.length,
                                        (index) => Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 12.0),
                                            child: PostCard(
                                                post: snapshot.data![index])),
                                      ),
                                    );
                                  }
                                },
                              ),
                            )))),
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
