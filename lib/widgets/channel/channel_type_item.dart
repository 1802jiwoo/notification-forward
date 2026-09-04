import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../core/text_styles.dart';

class ChannelTypeItem extends StatelessWidget {
  const ChannelTypeItem({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Widget icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: line),
      ),
      child: ListTile(
        onTap: onTap,
        leading: ColorFiltered(
          colorFilter: const ColorFilter.mode(textSecondary, BlendMode.srcIn),
          child: SizedBox(width: 24, child: icon),
        ),
        title: Text(title, style: textStyleW600(fontSize: 16)),
        subtitle: Text(subtitle, style: textStyleW400(color: textTertiary)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: textHint),
      ),
    );
  }
}
