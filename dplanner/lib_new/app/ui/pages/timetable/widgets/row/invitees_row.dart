import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import '../../../../../data/model/reservation/reservation_invitee.dart';
import '../../../../base/widgets/overlapping_profile_images.dart';

class InviteesRow extends StatelessWidget {
  final String title;
  final List<ReservationInvitee> invitees;
  final VoidCallback? onTap;

  const InviteesRow({
    super.key,
    required this.title,
    required this.invitees,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sortedInvitees = [...invitees]..sort((a, b) {
        final aHasImage = a.profileImageUrl?.isNotEmpty == true;
        final bHasImage = b.profileImageUrl?.isNotEmpty == true;
        return (bHasImage ? 1 : 0) - (aHasImage ? 1 : 0);
      });

    final imageUrls = sortedInvitees.map((e) => e.profileImageUrl).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      _getInviteesName(sortedInvitees),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  const SizedBox(width: 4),
                  if (invitees.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(SFSymbols.person_crop_circle_fill_badge_plus),
                    )
                  else
                    OverlappingProfileImages(imageUrls: imageUrls)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getInviteesName(List<ReservationInvitee> list) {
    if (list.isEmpty) return '';
    if (list.length >= 2) {
      return "${list[0].name} 외 ${list.length - 1}명";
    } else {
      return list[0].name;
    }
  }
}
