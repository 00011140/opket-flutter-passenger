import 'package:flutter/material.dart';
import 'package:opket/feat/profile/custom_card.dart';
import 'package:opket/feat/profile/delete_account_confirmation.dart';
import 'package:opket/routes/route_names.dart';
import 'package:opket/services/app_version_reporter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'separator.dart';
import 'single_setting_container.dart';

class AppInfoSection extends StatefulWidget {
  const AppInfoSection({super.key, this.phone});
  final int? phone;

  @override
  State<AppInfoSection> createState() => _AppInfoSectionState();
}

class _AppInfoSectionState extends State<AppInfoSection> {
  String appVersion = "0.0.0";

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      final result = await AppVersionReporter.getAppVersion();

      setState(() {
        appVersion = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomCard(
          padding: EdgeInsets.all(0),
          child: Column(
            children: [
              SingleSettingContainer(
                onTap: () {
                  _openTelegram();
                },
                icondata: Icons.support_agent_outlined,
                title: "Qo'llab quvvatlash",
              ),
              Separator(),
              SingleSettingContainer(
                icondata: Icons.numbers,
                title: "Ilova versiyasi",
                rightContent: Text(
                  appVersion,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              Separator(),
              SingleSettingContainer(
                icondata: Icons.privacy_tip_outlined,
                onTap: _openPrivacyPolicy,
                title: "Maxfiylik siyosati",
              ),
              Separator(),
              SingleSettingContainer(
                icondata: Icons.error_outline_rounded,
                onTap: () {
                  Navigator.pushNamed(context, RouteNames.termsAndConditions);
                },
                title: "Foydalanish shartlari",
              ),
              Separator(),
              SingleSettingContainer(
                onTap: () {
                  // Share.share(
                  //   'Check out Bettered, the ultimate habit tracker app! Download now: https://play.google.com/store/apps/details?id=com.app.apexhabit', // Replace with your actual app link
                  //   subject: 'Join Bettered Today!',
                  // );
                },
                icondata: Icons.text_rotation_angleup_rounded,
                title: "Safarlarim",
                rightContent: Text(
                  "Tez kunda",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
              if (widget.phone != null) Separator(),
              if (widget.phone != null)
                SingleSettingContainer(
                  onTap: _deleteAccountConfirmation,
                  icondata: Icons.remove_circle_outline_sharp,
                  titleColor: Colors.red,
                  iconColor: Colors.red,
                  title: "Akkauntni o'chirish",
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _deleteAccountConfirmation() {
    showDialog(
      context: context,
      builder: (context) {
        return DeleteAccountConfirmationDialog();
      },
    );
  }

  Future<void> _openTelegram() async {
    final Uri telegramUrl = Uri.parse('https://t.me/Opket_admin');

    await launchUrl(telegramUrl, mode: LaunchMode.externalApplication);
  }

  Future<void> _openPrivacyPolicy() async {
    final Uri url = Uri.parse(
      'https://www.freeprivacypolicy.com/live/1da1d328-81b8-47ef-a3b8-45349e4d6a26',
    );

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }
}
