import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final BoxConstraints constraints;
  const ErrorPage({super.key, this.constraints = const BoxConstraints()});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: const Center(
          child: Column(
            children: [
              Text(
                "에러가 발생하였습니다.",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              Text(
                "앱을 다시 실행해주세요.",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ],
          ),
        ));
  }
}
