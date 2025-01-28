import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading; // 왼쪽 버튼(default = dplanner 로고 이미지)
  final Widget? title; // 가운데 문구
  final List<Widget>? actions; // 오른쪽 버튼 - 가장 오른쪽 버튼은 오른쪽 패딩 16 픽셀

  const BaseAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    actions?.last = Padding(
        padding: EdgeInsets.only(right: 16.0), child: actions?.last);

    return AppBar(
      leadingWidth: MediaQuery.of(context).size.width * 0.25,
      leading: leading ??
          SvgPicture.asset(
            'assets/images/base_image/dplanner_logo_mini.svg',
            fit: BoxFit.none,
          ),
      title: title,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
