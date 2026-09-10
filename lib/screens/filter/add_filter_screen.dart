import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsforward/core/colors.dart';
import 'package:smsforward/core/text_styles.dart';
import 'package:smsforward/models/channel/channel.dart';
import 'package:smsforward/models/filter/filter.dart';
import 'package:smsforward/models/filter/keyword_match_target.dart';
import 'package:smsforward/models/installed_app.dart';
import 'package:smsforward/provider/channel_provider.dart';
import 'package:smsforward/provider/filter_provider.dart';
import 'package:smsforward/screens/filter/select_target_app_screen.dart';
import 'package:smsforward/widgets/custom_long_text_button.dart';
import 'package:smsforward/widgets/custom_switch.dart';
import 'package:smsforward/widgets/filter/channel_required_notice.dart';
import 'package:smsforward/widgets/form_field_row.dart';

import '../../widgets/back_icon_button.dart';
import '../../widgets/custom_text_fill_button.dart';
import '../../widgets/filter/add_keyword_sheet.dart';
import '../../widgets/tag_chip_list_field.dart';

class AddFilterScreen extends StatefulWidget {
  const AddFilterScreen({super.key});

  @override
  State<AddFilterScreen> createState() => _AddFilterScreenState();
}

class _AddFilterScreenState extends State<AddFilterScreen> {
  late final List<Channel> channels;

  final TextEditingController nameController = TextEditingController();
  List<InstalledApp> targetApps = [];
  final TextEditingController phoneNumberController = TextEditingController();
  List<String> keywords = [];
  KeywordMatchTarget keywordTarget = KeywordMatchTarget.titleOrBody;
  int? selectedChannelId;
  bool isActive = true;

  @override
  void initState() {
    super.initState();
    channels = context.read<ChannelProvider>().channels;
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> saveFilter() async {
    final name = nameController.text.trim();
    final phoneNumber = phoneNumberController.text.trim();
    if (name.isEmpty || selectedChannelId == null) {
      // TODO 필수 항목 미입력 경고
      return;
    }

    final filter = Filter(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      phoneNumber: phoneNumber.isEmpty ? null : phoneNumber,
      keywords: keywords,
      keywordTarget: keywordTarget,
      channelIds: [selectedChannelId!],
      isActive: isActive,
      targetApps: targetApps,
    );

    await context.read<FilterProvider>().addFilter(filter);
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> selectTargetApp() async {
    final result = await Navigator.push<List<InstalledApp>>(
      context,
      MaterialPageRoute(
        builder: (_) => SelectTargetAppScreen(targetApps: targetApps),
      ),
    );
    if (result != null) {
      setState(() => targetApps = result);
    }
  }

  void selectKeywordTarget(KeywordMatchTarget target) {
    setState(() {
      keywordTarget = target;
    });
  }

  void addKeyword() {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.white60,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AddKeywordSheet(
        keywords: keywords,
        addKeyword: (value) {
          final keyword = value.replaceAll(',', '').trim();
          if (keyword.isEmpty) return;
          if (keywords.length >= 5) {
            // TODO 키워드 갯수 5개 이상 불가 경고
            return;
          }
          if (keywords.contains(keyword)) {
            // TODO 같은 키워드 등록 불가 경고
            return;
          }
          setState(() {
            keywords.add(keyword);
          });
        },
        removeKeyword: removeKeyword,
      ),
    );
  }

  void removeKeyword(String keyword) {
    setState(() {
      keywords.remove(keyword);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        title: Text('필터 추가', style: textStyleW600(fontSize: 18)),
        leading: const BackIconButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: channels.isEmpty
              ? const ChannelRequiredNotice()
              : Stack(
                  children: [
                    Positioned.fill(child: _filterForm()),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CustomLongTextButton(
                        title: '저장',
                        callback: saveFilter,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _filterForm() => SingleChildScrollView(
    padding: const EdgeInsets.only(bottom: 130),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormFieldRow(
          title: '이름',
          child: TextField(
            controller: nameController,
            decoration: InputDecoration(
              isCollapsed: true,
              border: InputBorder.none,
              hintText: '필터 이름을 입력하세요',
              hintStyle: textStyleW500(color: textHint, fontSize: 15),
            ),
          ),
        ),
        FormFieldRow(
          title: '대상 앱',
          child: _TargetAppField(
            targetApps: targetApps,
            selectTargetApp: selectTargetApp,
          ),
        ),
        FormFieldRow(
          title: '발신번호',
          isPrimary: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: phoneNumberController,
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: '1234-1234, 12341234',
                  hintStyle: textStyleW500(color: textHint, fontSize: 15),
                ),
              ),
              Text(
                '비워두면 모든 번호 허용',
                style: textStyleW400(color: textTertiary, fontSize: 12),
              ),
            ],
          ),
        ),
        _KeywordField(
          keywordTarget: keywordTarget,
          keywords: keywords,
          selectKeywordTarget: selectKeywordTarget,
          onAdd: addKeyword,
          onRemove: removeKeyword,
        ),
        _ChannelField(
          channels: channels,
          selectedChannelId: selectedChannelId,
          selectChannel: (id) {
            setState(() {
              selectedChannelId = id;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('활성화', style: textStyleW600(fontSize: 16)),
              CustomSwitch(
                isActive: isActive,
                onChanged: (value) {
                  setState(() {
                    isActive = value;
                  });
                },
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class _TargetAppField extends StatelessWidget {
  const _TargetAppField({
    required this.targetApps,
    required this.selectTargetApp,
  });

  final List<InstalledApp> targetApps;
  final VoidCallback selectTargetApp;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: selectTargetApp,
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                spacing: 10,
                children: [
                  if (targetApps.isEmpty) const _AppItem(),
                  for (var app in targetApps) _AppItem(app: app),
                ],
              ),
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 12, color: textHint),
        ],
      ),
    );
  }
}

class _AppItem extends StatelessWidget {
  const _AppItem({this.app});

  final InstalledApp? app;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: app == null ? primaryContainer : null,
            image: app == null
                ? null
                : DecorationImage(image: MemoryImage(app!.icon)),
          ),
        ),
        Text(app == null ? '모든 앱' : app!.appName, style: textStyleW500()),
      ],
    );
  }
}

