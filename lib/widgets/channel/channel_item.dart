import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsforward/models/channel/channel.dart';
import 'package:smsforward/models/channel/channel_type.dart';
import 'package:smsforward/models/channel/discord_channel.dart';
import 'package:smsforward/models/channel/email_channel.dart';
import 'package:smsforward/models/channel/slack_channel.dart';
import 'package:smsforward/models/channel/sms_channel.dart';
import 'package:smsforward/provider/channel_provider.dart';
import 'package:smsforward/screens/channel/add_discord_channel_screen.dart';
import 'package:smsforward/screens/channel/add_email_channel_screen.dart';
import 'package:smsforward/screens/channel/add_slack_channel_screen.dart';
import 'package:smsforward/screens/channel/add_sms_channel_screen.dart';
import 'package:smsforward/widgets/channel/channel_type_ui.dart';

import '../../core/colors.dart';
import '../../core/text_styles.dart';

enum ChannelMenuAction { edit, delete }

class ChannelItem extends StatelessWidget {
  const ChannelItem({super.key, required this.channel, required this.onTap});

  final Channel channel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: line),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        onTap: onTap,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(primary, BlendMode.srcIn),
            child: SizedBox(width: 24, child: channel.type.icon),
          ),
        ),
        title: Text(channel.name, style: textStyleW600(fontSize: 16)),
        subtitle: Text(
          channel.type.title,
          style: textStyleW400(color: textTertiary),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        trailing: PopupMenuButton(
          color: background,
          style: ButtonStyle(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
          ),
          onSelected: (value) {
            switch (value) {
              case ChannelMenuAction.edit:
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => switch (channel.type) {
                      ChannelType.email => AddEmailChannelScreen(
                        editingChannel: channel as EmailChannel,
                      ),
                      ChannelType.discord => AddDiscordChannelScreen(
                        editingChannel: channel as DiscordChannel,
                      ),
                      ChannelType.slack => AddSlackChannelScreen(
                        editingChannel: channel as SlackChannel,
                      ),
                      ChannelType.sms => AddSmsChannelScreen(
                        editingChannel: channel as SmsChannel,
                      ),
                    },
                  ),
                );
              case ChannelMenuAction.delete:
                context.read<ChannelProvider>().deleteChannel(channel.id);
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: ChannelMenuAction.edit,
              child: Text('수정'),
            ),
            PopupMenuItem(
              value: ChannelMenuAction.delete,
              child: Text('삭제', style: textStyleW400(color: Colors.red)),
            ),
          ]
        ),
      ),
    );
  }
}
