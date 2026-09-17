import 'package:flutter/material.dart';
import 'package:smsforward/widgets/custom_bottom_sheet.dart';
import 'package:smsforward/widgets/custom_long_text_button.dart';
import 'package:smsforward/widgets/tag_chip.dart';

import '../../core/colors.dart';
import '../../core/text_styles.dart';

class AddKeywordSheet extends StatefulWidget {
  const AddKeywordSheet({
    super.key,
    required this.keywords,
    required this.addKeyword,
    required this.removeKeyword,
  });

  final List<String> keywords;
  final ValueChanged<String> addKeyword;
  final ValueChanged<String> removeKeyword;

  @override
  State<AddKeywordSheet> createState() => _AddKeywordSheetState();
}

class _AddKeywordSheetState extends State<AddKeywordSheet> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void addKeyword() {
    final keyword = controller.text;

    if (keyword.contains(',')) {
      for (var value in keyword.split(',')) {
        widget.addKeyword(value);
      }
    } else {
      widget.addKeyword(keyword);
    }

    setState(() {
      controller.clear();
    });
  }

  void removeKeyword(String keyword) {
    setState(() {
      widget.removeKeyword(keyword);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('키워드 추가', style: textStyleW600(fontSize: 18)),
              Text(
                '${widget.keywords.length}/5',
                style: textStyleW400(color: textTertiary),
              ),
            ],
          ),
          const SizedBox(height: 15),
          TextField(
            controller: controller,
            onChanged: (value) {
              if (value.contains(',')) {
                addKeyword();
              }
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 15,
              ),
              isCollapsed: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: line2, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(color: primary, width: 1.5),
              ),
              suffixIcon: TextButton(
                style: TextButton.styleFrom(overlayColor: Colors.transparent),
                onPressed: addKeyword,
                child: Text('추가', style: textStyleW600(color: primary)),
              ),
              helperText: '쉼표로 여러 개를 한 번에 넣을 수 있어요.',
              helperStyle: textStyleW400(color: textTertiary, fontSize: 13),
            ),
          ),
          const SizedBox(height: 20),
          Text('추가된 키워드', style: textStyleW600(color: textTertiary)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 10,
              children: [
                for (var keyword in widget.keywords)
                  TagChip(label: keyword, onRemove: removeKeyword),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: background,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('이렇게 걸러져요', style: textStyleW600(color: textTertiary)),
                const SizedBox(height: 5),
                if (widget.keywords.isEmpty)
                  Text(
                    '키워드가 없으면 대상 앱의 모든 알림을 전달합니다.',
                    style: textStyleW400(color: textSecondary),
                  )
                else
                  RichText(
                    text: TextSpan(
                      style: textStyleW400(color: textSecondary),
                      children: [
                        const TextSpan(text: '키워드 중 '),
                        TextSpan(
                          text: '하나라도',
                          style: textStyleW700(color: textSecondary),
                        ),
                        const TextSpan(text: ' 들어 있으면 전달합니다.\n예: "[Web발신] 카드 '),
                        TextSpan(
                          text: '승인',
                          style: textStyleW700(color: primary),
                        ),
                        const TextSpan(text: ' 5,600원" → 전달'),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          CustomLongTextButton(
            title: '완료',
            showGradient: false,
            callback: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(height: MediaQuery.viewInsetsOf(context).bottom),
        ],
      ),
    );
  }
}
