import 'package:flutter/material.dart';
import 'package:smsforward/models/channel/channel_type.dart';
import 'package:smsforward/widgets/channel/channel_type_ui.dart';

import '../../core/colors.dart';
import '../../core/text_styles.dart';

class ChannelTypeItem extends StatelessWidget {
  const ChannelTypeItem({
    super.key,
    required this.type,
    required this.onTap,
  });

  final ChannelType type;
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
          child: SizedBox(width: 24, child: type.icon),
        ),
        title: Text(type.title, style: textStyleW600(fontSize: 16)),
        subtitle: Text(type.subtitle, style: textStyleW400(color: textTertiary)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 12, color: textHint),
      ),
    );
  }
}
