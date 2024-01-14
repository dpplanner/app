import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageButton extends StatelessWidget {
  final String image;
  final VoidCallback onTap;
  const ImageButton({super.key, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2.0, right: 1.0),
        child: SvgPicture.asset(image),
      ),
    );
  }
}
