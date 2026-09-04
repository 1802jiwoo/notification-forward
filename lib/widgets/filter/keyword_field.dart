import 'package:flutter/material.dart';
import 'package:smsforward/widgets/filter/add_keyword_sheet.dart';

import '../../core/colors.dart';
import '../../core/text_styles.dart';
import '../../models/filter/keyword_match_target.dart';
import '../custom_text_fill_button.dart';
import 'package:dotted_border/dotted_border.dart';

import 'keyword_item.dart';

class KeywordField extends StatefulWidget {
  const KeywordField({
    super.key,
    required this.keywordTarget,
    required this.keywords,
    required this.selectKeywordTarget,
    required this.addKeyword,
    required this.removeKeyword,
  });

  final KeywordMatchTarget keywordTarget;
  final List<String> keywords;
  final ValueChanged<KeywordMatchTarget> selectKeywordTarget;
  final ValueChanged<String> addKeyword;
  final ValueChanged<String> removeKeyword;

  @override
  State<KeywordField> createState() => _KeywordFieldState();
}

class _KeywordFieldState extends State<KeywordField> {
  void showAddKeywordSheet() {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.white60,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AddKeywordSheet(
        keywords: widget.keywords,
        addKeyword: widget.addKeyword,
        removeKeyword: widget.removeKeyword,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('키워드', style: textStyleW600(color: textTertiary)),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (var keyword in widget.keywords)
                  KeywordItem(keyword: keyword, removeKeyword: widget.removeKeyword),
                GestureDetector(
                  onTap: showAddKeywordSheet,
                  child: DottedBorder(
                    options: const RoundedRectDottedBorderOptions(
                      radius: Radius.circular(200),
                      color: line2,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      dashPattern: [5, 2],
                    ),
                    child: Text(
                      '+ 추가',
                      style: textStyleW500(color: textTertiary),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            spacing: 10,
            children: [
              for (var target in KeywordMatchTarget.values)
                Expanded(
                  child: CustomFillTextButton(
                    title: target.label,
                    isEnabled: widget.keywordTarget == target,
                    callback: () => widget.selectKeywordTarget(target),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
