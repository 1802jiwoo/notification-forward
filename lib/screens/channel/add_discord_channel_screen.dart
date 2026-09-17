import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../../core/app_channel.dart';
import '../../core/colors.dart';
import '../../core/text_styles.dart';
import '../../models/channel/channel_type.dart';
import '../../models/channel/discord_channel.dart';
import '../../provider/channel_provider.dart';
import '../../widgets/back_icon_button.dart';
import '../../widgets/custom_long_text_button.dart';
import '../../widgets/form_field_row.dart';

class AddDiscordChannelScreen extends StatefulWidget {
  const AddDiscordChannelScreen({super.key, this.editingChannel});

  final DiscordChannel? editingChannel;

  @override
  State<AddDiscordChannelScreen> createState() => _AddDiscordChannelScreenState();
}

class _AddDiscordChannelScreenState extends State<AddDiscordChannelScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController webhookURLController = TextEditingController();

  bool get isEditing => widget.editingChannel != null;

  @override
  void initState() {
    super.initState();
    final editingChannel = widget.editingChannel;
    if (editingChannel != null) {
      nameController.text = editingChannel.name;
      webhookURLController.text = editingChannel.webhookUrl;
    }
  }

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
      id: widget.editingChannel?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: ChannelType.discord,
      name: name,
      isActive: true,
      webhookUrl: webhookUrl,
    );

    await context.read<ChannelProvider>().addChannel(channel);
    if (!mounted) return;
    Navigator.pop(context);
  }

  bool isSendingTest = false;

  Future<void> sendTest() async {
    if (isSendingTest) return;

    final webhookUrl = webhookURLController.text.trim();
    if (webhookUrl.isEmpty) {
      // TODO 필수 항목 미입력 경고
      return;
    }

    setState(() => isSendingTest = true);

    final channel = DiscordChannel(
      id: widget.editingChannel?.id ?? 'test',
      type: ChannelType.discord,
      name: nameController.text.trim(),
      isActive: true,
      webhookUrl: webhookUrl,
    );

    final success = await AppChannel.instance.invokeMethod<bool>('testSend', {
      'channel': channel.toMap(),
      'title': '테스트 알림',
      'text': '알림 전달앱에서 보내는 테스트 메시지 입니다.',
    });

    if (!mounted) return;
    setState(() => isSendingTest = false);
    Fluttertoast.showToast(msg: success == true ? '테스트 전송 성공' : '테스트 전송 실패');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        title: Text(
          isEditing ? '디스코드 채널 수정' : '디스코드 채널',
          style: textStyleW600(fontSize: 18),
        ),
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
                        title: isSendingTest ? '전송 중...' : '테스트 전송',
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
