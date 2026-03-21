import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Support extends StatelessWidget {
  const Support({super.key});

  Future<void> _openTelegram() async {
    final Uri telegramUrl = Uri.parse('https://t.me/Opket_admin');

    await launchUrl(telegramUrl, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        elevation: 20,
      ),
      onPressed: _openTelegram,
      icon: const Icon(Icons.support_agent_rounded, color: Colors.black),
    );
  }
}
