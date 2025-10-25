import 'package:flutter/material.dart';

class LongTextInfoRow extends StatelessWidget {
  final String title;
  final String content;

  const LongTextInfoRow({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(content, style: Theme.of(context).textTheme.bodyLarge),
              )
            ],
          ),
        ],
      ),
    );
  }
}
