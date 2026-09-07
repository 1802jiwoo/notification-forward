import 'package:flutter/material.dart';
import 'package:smsforward/core/colors.dart';
import 'package:smsforward/core/text_styles.dart';

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.title,
    required this.callback,
    this.isEnabled = true,
  });

  final String title;
  final VoidCallback callback;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        backgroundColor: WidgetStateProperty.all(
          isEnabled ? Colors.white : background,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        side: WidgetStateProperty.all(const BorderSide(color: primary)),
      ),
      onPressed: () => callback(),
      child: Text(
        title,
        style: isEnabled
            ? textStyleW900(color: primary)
            : textStyleW600(color: textSecondary),
      ),
    );
  }
}
