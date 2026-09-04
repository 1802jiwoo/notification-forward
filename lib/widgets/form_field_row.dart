import 'package:flutter/material.dart';

import '../core/colors.dart';
import '../core/text_styles.dart';

class FormFieldRow extends StatelessWidget {
  const FormFieldRow({
    super.key,
    required this.title,
    required this.child,
    this.isPrimary = false,
  });

  final String title;
  final Widget child;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: line)),
      ),
      child: Row(
        crossAxisAlignment: isPrimary
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: isPrimary
                  ? textStyleW600(color: primary)
                  : textStyleW400(color: textTertiary),
            ),
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}