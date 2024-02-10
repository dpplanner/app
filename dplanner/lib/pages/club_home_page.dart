import 'package:dplanner/controllers/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import '../style.dart';
import '../widgets/bottom_bar.dart';
import '../widgets/outline_textform.dart';
import '../widgets/post_card.dart';

class ClubHomePage extends StatefulWidget {
  const ClubHomePage({super.key});

  @override
  State<ClubHomePage> createState() => _ClubHomePageState();
}

class _ClubHomePageState extends State<ClubHomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController searchPost = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.backgroundColor2,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
            backgroundColor: AppColor.backgroundColor,
            title: Padding(
              padding:
                  EdgeInsets.only(left: SizeController.to.screenWidth * 0.05),
              child: Row(
                children: [
                  const Text(
                    "Dance P.O.zz",
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      SFSymbols.info_circle,
                      color: AppColor.textColor,
                    ),
                  )
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  SFSymbols.bell,
                  color: AppColor.textColor,
                ),
              ),
              SizedBox(width: SizeController.to.screenWidth * 0.05)
            ],
            automaticallyImplyLeading: false,
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
                          icon: const Icon(
                            SFSymbols.search,
                            color: AppColor.textColor2,
                          ),
                        )),
                  ),
                ),
                Container(
                  color: AppColor.backgroundColor,
                  height: SizeController.to.screenHeight * 0.01,
                ),
                const PostCard(),
                Container(
                  height: SizeController.to.screenHeight * 0.01,
                ),
                const PostCard(),
                Container(
                  height: SizeController.to.screenHeight * 0.01,
                ),
                const PostCard(),
                Container(
                  height: SizeController.to.screenHeight * 0.01,
                ),
                const PostCard(),
              ],
            ),
          ),
        ),
        floatingActionButton: ElevatedButton(
          onPressed: () {},
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
