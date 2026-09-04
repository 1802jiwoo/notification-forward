import 'dart:typed_data';
import 'package:hive_ce/hive.dart';
import 'package:smsforward/models/channel/slack_channel.dart';
import 'package:smsforward/models/channel/sms_channel.dart';
import 'package:smsforward/models/filter/filter.dart';
import 'package:smsforward/models/filter/keyword_match_target.dart';
import 'package:smsforward/models/installed_app.dart';

import '../models/channel/channel_type.dart';
import '../models/channel/discord_channel.dart';
import '../models/channel/email_channel.dart';

@GenerateAdapters([
  AdapterSpec<ChannelType>(),
  AdapterSpec<DiscordChannel>(),
  AdapterSpec<EmailChannel>(),
  AdapterSpec<SlackChannel>(),
  AdapterSpec<SmsChannel>(),
  AdapterSpec<Filter>(),
  AdapterSpec<KeywordMatchTarget>(),
  AdapterSpec<InstalledApp>(),
])
part 'hive_adapters.g.dart';