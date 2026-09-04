import 'package:flutter/material.dart';

import 'custom_text_fill_button.dart';

class CustomLongTextFillButton extends StatelessWidget {
  const CustomLongTextFillButton({
    super.key,
    required this.title,
    required this.callback, this.showGradient = true,
  });

  final String title;
  final VoidCallback callback;
  final bool showGradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 20),
      height: showGradient ? 130 : null,
      decoration: BoxDecoration(
        gradient: showGradient ? const LinearGradient(
          colors: [Color(0x00FFFFFF), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.center,
        ) : null,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: CustomFillTextButton(
          title: title,
          callback: callback,
        ),
      ),
    );
  }
}
