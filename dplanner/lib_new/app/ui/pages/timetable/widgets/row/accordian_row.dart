import 'package:flutter/material.dart';
import 'package:flutter_sfsymbols/flutter_sfsymbols.dart';

import '../../../../../../config/constants/app_colors.dart';

class AccordionRow extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const AccordionRow({super.key, required this.title, required this.children});

  @override
  State<AccordionRow> createState() => _AccordionRowState();
}

class _AccordionRowState extends State<AccordionRow> {
  bool isClipped = true;

  void toggleClipped() {
    setState(() {
      isClipped = !isClipped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: toggleClipped,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                Text(widget.title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: AppColors.textGray)),
                Icon(isClipped ? SFSymbols.chevron_down : SFSymbols.chevron_up,
                    color: AppColors.textGray, size: 18),
              ],
            ),
          ),
        ),
        if (!isClipped)
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Column(
              children: widget.children,
            ),
          )
      ],
    );
  }
}
