import 'package:flutter/material.dart';
import 'package:smsforward/widgets/back_icon_button.dart';

import '../../core/text_styles.dart';

class AddEmailChannelScreen extends StatelessWidget {
  const AddEmailChannelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        title: Text('이메일 채널', style: textStyleW600(fontSize: 18)),
        leading: const BackIconButton(),
      ),
      body: SafeArea(child: Column(
        children: [

        ],
      )),
    );
  }
}
