import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/size.dart';
import '../style.dart';

class ClubCreateSuccessPage extends StatefulWidget {
  const ClubCreateSuccessPage({super.key});

  @override
  State<ClubCreateSuccessPage> createState() => _ClubCreateSuccessPageState();
}

class _ClubCreateSuccessPageState extends State<ClubCreateSuccessPage> {
  final sizeController = Get.put((SizeController()));

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      //Get.offNamed('/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: AppColor.backgroundColor,
          automaticallyImplyLeading: false,
          title: const Text(
            "클럽 만들기",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
          ),
          centerTitle: true,
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: sizeController.screenHeight.value * 0.3),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "클럽",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
              ),
              Text(
                " Dance P.O.zz ",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
              ),
              Text(
                "를",
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
              ),
            ],
          ),
          const Text(
            "만들었어요!",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
          ),
          SizedBox(height: sizeController.screenHeight.value * 0.005),
          const Text(
            "더 다양하게 클럽을 꾸미고 싶다면",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
          ),
          const Text(
            "설정에서 바꿀 수 있어요",
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
          ),
        ],
      ),
    );
  }
}
