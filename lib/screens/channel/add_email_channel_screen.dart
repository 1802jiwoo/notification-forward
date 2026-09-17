import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smsforward/widgets/channel/add_recipient_email_sheet.dart';
import 'package:smsforward/widgets/tag_chip_list_field.dart';
import 'package:smsforward/widgets/back_icon_button.dart';
import 'package:smsforward/widgets/form_field_row.dart';

import '../../core/app_channel.dart';
import '../../core/colors.dart';
import '../../core/text_styles.dart';
import '../../models/channel/channel_type.dart';
import '../../models/channel/email_channel.dart';
import '../../provider/channel_provider.dart';
import '../../widgets/custom_long_text_button.dart';

class AddEmailChannelScreen extends StatefulWidget {
  const AddEmailChannelScreen({super.key, this.editingChannel});

  final EmailChannel? editingChannel;

  @override
  State<AddEmailChannelScreen> createState() => _AddEmailChannelScreenState();
}

class _AddEmailChannelScreenState extends State<AddEmailChannelScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController senderEmailController = TextEditingController();
  final TextEditingController smtpHostController = TextEditingController();
  final TextEditingController smtpPortController = TextEditingController();
  final TextEditingController appPasswordController = TextEditingController();
  final List<String> recipientEmails = [];
  bool isPasswordVisible = false;

  bool get isEditing => widget.editingChannel != null;

  @override
  void initState() {
    super.initState();
    final editingChannel = widget.editingChannel;
    if (editingChannel != null) {
      nameController.text = editingChannel.name;
      senderEmailController.text = editingChannel.senderEmail;
      smtpHostController.text = editingChannel.smtpHost;
      smtpPortController.text = editingChannel.smtpPort;
      appPasswordController.text = editingChannel.appPassword;
      recipientEmails.addAll(editingChannel.recipientEmails);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    senderEmailController.dispose();
    smtpHostController.dispose();
    smtpPortController.dispose();
    appPasswordController.dispose();
    super.dispose();
  }

  Future<void> saveChannel() async {
    final name = nameController.text.trim();
    final senderEmail = senderEmailController.text.trim();
    final smtpHost = smtpHostController.text.trim();
    final smtpPort = smtpPortController.text.trim();
    final appPassword = appPasswordController.text.trim();
    if (name.isEmpty ||
        senderEmail.isEmpty ||
        smtpHost.isEmpty ||
        smtpPort.isEmpty ||
        appPassword.isEmpty ||
        recipientEmails.isEmpty) {
      // TODO 필수 항목 미입력 경고
      return;
    }

    final channel = EmailChannel(
      id: widget.editingChannel?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: ChannelType.email,
      name: name,
      isActive: true,
      senderEmail: senderEmail,
      smtpHost: smtpHost,
      smtpPort: smtpPort,
      appPassword: appPassword,
      recipientEmails: recipientEmails,
    );

    await context.read<ChannelProvider>().addChannel(channel);
    if (!mounted) return;
    Navigator.pop(context);
  }

  bool isSendingTest = false;

  Future<void> sendTest() async {
    if (isSendingTest) return;

    final senderEmail = senderEmailController.text.trim();
    final smtpHost = smtpHostController.text.trim();
    final smtpPort = smtpPortController.text.trim();
    final appPassword = appPasswordController.text.trim();
    if (senderEmail.isEmpty ||
        smtpHost.isEmpty ||
        smtpPort.isEmpty ||
        appPassword.isEmpty ||
        recipientEmails.isEmpty) {
      // TODO 필수 항목 미입력 경고
      return;
    }

    setState(() => isSendingTest = true);

    final channel = EmailChannel(
      id: widget.editingChannel?.id ?? 'test',
      type: ChannelType.email,
      name: nameController.text.trim(),
      isActive: true,
      senderEmail: senderEmail,
      smtpHost: smtpHost,
      smtpPort: smtpPort,
      appPassword: appPassword,
      recipientEmails: recipientEmails,
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

  void togglePasswordVisible() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  void addRecipientEmail() {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.white60,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AddRecipientEmailSheet(
        recipientEmails: recipientEmails,
        onAdd: (value) {
          final email = value.replaceAll(',', '').trim();
          if (email.isEmpty) return;
          if (recipientEmails.length >= 5) {
            // TODO 이메일 갯수 5개 이상 불가 경고
            return;
          }
          if (recipientEmails.contains(email)) {
            // TODO 같은 이메일 등록 불가 경고
            return;
          }
          setState(() {
            recipientEmails.add(email);
          });
        },
        onRemove: removeRecipientEmail,
      ),
    );
  }

  void removeRecipientEmail(String email) {
    setState(() {
      recipientEmails.remove(email);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        title: Text(
          isEditing ? '이메일 채널 수정' : '이메일 채널',
          style: textStyleW600(fontSize: 18),
        ),
        leading: const BackIconButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: [
              Positioned.fill(child: _emailChannelForm()),
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

  Widget _emailChannelForm() => SingleChildScrollView(
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
          title: '보내는 주소',
          child: TextField(
            controller: senderEmailController,
            decoration: InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              hintText: '발신용 이메일을 입력하세요',
              hintStyle: textStyleW500(color: textHint, fontSize: 15),
            ),
          ),
        ),
        Row(
          spacing: 15,
          children: [
            Expanded(
              child: FormFieldRow(
                title: 'SMTP',
                titleWidth: null,
                child: TextField(
                  controller: smtpHostController,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: 'SMTP 입력',
                    hintStyle: textStyleW500(
                      color: textHint,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 150,
              child: FormFieldRow(
                title: '포트',
                titleWidth: null,
                child: TextField(
                  controller: smtpPortController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: '포트 입력',
                    hintStyle: textStyleW500(
                      color: textHint,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        FormFieldRow(
          title: '앱 비밀번호',
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: appPasswordController,
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: '앱 비밀번호를 입력해주세요.',
                    hintStyle: textStyleW500(
                      color: textHint,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  overlayColor: Colors.transparent,
                ),
                onPressed: togglePasswordVisible,
                child: Text(
                  isPasswordVisible ? '숨기기' : '보기',
                  style: textStyleW400(color: textTertiary),
                ),
              ),
            ],
          ),
        ),
        TagChipListField(
          label: '받는 사람',
          items: recipientEmails,
          onAdd: addRecipientEmail,
          onRemove: removeRecipientEmail,
        ),
      ],
    ),
  );
}
