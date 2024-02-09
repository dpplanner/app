import 'package:dplanner/controllers/size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import '../style.dart';
import '../widgets/post_card.dart';

class ClubHomePage extends StatefulWidget {
  const ClubHomePage({super.key});

  @override
  State<ClubHomePage> createState() => _ClubHomePageState();
}

class _ClubHomePageState extends State<ClubHomePage> {
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
              icon: Padding(
                padding: EdgeInsets.only(
                    right: SizeController.to.screenWidth * 0.05),
                child: const Icon(
                  SFSymbols.bell,
                  color: AppColor.textColor,
                ),
              ),
            )
          ],
          automaticallyImplyLeading: false,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: SizeController.to.screenHeight * 0.01,
              ),
              PostCard(),
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
          SFSymbols.plus,
          color: AppColor.backgroundColor,
        ),
      ),
    );
  }
}
