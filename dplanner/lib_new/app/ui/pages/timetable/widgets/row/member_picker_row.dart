import 'package:flutter/material.dart';

import '../../../../../data/model/club/club_member.dart';
import '../../../../base/widgets/label.dart';
import '../../../../base/widgets/profile_image.dart';

class MemberPickerRow extends StatelessWidget {
  final ClubMember clubMember;
  final bool isSelected;
  final bool multipleSelect;
  final void Function(ClubMember) onSelected;

  const MemberPickerRow({
    super.key,
    required this.clubMember,
    required this.isSelected,
    required this.multipleSelect,
    required this.onSelected,
  });

  String getLabelName() {
    if (clubMember.isAdmin()) {
      return "관리자";
    } else {
      return clubMember.clubAuthorityName!;
    }
  }

  bool showLabel() {
    if (clubMember.isAdmin() || clubMember.isManager()) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ProfileImage(profileImageUrl: clubMember.url),
          const SizedBox(width: 12),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  clubMember.name,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(width: 8),
                if (showLabel()) Label(getLabelName())
              ],
            ),
          ),
          if (multipleSelect)
            Checkbox(value: isSelected, onChanged: (_) => onSelected(clubMember))
          else
            Radio<ClubMember>(
                value: clubMember,
                groupValue: isSelected ? clubMember : null,
                onChanged: (_) => onSelected(clubMember))
        ],
      ),
    );
  }
}
