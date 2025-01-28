import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../config/constants/app_colors.dart';
import '../../../../data/model/club/club.dart';

class ClubCard extends StatelessWidget {
  final Club club;
  final Future<void> Function(Club club)? onTap;

  const ClubCard({super.key, required this.club, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: (onTap == null)
          ? Colors.transparent
          : AppColors.subColor2.withOpacity(0.5),
      highlightColor: (onTap == null)
          ? Colors.transparent
          : AppColors.subColor2.withOpacity(0.5),
      borderRadius: BorderRadius.circular(16),
      onTap: () => onTap!(club),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.bgWhite,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: SizedBox(
            height: 104,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: club.url == null
                      ? SvgPicture.asset(
                          'assets/images/base_image/base_club_image.svg',
                          fit: BoxFit.fill)
                      : CachedNetworkImage(
                          placeholder: (context, url) => Container(),
                          imageUrl: "https://${club.url}",
                          errorWidget: (context, url, error) =>
                              SvgPicture.asset(
                                'assets/images/base_image/base_club_image.svg',
                              ),
                          fit: BoxFit.fill),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(club.clubName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleLarge),
                          ),
                          if (!(club.isConfirmed ?? false) && onTap != null)
                            Text("가입 진행 중",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: AppColors.primaryColor)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text("회원수: ${club.memberCount}",
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      Flexible(
                        child: Text(club.info,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
