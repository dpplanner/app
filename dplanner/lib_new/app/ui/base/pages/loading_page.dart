import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  final BoxConstraints constraints;
  const LoadingPage({super.key, this.constraints = const BoxConstraints()});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: constraints.maxHeight),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
