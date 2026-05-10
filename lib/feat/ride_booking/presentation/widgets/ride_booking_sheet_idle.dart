part of '../index.dart';

class RideBookingSheetIdle extends StatelessWidget {
  const RideBookingSheetIdle({super.key, required this.onRecenter});
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: AppSpacing.sm),
                RecenterButton(onTap: onRecenter),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              // horizontal: 16,
            ).copyWith(bottom: 8, top: AppSpacing.sm),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 15,
                  // spreadRadius: 10,
                  color: Color.fromARGB(16, 0, 0, 0),
                ),
              ],
              color: Colors.white,
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BottomsheetGrabber(),
                  SizedBox(height: AppSpacing.sm),
                  RideOptionsInstant(),
                  SizedBox(height: AppSpacing.sm_md),
                  AppContainer(
                    child: Row(
                      children: [
                        AppbarMenu(),
                        SizedBox(width: AppSpacing.md),
                        Expanded(child: RequestRideButton()),
                        SizedBox(width: AppSpacing.md),
                        RideOptionsButton(),
                      ],
                    ),
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
