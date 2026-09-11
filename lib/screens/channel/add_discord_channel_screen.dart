import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/colors.dart';
import '../../core/text_styles.dart';
import '../../models/channel/channel_type.dart';
import '../../models/channel/discord_channel.dart';
import '../../provider/channel_provider.dart';
import '../../widgets/back_icon_button.dart';
import '../../widgets/custom_long_text_button.dart';
import '../../widgets/form_field_row.dart';

class AddDiscordChannelScreen extends StatefulWidget {
  const AddDiscordChannelScreen({super.key});

  @override
  State<AddDiscordChannelScreen> createState() => _AddDiscordChannelScreenState();
}

class _AddDiscordChannelScreenState extends State<AddDiscordChannelScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController webhookURLController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    webhookURLController.dispose();
    super.dispose();
  }

  Future<void> saveChannel() async {
    final name = nameController.text.trim();
    final webhookUrl = webhookURLController.text.trim();
    if (name.isEmpty || webhookUrl.isEmpty) {
      // TODO 필수 항목 미입력 경고
      return;
    }

    final channel = DiscordChannel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: ChannelType.discord,
      name: name,
      isActive: true,
      webhookUrl: webhookUrl,
    );

    await context.read<ChannelProvider>().addChannel(channel);
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> sendTest() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        title: Text('디스코드 채널', style: textStyleW600(fontSize: 18)),
        leading: const BackIconButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Positioned.fill(child: _discordChannelForm()),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  spacing: 15,
                  children: [
                    Expanded(
                      child: CustomLongTextButton(
                        title: '테스트 전송',
                        callback: sendTest,
                        isFill: false,
                      ),
                    ),
                    Expanded(
                      child: CustomLongTextButton(
                        title: '저장',
                        callback: saveChannel,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _discordChannelForm() => SingleChildScrollView(
    child: Column(
      children: [
        FormFieldRow(
          title: '이름',
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              hintText: '채널 이름을 입력하세요',
              hintStyle: textStyleW500(color: textHint, fontSize: 15),
            ),
          ),
        ),
        FormFieldRow(
          title: '웹훅 URL',
          child: TextField(
            controller: webhookURLController,
            maxLines: null,
            decoration: InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              hintText: '웹훅 주소를 입력해주세요',
              hintStyle: textStyleW500(color: textHint, fontSize: 15),
            ),
          ),
        ),
      ],
    ),
  );
}
