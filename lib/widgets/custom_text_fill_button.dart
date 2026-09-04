import 'package:flutter/material.dart';
import 'package:smsforward/core/colors.dart';
import 'package:smsforward/core/text_styles.dart';

class CustomFillTextButton extends StatelessWidget {
  const CustomFillTextButton({
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
          isEnabled ? primary : background,
        ),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      ),
      onPressed: () => callback(),
      child: Text(
        title,
        style: isEnabled
            ? textStyleW900(color: Colors.white)
            : textStyleW600(color: textSecondary),
      ),
    );
  }
}
