import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:dplanner/widgets/post_mini_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';

class MyActivityCheckPage extends StatefulWidget {
  const MyActivityCheckPage({super.key});

  @override
  State<MyActivityCheckPage> createState() => _MyActivityCheckPageState();
}

class _MyActivityCheckPageState extends State<MyActivityCheckPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: AppColor.backgroundColor,
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
            child: const Padding(
              padding: EdgeInsets.fromLTRB(18, 24, 24, 24),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 12.0),
                      child: PostMiniCard(
                        title: "제목",
                        content: "내용",
                        date: "2023.11.09 18:01",
                        isPhoto: true,
                      ),
                    ),
                    PostMiniCard(
                      title: "제목",
                      content: "내용",
                      date: "2023.11.09 18:01",
                    )
                  ],
                ),
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
