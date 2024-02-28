import 'package:dplanner/controllers/club.dart';
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

class ClubHomePage extends StatefulWidget {
  const ClubHomePage({super.key});

  @override
  State<ClubHomePage> createState() => _ClubHomePageState();
}

class _ClubHomePageState extends State<ClubHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController searchPost = TextEditingController();
  bool _isFocused = false;
  late List<Post> _posts;

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
    final response = await http.get(Uri.parse('http://your-api-url/posts'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      setState(() {
        _posts = responseData.map((data) => Post.fromJson(data)).toList();
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
                    ? ListView.builder(
                        itemCount: _posts.length,
                        itemBuilder: (context, index) {
                          final post = _posts[index];
                          return PostCard(post: post);
                        },
                      )
                    : Center(child: CircularProgressIndicator()),

                //Container(
                //  color: AppColor.backgroundColor,
                //  height: SizeController.to.screenHeight * 0.01,
                //),
                //const PostCard(),
                //Container(
                //  height: SizeController.to.screenHeight * 0.01,
                //),
                //const PostCard(),
                //Container(
                //  height: SizeController.to.screenHeight * 0.01,
                //),
                //const PostCard(),
                //Container(
                //  height: SizeController.to.screenHeight * 0.01,
                //),
                //const PostCard(),
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
