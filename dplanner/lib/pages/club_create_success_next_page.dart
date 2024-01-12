import 'package:flutter/material.dart';

import '../style.dart';

class ClubCreateSuccessNext extends StatefulWidget {
  const ClubCreateSuccessNext({super.key});

  @override
  State<ClubCreateSuccessNext> createState() => _ClubCreateSuccessNextState();
}

class _ClubCreateSuccessNextState extends State<ClubCreateSuccessNext> {
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
        ));
  }
}
