import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsforward/provider/forward_log_provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final forwardLogProvider = context.watch<ForwardLogProvider>();
    final forwardLogs = forwardLogProvider.forwardLogs;

    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
          itemCount: forwardLogs.length,
          itemBuilder: (context, index) => Text(forwardLogs[index].title ?? ''),
        ),
      ),
    );
  }
}
