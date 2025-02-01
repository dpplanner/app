import 'package:flutter/cupertino.dart';

class HalfButtonFrame extends StatelessWidget {
  final Widget child;
  const HalfButtonFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
      child: SizedBox(
        width: (MediaQuery.of(context).size.width - 2 * 32.0) / 2,
        child: child,
      ),
    );
  }
}