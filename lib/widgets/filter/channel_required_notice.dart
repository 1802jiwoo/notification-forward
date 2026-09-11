import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smsforward/core/colors.dart';
import 'package:smsforward/core/text_styles.dart';
import 'package:smsforward/models/channel/channel_type.dart';
import 'package:smsforward/screens/channel/add_discord_channel_screen.dart';
import 'package:smsforward/screens/channel/add_email_channel_screen.dart';
import 'package:smsforward/screens/channel/add_slack_channel_screen.dart';
import 'package:smsforward/screens/channel/add_sms_channel_screen.dart';
import 'package:smsforward/widgets/channel/channel_type_item.dart';
import 'package:smsforward/widgets/channel/channel_type_ui.dart';

class ChannelRequiredNotice extends StatefulWidget {
  const ChannelRequiredNotice({super.key});

  @override
  State<ChannelRequiredNotice> createState() => _ChannelRequiredNoticeState();
}

class _ChannelRequiredNoticeState extends State<ChannelRequiredNotice> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        spacing: 10,
        children: [
          const SizedBox(height: 30),
          const CircleAvatar(
            radius: 40,
            backgroundColor: warningContainer,
            child: Icon(
              CupertinoIcons.exclamationmark,
              color: warning,
              size: 40,
            ),
          ),
          Text('등록된 채널이 없어요', style: textStyleW700(fontSize: 20)),
          Text(
            '알림을 어디로 보낼지 정해야 규칙을 만들 수 있어요. 등록을 마치면 여기로 돌아옵니다.',
            style: textStyleW400(color: textTertiary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('등록할 채널 종류', style: textStyleW600(color: textTertiary)),
          ),
          for (var type in ChannelType.values)
            ChannelTypeItem(
              type: type,
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => type.destinationScreen(),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
