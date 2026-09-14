import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsforward/core/text_styles.dart';
import 'package:smsforward/models/filter/filter.dart';
import 'package:smsforward/provider/filter_provider.dart';
import 'package:smsforward/screens/filter/add_filter_screen.dart';
import 'package:smsforward/widgets/add_icon_button.dart';
import 'package:smsforward/widgets/custom_switch.dart';

import '../../core/colors.dart';
import '../../widgets/custom_text_fill_button.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  void addFilter() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => const AddFilterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filterProvider = context.watch<FilterProvider>();
    final filters = filterProvider.filters;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: Text('필터', style: textStyleW700()),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 20),
        actions: [AddIconButton(callback: () => addFilter())],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: filters.isEmpty
            ? _EmptyFilter(addFilter: addFilter)
            : ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 10),
                itemCount: filters.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, index) => _FilterItem(
                  filter: filters[index],
                  onActive: () =>
                      filterProvider.toggleFilterActive(filters[index].id),
                ),
              ),
      ),
    );
  }
}

class _EmptyFilter extends StatelessWidget {
  const _EmptyFilter({required this.addFilter});

  final VoidCallback addFilter;

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
          Text('아직 필터가 없어요', style: textStyleW700(fontSize: 20)),
          Text(
            '전달하고 싶은 알림 조건을 하나 만들어 두면 그때부터 자동\n으로 보내요.',
            style: textStyleW400(color: textTertiary),
            textAlign: TextAlign.center,
          ),
          CustomFillTextButton(title: '필터 추가하기', callback: () => addFilter()),
        ],
      ),
    );
  }
}

class _FilterItem extends StatelessWidget {
  const _FilterItem({required this.filter, required this.onActive});

  final Filter filter;
  final VoidCallback onActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: line),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(filter.name, style: textStyleW600(fontSize: 16)),
                RichText(
                  text: TextSpan(
                    style: textStyleW400(color: textTertiary),
                    children: [
                      const TextSpan(text: '키워드 "'),
                      for (var keyword in filter.keywords)
                        TextSpan(
                          text:
                              keyword +
                              (filter.keywords.last == keyword ? '' : ', '),
                        ),
                      const TextSpan(text: '"'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          CustomSwitch(
            isActive: filter.isActive,
            onChanged: (value) => onActive(),
          ),
        ],
      ),
    );
  }
}
