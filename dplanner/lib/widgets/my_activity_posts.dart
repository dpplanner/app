import 'dart:async';

import 'package:dplanner/controllers/member.dart';
import 'package:dplanner/models/post_model.dart';
import 'package:dplanner/widgets/post_mini_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../pages/error_page.dart';
import '../pages/loading_page.dart';
import '../style.dart';

class MyActivityPosts extends StatefulWidget {
  final Future<List<Post>> Function(
      {required int clubMemberID, required int page}) fetchPosts;

  const MyActivityPosts({super.key, required this.fetchPosts});

  @override
  State<MyActivityPosts> createState() => _MyActivityPostsState();
}

class _MyActivityPostsState extends State<MyActivityPosts> {
  final List<Post> _posts = [];
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
    super.dispose();
  }

  void _fetchPosts() async {
    if (!_hasNextPage) return;

    setState(() {
      _isLoading = true;
    });

    if (_currentPage == 0) _posts.clear();

    List<Post> posts = await widget.fetchPosts(
        clubMemberID: MemberController.to.clubMember().id, page: _currentPage);

    setState(() {
      _isLoading = false;
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
                  child: StreamBuilder<List<Post>>(
                      stream: _postsController.stream,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<Post>> snapshot) {
                        if (snapshot.data == null && !_isLoading) {
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
                        } else if (snapshot.hasError) {
                          return ErrorPage(constraints: constraints);
                        } else if (snapshot.connectionState ==
                                ConnectionState.waiting &&
                            snapshot.hasData == false) {
                          return LoadingPage(constraints: constraints);
                        } else {
                          return Container(
                            color: AppColor.backgroundColor2,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(18, 24, 24, 24),
                              child: Column(
                                children: List.generate(
                                    snapshot.data!.length,
                                    (index) => Padding(
                                      padding: const EdgeInsets.only(bottom: 12.0),
                                      child: PostMiniCard(
                                        id: snapshot.data![index].id,
                                        title: snapshot.data![index].title ?? '제목 없음',
                                        content: snapshot.data![index].content,
                                        dateTime: snapshot.data![index].createdTime,
                                        isPhoto: snapshot.data![index].attachmentsUrl.isNotEmpty,
                                      ),
                                    )
                                ),
                                  )
                              )
                            );
                        }
                      })),
            )));
  }
}
