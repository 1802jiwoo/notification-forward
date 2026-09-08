import 'package:flutter/material.dart';

import '../core/colors.dart';
import '../core/text_styles.dart';

class TagChip extends StatelessWidget {
  const TagChip({super.key, required this.label, required this.onRemove});

  final String label;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(200),
        color: primaryContainer,
      ),
      child: Row(
        spacing: 5,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: textStyleW500()),
          InkWell(
            onTap: () => onRemove(label),
            child: const Icon(Icons.close, color: textPrimary, size: 20),
          ),
        ],
      ),
    );
  }
}
