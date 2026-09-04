import 'package:flutter/material.dart';
import 'package:smsforward/core/colors.dart';

class AddIconButton extends StatelessWidget {
  const AddIconButton({super.key, required this.callback});

  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(primary),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
        )),
      ),
      onPressed: () => callback(),
      icon: const Icon(Icons.add, color: Colors.white, size: 20,),
    );
  }
}
