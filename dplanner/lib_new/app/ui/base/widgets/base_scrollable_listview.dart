import 'package:flutter/material.dart';

class BaseScrollableListView extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final List<Widget> children;

  const BaseScrollableListView({
    super.key,
    required this.onRefresh,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: children,
      ),
    );
  }

}