class _KeywordField extends StatelessWidget {
  const _KeywordField({
    required this.keywordTarget,
    required this.keywords,
    required this.selectKeywordTarget,
    required this.onAdd,
    required this.onRemove,
  });

  final KeywordMatchTarget keywordTarget;
  final List<String> keywords;
  final ValueChanged<KeywordMatchTarget> selectKeywordTarget;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TagChipListField(
            label: '키워드',
            items: keywords,
            onAdd: onAdd,
            onRemove: onRemove,
          ),
          Row(
            spacing: 10,
            children: [
              for (var target in KeywordMatchTarget.values)
                Expanded(
                  child: CustomFillTextButton(
                    title: target.label,
                    isEnabled: keywordTarget == target,
                    callback: () => selectKeywordTarget(target),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChannelField extends StatelessWidget {
  const _ChannelField({
    required this.channels,
    required this.selectedChannelId,
    required this.selectChannel,
  });

  final List<Channel> channels;
  final int? selectedChannelId;
  final ValueChanged<int> selectChannel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('보낼 채널', style: textStyleW600(color: textTertiary)),
        for (var channel in channels)
          _ChannelItem(
            channel: channel,
            selectedChannelId: selectedChannelId,
            selectChannel: selectChannel,
          ),
      ],
    );
  }
}

class _ChannelItem extends StatelessWidget {
  const _ChannelItem({
    required this.channel,
    this.selectedChannelId,
    required this.selectChannel,
  });

  final Channel channel;
  final int? selectedChannelId;
  final ValueChanged<int> selectChannel;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 80,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: line)),
      ),
      child: Row(
        spacing: 15,
        children: [
          Checkbox(
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            value: channel.id == selectedChannelId,
            activeColor: primary,
            side: const BorderSide(color: line2, width: 1.5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            onChanged: (value) => selectChannel(channel.id),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.discord, color: primary),
          ),
          Text(channel.name, style: textStyleW600(fontSize: 16)),
        ],
      ),
    );
  }
}
