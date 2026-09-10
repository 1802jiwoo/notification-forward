import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../core/text_styles.dart';
import '../../widgets/back_icon_button.dart';
import '../../widgets/custom_long_text_button.dart';
import '../../widgets/form_field_row.dart';

class AddSmsChannelScreen extends StatefulWidget {
  const AddSmsChannelScreen({super.key});

  @override
  State<AddSmsChannelScreen> createState() => _AddSmsChannelScreenState();
}

class _AddSmsChannelScreenState extends State<AddSmsChannelScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController webhookURLController = TextEditingController();
  final TextEditingController channelController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    webhookURLController.dispose();
    channelController.dispose();
    super.dispose();
  }

  Future<void> saveChannel() async {}

  Future<void> sendTest() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        title: Text('SMS 채널', style: textStyleW600(fontSize: 18)),
        leading: const BackIconButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Positioned.fill(child: SingleChildScrollView(child: Column(
                children: [
                  const _WarningMessage(),
                  _smsChannelForm()
                ],
              ))),
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

  Widget _smsChannelForm() => Column(
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
        title: '받는 번호',
        child: TextField(
          controller: nameController,
          decoration: InputDecoration(
            isCollapsed: true,
            border: InputBorder.none,
            hintText: '01012341234',
            hintStyle: textStyleW500(color: textHint, fontSize: 15),
          ),
        ),
      ),
      FormFieldRow(
        title: '문자 권한',
        child: Row(
          children: [
            Text('문자 권한 확인', style: textStyleW500(color: Colors.red),),
            const Spacer(),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                overlayColor: Colors.transparent,
              ),
              onPressed: () {

              },
              child: Text(
                '권한 요청',
                style: textStyleW700(color: primary),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

class _WarningMessage extends StatelessWidget {
  const _WarningMessage();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: warningContainer,
      ),
      child: Row(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: warning,
            ),
            child: Center(
              child: Text(
                '!',
                style: textStyleW900(color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('문자 발송 요금이 부과될 수 있어요', style: textStyleW700(
                  color: onWarningContainer,
                  fontSize: 14,
                ),),
                Text('기기의 문자 기능으로 보내므로 통신사 요금제가 적용됩니다.', style: textStyleW400(
                  fontSize: 12,
                  color: onWarningContainer,
                ),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

