import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsforward/models/filter/filter.dart';
import 'package:smsforward/provider/filter_provider.dart';
import 'package:smsforward/widgets/custom_switch.dart';

import '../../core/text_styles.dart';
import '../../widgets/back_icon_button.dart';

class DetailFilterScreen extends StatelessWidget {
  const DetailFilterScreen({super.key, required this.filter});

  final Filter filter;

  @override
  Widget build(BuildContext context) {
    final filterProvider = context.watch<FilterProvider>();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: -5,
        title: Text('필터 상세', style: textStyleW600(fontSize: 18)),
        leading: const BackIconButton(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(filter.name, style: textStyleW700(
                        fontSize: 20
                    ),),
                  ),
                  CustomSwitch(
                    isActive: filter.isActive,
                    onChanged: (value) =>
                        filterProvider.toggleFilterActive(filter.id),
                  ),
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  Container(
                    width: double.infinity,
                    height: 80,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
