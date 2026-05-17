import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/core/constants/app_icons.dart';
import 'package:opket/core/constants/app_icons_v3.dart';

import 'package:opket/core/widgets/app_container.dart';
import 'package:opket/core/widgets/app_icon_button_rectangle.dart';
import 'package:opket/core/widgets/custom_back_button.dart';
import 'package:opket/core/theme/spacing.dart';
import 'package:opket/feat/auth/presentation/auth_page.dart';
import 'package:opket/feat/auth/presentation/cubit/auth_cubit.dart';
import 'package:opket/feat/auth/presentation/cubit/otp_cubit.dart';
import 'package:opket/feat/auth/presentation/cubit/otp_state.dart';
import 'package:opket/feat/dashboard/widgets/turnon_notification_dialog.dart';
import 'package:flutter/services.dart';
import 'package:opket/feat/profile/cubit/referral_code_cubit.dart';
import 'package:opket/core/services/user_storage.dart';
import 'package:opket/core/utils/extensions.dart';
import 'package:opket/core/utils/show_bottom_sheet.dart';
import 'package:opket/feat/balance/cubit/balance_cubit.dart';
import 'package:opket/feat/profile/custom_card.dart';
import 'package:opket/feat/profile/single_setting_container.dart';

import 'app_info_section.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int? phone;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final value = await UserStorage().getPhone();
      setState(() => phone = value);
    });

    context.read<BalanceCubit>().loadBalance();
    context.read<ReferralCodeCubit>().load();
    _showNotificationsDialog();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
              scrolledUnderElevation: 0,
              backgroundColor: Colors.white,
              centerTitle: true,
              // title: Text("Profil"),
              leading: CustomBackButton(),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: AppContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MultiBlocListener(
                        listeners: [
                          BlocListener<AuthCubit, AuthState>(
                            listener: (context, state) {
                              if (state is UnAuthenticated) {
                                setState(() => phone = null);
                                context.read<BalanceCubit>().reset();
                              }
                            },
                          ),
                          BlocListener<OtpCubit, OtpState>(
                            listener: (context, state) {
                              if (state.step == OtpStep.registered) {
                                setState(() => phone = state.phone);
                              }
                            },
                          ),
                        ],
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              if (phone != null)
                                Text(
                                  phone
                                      .toString()
                                      .addUzbCode()
                                      .formatUzbekPhone(),
                                  style: TextStyle(fontSize: 24),
                                ),
                              SizedBox(height: AppSpacing.sm),
                              AppIconButtonRectangle(
                                text: phone == null
                                    ? "Akkaunt yaratish"
                                    : "O'zgartirish",
                                onPressed: () {
                                  showAppModelBottomSheet(
                                    context,
                                    const AuthPage(),
                                  );
                                },
                                size: AppButtonSize.extraSmall,
                                width: AppButtonWidth.wrap,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.lg),
                      BlocBuilder<BalanceCubit, BalanceState>(
                        builder: (context, balanceState) {
                          final balance = balanceState is BalanceSuccess
                              ? balanceState.balance
                              : null;
                          return CustomCard(
                            padding: EdgeInsets.all(0),
                            child: SingleSettingContainer(
                              icondata: AppIconsV3.mmoneyIcon,
                              title: "Bonuslarim",
                              rightContent: Text(
                                balance != null
                                    ? "${balance.formatWithThousands()} so'm"
                                    : "— so'm",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      if (phone != null) ...[
                        SizedBox(height: AppSpacing.md),
                        _ReferralCodeCard(),
                      ],
                      SizedBox(height: AppSpacing.md),
                      AppInfoSection(phone: phone),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void _showNotificationsDialog() async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (isAllowed) return;

    await showDialog(
      context: context,
      builder: (context) {
        return TurnonNotificationDialog();
      },
    );
  }
}

class _ReferralCodeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      bgColor: Colors.white,
      child: BlocBuilder<ReferralCodeCubit, ReferralCodeState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Icon(
                    AppIcons.wallet,
                    size: 24,
                    color: const Color(0xFFFFCC00),
                  ),
                  SizedBox(width: AppSpacing.sm_md),
                  Text(
                    "Do'stingizni taklif qiling",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              Text(
                "Do'stingiz quyidagi kod orqali ro'yxatdan o'tsa, sizning balansingizga bonus qo'shiladi",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  height: 1.4,
                ),
              ),
              SizedBox(height: AppSpacing.md),
              if (state is ReferralCodeLoading)
                Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 1.5),
                  ),
                )
              else if (state is ReferralCodeLoaded)
                _ReferralCodeChip(code: state.code)
              else
                Text(
                  "Kod mavjud emas",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ReferralCodeChip extends StatefulWidget {
  const _ReferralCodeChip({required this.code});
  final String code;

  @override
  State<_ReferralCodeChip> createState() => _ReferralCodeChipState();
}

class _ReferralCodeChipState extends State<_ReferralCodeChip> {
  bool _copied = false;

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.code));
    setState(() => _copied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _copy,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm_md,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF9E0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFFE066), width: 1.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.code,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 4,
                color: Colors.black87,
                fontFamily: 'monospace',
              ),
            ),
            SizedBox(width: AppSpacing.md),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _copied
                  ? Icon(
                      Icons.check_rounded,
                      key: const ValueKey('check'),
                      color: Colors.green,
                      size: 22,
                    )
                  : Icon(
                      Icons.copy_rounded,
                      key: const ValueKey('copy'),
                      color: Colors.black54,
                      size: 22,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
