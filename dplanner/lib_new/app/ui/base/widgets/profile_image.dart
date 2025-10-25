import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../utils/url_utils.dart';

class ProfileImage extends StatelessWidget {
  final String? profileImageUrl;
  final double size;

  const ProfileImage({super.key, this.profileImageUrl, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
        child: profileImageUrl != null && profileImageUrl!.isNotEmpty
            ? CachedNetworkImage(
                height: size,
                width: size,
                fit: BoxFit.fill,
                placeholder: (context, url) => Container(),
                imageUrl: UrlUtils.toHttps(profileImageUrl),
                errorWidget: (context, url, error) =>
                    SvgPicture.asset('assets/images/base_image/base_member_image.svg'))
            : SvgPicture.asset('assets/images/base_image/base_member_image.svg',
                height: size, width: size, fit: BoxFit.fill));
  }
}
