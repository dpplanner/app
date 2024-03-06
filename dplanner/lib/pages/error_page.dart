import 'package:flutter/material.dart';

import '../style.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: AppColor.backgroundColor,
          scrolledUnderElevation: 0,
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "에러가 발생하였습니다.",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 72),
            ),
            Text(
              "앱을 다시 실행해주세요.",
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 72),
            ),
          ],
        ),
      ),
    );
  }
}
