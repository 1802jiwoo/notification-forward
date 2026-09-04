import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smsforward/models/channel/channel_type.dart';

import '../../screens/channel/add_discord_channel_screen.dart';
import '../../screens/channel/add_email_channel_screen.dart';
import '../../screens/channel/add_slack_channel_screen.dart';
import '../../screens/channel/add_sms_channel_screen.dart';

extension ChannelTypeUi on ChannelType {
  Widget get icon => switch (this) {
    ChannelType.email => const Icon(Icons.email),
    ChannelType.discord => const Icon(Icons.discord),
    ChannelType.slack => SvgPicture.asset('assets/icons/logo-slack.svg'),
    ChannelType.sms => const Icon(Icons.sms),
  };

  String get title => switch (this) {
    ChannelType.email => '이메일',
    ChannelType.discord => '디스코드',
    ChannelType.slack => '슬랙',
    ChannelType.sms => 'SMS',
  };

  String get subtitle => switch (this) {
    ChannelType.email => 'SMTP · 지메일 앱 비밀번호로 연결',
    ChannelType.discord => '웹훅 주소만 붙여넣으면 끝',
    ChannelType.slack => '워크스페이스 웹훅으로 연결',
    ChannelType.sms => '통신사 요금이 발생할 수 있어요',
  };

  Widget destinationScreen() => switch (this) {
    ChannelType.email => const AddEmailChannelScreen(),
    ChannelType.discord => const AddDiscordChannelScreen(),
    ChannelType.slack => const AddSlackChannelScreen(),
    ChannelType.sms => const AddSmsChannelScreen(),
  };
}