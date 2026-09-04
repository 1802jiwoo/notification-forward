import 'package:flutter/material.dart';

import '../core/colors.dart';

class CustomSwitch extends StatelessWidget {
  const CustomSwitch({
    super.key,
    required this.isActive,
    required this.onChanged,
  });

  final bool isActive;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isActive,
      activeTrackColor: primary,
      inactiveTrackColor: background,
      inactiveThumbColor: textHint,
      trackOutlineColor: WidgetStateProperty.all(isActive ? primary : line2),
      onChanged: onChanged,
    );
  }
}
