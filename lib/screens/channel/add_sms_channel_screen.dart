import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../core/colors.dart';
import '../../core/text_styles.dart';
import '../../models/channel/channel_type.dart';
import '../../models/channel/sms_channel.dart';
import '../../provider/channel_provider.dart';
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
  final TextEditingController recipientPhoneNumberController = TextEditingController();
  bool isSmsPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      isSmsPermissionGranted = await Permission.sms.status.isGranted;
      setState(() {});
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    recipientPhoneNumberController.dispose();
    super.dispose();
  }

  Future<void> saveChannel() async {
    final name = nameController.text.trim();
    final recipientPhoneNumber = recipientPhoneNumberController.text.trim();
    if (name.isEmpty || recipientPhoneNumber.isEmpty) {
      // TODO 필수 항목 미입력 경고
      return;
    }

    final channel = SmsChannel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: ChannelType.sms,
      name: name,
      isActive: true,
      recipientPhoneNumber: recipientPhoneNumber,
    );

    await context.read<ChannelProvider>().addChannel(channel);
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> sendTest() async {}

  Future<void> requestSmsPermission() async {
    final status = await Permission.sms.request();

    setState(() {
      isSmsPermissionGranted = status.isGranted;
    });
  }

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
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Column(
                    children: [const _WarningMessage(), _smsChannelForm()],
                  ),
                ),
              ),
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
          controller: recipientPhoneNumberController,
          keyboardType: TextInputType.phone,
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
            Text(
              isSmsPermissionGranted ? '문자 권한이 허용되어 있습니다.' : '문자 권한을 허용해주세요.',
              style: textStyleW500(color: isSmsPermissionGranted ? textPrimary : Colors.red),
            ),
            const Spacer(),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                overlayColor: Colors.transparent,
              ),
              onPressed: requestSmsPermission,
              child: Text('권한 요청', style: textStyleW700(color: primary)),
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
              child: Text('!', style: textStyleW900(color: Colors.white)),
            ),
          ),
          Expanded(
            child: Column(
              spacing: 2,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '문자 발송 요금이 부과될 수 있어요',
                  style: textStyleW700(color: onWarningContainer, fontSize: 14),
                ),
                Text(
                  '기기의 문자 기능으로 보내므로 통신사 요금제가 적용됩니다.',
                  style: textStyleW400(fontSize: 12, color: onWarningContainer),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
