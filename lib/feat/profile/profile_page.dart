import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:opket/components/app_container.dart';
import 'package:opket/components/app_icon_button_rectangle.dart';
import 'package:opket/components/authentication_wrapper.dart';
import 'package:opket/components/loading_overlay.dart';
import 'package:opket/components/toast_service.dart';
import 'package:opket/core/spacing.dart';
import 'package:opket/cubit/create_user_cubit.dart';
import 'package:opket/feat/dashboard/widgets/turnon_notification_dialog.dart';
import 'package:opket/feat/profile/cubit/delete_account_cubit.dart';
import 'package:opket/services/user_storage.dart';
import 'package:opket/utils/extensions.dart';
import 'package:opket/utils/show_bottom_sheet.dart';

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
    Future.delayed(Duration.zero, () async {
      final value = await UserStorage().getPhone();

      setState(() {
        phone = value;
      });
    });

    _showNotificationsDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<DeleteAccountCubit, DeleteAccountState>(
      listener: (context, state) {
        if (state is DeleteAccountSuccess) {
          setState(() {
            phone = null;
          });
          ToastService.showAutoHide("Akkauntingiz muvaffaqiyatli o'chirildi");
        }
      },
      builder: (context, state) {
        return LoadingOverlay(
          isLoading: state is DeleteAccountLoading,

          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: Text("Profil"),
            ),
            body: AppContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BlocListener<CreateUserCubit, CreateUserState>(
                    listener: (context, state) {
                      if (state is CreateUserSuccess) {
                        setState(() {
                          phone = state.phone;
                        });
                      }
                    },
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          if (phone != null)
                            Text(
                              phone.toString().addUzbCode().formatUzbekPhone(),
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
                                const AuthenticationWrapper(),
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
                  SizedBox(height: 25),
                  AppInfoSection(phone: phone),
                ],
              ),
            ),
          ),
        );
      },
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
