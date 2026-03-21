import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opket/components/app_container.dart';
import 'package:opket/components/app_icon_button_rectangle.dart';
import 'package:opket/components/bottomsheet_grabber.dart';
import 'package:opket/components/call_button.dart';
import 'package:opket/constants/app_icons.dart';
import 'package:opket/core/spacing.dart';
import 'package:opket/cubit/cool_down_cubit.dart';
import 'package:opket/feat/dashboard/widgets/call_taxi_header.dart';
import 'package:opket/feat/dashboard/widgets/recenter_button.dart';

class RequestRideSheetNew extends StatelessWidget {
  const RequestRideSheetNew({super.key, required this.onRecenter});
  final VoidCallback onRecenter;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Column(
        children: [
          AppContainer(
            bottom: true,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: AppSpacing.md),
                RecenterButton(onTap: onRecenter),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ).copyWith(bottom: 8, top: 15),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: const [
                BoxShadow(blurRadius: 15, color: Colors.black12),
              ],
              color: Colors.white,
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BottomsheetGrabber(),
                  BlocBuilder<CoolDownCubit, CoolDownState>(
                    builder: (context, coolDownState) {
                      if (coolDownState is! CoolDownInActive)
                        return Container();
                      return CallTaxiHeader();
                    },
                  ),
                  SizedBox(height: AppSpacing.sm_md),
                  Row(
                    children: [
                      Expanded(
                        child: AppIconButtonRectangle(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          backgroundColor: Colors.grey.shade200,
                          icon: AppIcons.chevronLeft,
                          text: "Orqaga",
                        ),
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(child: CallButton()),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
