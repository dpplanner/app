import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  final BoxConstraints constraints;
  const ErrorPage({super.key, this.constraints = const BoxConstraints()});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Center(
          child: Column(
            children: [
              Text(
                "에러가 발생하였습니다.\n앱을 다시 실행해주세요.",
                style: Theme.of(context).textTheme.bodyMedium
              ),
            ],
          ),
        ));
  }
}