import 'package:flutter/cupertino.dart';

class FullButton extends StatelessWidget {
  final Widget child;
  const FullButton({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width - 2 * 24.0,
        child: child,
      ),
    );
  }
}