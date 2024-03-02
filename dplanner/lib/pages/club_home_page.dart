import 'package:dplanner/controllers/club.dart';
import 'package:dplanner/const.dart';
import 'package:dplanner/controllers/size.dart';
import 'package:dplanner/pages/notification_page.dart';
import 'package:dplanner/pages/post_add_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../style.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/outline_textform.dart';
import '../widgets/post_card.dart';
import 'package:dplanner/models/post_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ClubHomePage extends StatefulWidget {
  const ClubHomePage({super.key});

  @override
  State<ClubHomePage> createState() => _ClubHomePageState();
}

class _ClubHomePageState extends State<ClubHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController searchPost = TextEditingController();
  bool _isFocused = false;
  List<Post>? _posts;
  String temp = '';

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  @override
  void dispose() {
    searchPost.dispose();
    super.dispose();
  }

  Future<void> _fetchPosts() async {
    const storage = FlutterSecureStorage();

    String? accessToken = await storage.read(key: accessTokenKey);
    temp =
        'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI1MDg1MyIsInJlY2VudF9jbHViX2lkIjoxLCJjbHViX21lbWJlcl9pZCI6MTA0MywiaXNzIjoiZHBsYW5uZXIiLCJpYXQiOjE3MDkzNzE5OTgsImV4cCI6MTcwOTU1MTk5OH0.cI6GclGk93kuBpwQ_abXWKfGURJlZNft58zZc_CmMCk';
    final response = await http.get(
        Uri.parse('http://3.39.102.31:8080/posts/clubs/1?size=10&page=0'),
        headers: {
          'Authorization': 'Bearer $temp',
        });
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData =
          jsonDecode(utf8.decode(response.bodyBytes));
      final List<dynamic> content = responseData['data']['content'];
      setState(() {
        _posts = content.map((data) => Post.fromJson(data)).toList();
      });
    } else {
      throw Exception('Failed to load posts');
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
                icon: const Icon(SFSymbols.menu)),
            title: Text(
              ClubController.to.club().clubName,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Get.to(const NotificationPage(), arguments: 1);
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
          child: SingleChildScrollView(
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
                _posts != null
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        child: ListView.separated(
                          itemCount: _posts!.length, //null 아닐때만 이 분기로 들어오므로
                          itemBuilder: (context, index) {
                            final post = _posts![index];
                            return PostCard(post: post);
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(
                                  height: 10, color: Colors.transparent),
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () {
            Get.to(const PostAddPage());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.objectColor,
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(15),
          ),
          child: const Icon(
            SFSymbols.pencil,
            color: AppColor.backgroundColor,
          ),
        ),
        bottomNavigationBar: const BottomBar());
  }
}
