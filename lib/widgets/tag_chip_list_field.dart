import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:smsforward/widgets/tag_chip.dart';

import '../core/colors.dart';
import '../core/text_styles.dart';

class TagChipListField extends StatelessWidget {
  const TagChipListField({
    super.key,
    required this.label,
    required this.items,
    required this.onAdd,
    required this.onRemove,
  });

  final String label;
  final List<String> items;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textStyleW600(color: textTertiary)),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (var item in items)
                  TagChip(
                    label: item,
                    onRemove: onRemove,
                  ),
                GestureDetector(
                  onTap: onAdd,
                  child: DottedBorder(
                    options: const RoundedRectDottedBorderOptions(
                      radius: Radius.circular(200),
                      color: line2,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      dashPattern: [5, 2],
                    ),
                    child: Text(
                      '+ 추가',
                      style: textStyleW500(color: textTertiary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}