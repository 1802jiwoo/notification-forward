import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsforward/provider/channel_provider.dart';
import 'package:smsforward/widgets/channel/channel_item.dart';
import 'package:smsforward/widgets/channel/channel_type_item.dart';
import 'package:smsforward/widgets/custom_bottom_sheet.dart';

import '../../core/colors.dart';
import '../../core/text_styles.dart';
import '../../models/channel/channel_type.dart';
import '../../widgets/add_icon_button.dart';
import '../../widgets/channel/channel_type_ui.dart';
import '../../widgets/custom_text_fill_button.dart';

class ChannelScreen extends StatefulWidget {
  const ChannelScreen({super.key});

  @override
  State<ChannelScreen> createState() => _ChannelScreenState();
}

class _ChannelScreenState extends State<ChannelScreen> {
  Future<void> addChannel() async {
    await showModalBottomSheet(
      context: context,
      barrierColor: Colors.white60,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const _SelectChannelTypeSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final channel = context.watch<ChannelProvider>().channels;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Text('채널', style: textStyleW700()),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
        actions: [AddIconButton(callback: () => addChannel())],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: channel.isEmpty
            ? _EmptyChannel(addChannel: addChannel)
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: channel.length,
                itemBuilder: (context, index) =>
                    ChannelItem(channel: channel[index], onTap: () {}),
              ),
      ),
    );
  }
}

class _EmptyChannel extends StatelessWidget {
  const _EmptyChannel({required this.addChannel});

  final VoidCallback addChannel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        spacing: 15,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 40,
            backgroundColor: background,
            child: Icon(Icons.tune, color: primary, size: 40),
          ),
          Text('등록된 채널이 없어요', style: textStyleW700(fontSize: 20)),
          Text(
            '알림을 받을 곳을 하나 등록하면 규칙에서 골라 쓸 수 있어요.\n이메일 · 디스코드 · 슬랙 · SMS',
            style: textStyleW400(color: textTertiary),
            textAlign: TextAlign.center,
          ),
          CustomFillTextButton(title: '채널 등록하기', callback: () => addChannel()),
        ],
      ),
    );
  }
}

class _SelectChannelTypeSheet extends StatelessWidget {
  const _SelectChannelTypeSheet();

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('어떤 채널을 추가할까요?', style: textStyleW600(fontSize: 18)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              spacing: 10,
              children: [
                for (var type in ChannelType.values)
                  ChannelTypeItem(
                    type: type,
                    onTap: () {
                      Navigator.pop(context);
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
          ),
        ],
      ),
    );
  }
}
