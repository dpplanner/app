import 'package:flutter/material.dart';

import '../widgets/bottom_bar.dart';

class ClubMyPage extends StatelessWidget {
  const ClubMyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(bottomNavigationBar: const BottomBar());
  }
}
