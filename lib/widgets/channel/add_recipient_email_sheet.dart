import 'package:flutter/material.dart';
import 'package:smsforward/widgets/custom_bottom_sheet.dart';
import 'package:smsforward/widgets/custom_long_text_button.dart';
import 'package:smsforward/widgets/tag_chip.dart';

import '../../core/colors.dart';
import '../../core/text_styles.dart';

class AddRecipientEmailSheet extends StatefulWidget {
  const AddRecipientEmailSheet({
    super.key,
    required this.recipientEmails,
    required this.onAdd,
    required this.onRemove,
  });

  final List<String> recipientEmails;
  final ValueChanged<String> onAdd;
  final ValueChanged<String> onRemove;

  @override
  State<AddRecipientEmailSheet> createState() => _AddRecipientEmailSheetState();
}

class _AddRecipientEmailSheetState extends State<AddRecipientEmailSheet> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onAdd() {
    final email = controller.text;

    if (email.contains(',')) {
      for (var value in email.split(',')) {
        widget.onAdd(value);
      }
    } else {
      widget.onAdd(email);
    }

    setState(() {
      controller.clear();
    });
  }

  void onRemove(String email) {
    setState(() {
      widget.onRemove(email);
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
              Text('받는 사람 추가', style: textStyleW600(fontSize: 18)),
              Text(
                '${widget.recipientEmails.length}/5',
                style: textStyleW400(color: textTertiary),
              ),
            ],
          ),
          const SizedBox(height: 15),
          TextField(
            controller: controller,
            onChanged: (value) {
              if (value.contains(',')) {
                onAdd();
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
                onPressed: onAdd,
                child: Text('추가', style: textStyleW600(color: primary)),
              ),
              helperText: '쉼표로 여러 주소를 한 번에 넣을 수 있어요.',
              helperStyle: textStyleW400(color: textTertiary, fontSize: 13),
            ),
          ),
          const SizedBox(height: 20),
          Text('추가된 주소', style: textStyleW600(color: textTertiary)),
          const SizedBox(height: 10),
          SingleChildScrollView(
            clipBehavior: Clip.none,
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 10,
              children: [
                for (var email in widget.recipientEmails)
                  TagChip(label: email, onRemove: onRemove),
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
                Text('이렇게 보내져요', style: textStyleW600(color: textTertiary)),
                const SizedBox(height: 5),
                RichText(
                  text: TextSpan(
                    style: textStyleW400(color: textSecondary),
                    children: [
                      const TextSpan(text: '추가한 주소 '),
                      TextSpan(
                        text: '전체',
                        style: textStyleW700(color: textSecondary),
                      ),
                      const TextSpan(text: '에게 같은 알림이 갑니다.\n보내는 주소는 '),
                      TextSpan(
                        text: '이전에 입력한 주소',
                        style: textStyleW700(color: primary),
                      ),
                      const TextSpan(text: '로 표시돼요.'),
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
