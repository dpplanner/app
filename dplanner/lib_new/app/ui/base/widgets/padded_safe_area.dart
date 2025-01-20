import 'package:flutter/cupertino.dart';

class PaddedSafeArea extends StatelessWidget {
  final Widget child;
  const PaddedSafeArea({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: child
        )
    );
  }
}