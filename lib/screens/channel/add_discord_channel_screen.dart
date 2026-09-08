import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../core/text_styles.dart';
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

  Future<void> saveChannel() async {}

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
