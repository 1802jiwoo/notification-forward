import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../core/text_styles.dart';

class KeywordItem extends StatelessWidget {
  const KeywordItem({
    super.key,
    required this.keyword,
    required this.removeKeyword,
  });

  final String keyword;
  final ValueChanged<String> removeKeyword;

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
          Text(keyword, style: textStyleW500()),
          InkWell(
            onTap: () => removeKeyword(keyword),
            child: const Icon(Icons.close, color: textPrimary, size: 20),
          ),
        ],
      ),
    );
  }
}
